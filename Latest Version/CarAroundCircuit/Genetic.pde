double[] bestGenes;
int pop = 100;
int rounds = 2000;
int keep = 10;

double getRandomBestLap(double[][][] basePoints, double ratio)
{
  double sigmaStart = 0.60;
  double sigmaEnd   = 0.08;
  double randomRestartChance = 0.15;

  double[][] pool = new double[pop][steps];
  double[] fit = new double[pop];

  double[][] elite = new double[keep][steps];
  double[] eliteFit = new double[keep];
  for (int i = 0; i < keep; i++) eliteFit[i] = Double.POSITIVE_INFINITY;

  bestGenes = new double[steps];
  double bestEver = Double.POSITIVE_INFINITY;

  for (int p = 0; p < pop; p++) randomGenome(pool[p]);

  for (int r = 0; r < rounds; r++)
  {

    double a = (rounds <= 1) ? 1.0 : (double)r / (double)(rounds - 1);
    double sigma = sigmaStart + (sigmaEnd - sigmaStart) * a;

    for (int p = 0; p < pop; p++)
    {
      fit[p] = evalLapSeconds(basePoints, pool[p], ratio);
      tryInsertElite(pool[p], fit[p], elite, eliteFit);

      if (fit[p] < bestEver)
      {
        bestEver = fit[p];
        arrayCopy(pool[p], bestGenes);
      }
    }

    for (int p = 0; p < pop; p++)
    {
      if ((double)random(0f, 1f) < randomRestartChance)
      {
        randomGenome(pool[p]);
        continue;
      }
      int idx = biasedPick(keep);
      arrayCopy(elite[idx], pool[p]);
      mutateGenome(pool[p], sigma);
    }
  }
  
  println();

  stroke(128, 0, 128);
  strokeWeight(4);
  noFill();

  beginShape();
  for (int i = 0; i < steps; i++)
  {
    double g = bestGenes[i];
    if (g < -1) g = -1;
    if (g >  1) g =  1;
    double t = 0.5 * (g + 1.0);

    double xL = basePoints[0][i][0];
    double yL = basePoints[0][i][1];
    double xR = basePoints[2][i][0];
    double yR = basePoints[2][i][1];

    vertex((float)(xL + t * (xR - xL)), (float)(yL + t * (yR - yL)));
  }
  endShape();

  stroke(0);
  strokeWeight(2);

  return bestEver;
}

double evalLapSeconds(double[][][] basePoints, double[] genes, double ratio)
{
  double[][][] p = new double[3][steps][2];

  for (int i = 0; i < steps; i++)
  {
    double g = genes[i];
    if (g < -1) g = -1;
    if (g >  1) g =  1;

    double t = 0.5 * (g + 1.0);

    double xL = basePoints[0][i][0];
    double yL = basePoints[0][i][1];
    double xR = basePoints[2][i][0];
    double yR = basePoints[2][i][1];

    p[0][i][0] = xL;
    p[0][i][1] = yL;
    p[2][i][0] = xR;
    p[2][i][1] = yR;
    p[1][i][0] = xL + t * (xR - xL);
    p[1][i][1] = yL + t * (yR - yL);
  }

  double[][][] rad = radius(p, steps, ratio);
  double[][][] spd = maxSpeed(rad, steps);
  double[][][] tel = carAroundTrack(spd, ratio, steps);
  double[][] times = lapTime(tel, spd, steps, ratio);

  double s = times[1][0] * 60.0 + times[1][1];
  if (Double.isNaN(s) || Double.isInfinite(s)) return Double.POSITIVE_INFINITY;
  return s;
}

void randomGenome(double[] g)
{
  for (int i = 0; i < steps; i++)
    g[i] = (double)random(-1f, 1f);
}

void mutateGenome(double[] g, double sigma)
{
  for (int i = 0; i < steps; i++)
  {
    double n = ((double)random(-1f, 1f) +
                (double)random(-1f, 1f) +
                (double)random(-1f, 1f)) / 3.0;
    g[i] += sigma * n;
    if (g[i] < -1) g[i] = -1;
    if (g[i] >  1) g[i] =  1;
  }
  smoothGenome(g, 1);
}

void smoothGenome(double[] g, int passes)
{
  double[] t = new double[steps];
  for (int p = 0; p < passes; p++)
  {
    t[0] = g[0];
    t[steps-1] = g[steps-1];
    for (int i = 1; i < steps - 1; i++)
      t[i] = 0.25 * g[i-1] + 0.50 * g[i] + 0.25 * g[i+1];
    arrayCopy(t, g);
  }
}

int biasedPick(int keep)
{
  int a = (int)random(keep);
  int b = (int)random(keep);
  int c = (int)random(keep);
  return min(a, min(b, c));
}

void tryInsertElite(double[] cand, double f, double[][] elite, double[] eliteFit)
{
  int w = 0;
  for (int i = 1; i < eliteFit.length; i++)
    if (eliteFit[i] > eliteFit[w]) w = i;

  if (f >= eliteFit[w]) return;

  eliteFit[w] = f;
  arrayCopy(cand, elite[w]);

  for (int i = 0; i < eliteFit.length - 1; i++)
  {
    int b = i;
    for (int j = i + 1; j < eliteFit.length; j++)
      if (eliteFit[j] < eliteFit[b]) b = j;

    if (b != i)
    {
      double tf = eliteFit[i];
      eliteFit[i] = eliteFit[b];
      eliteFit[b] = tf;

      double[] tg = elite[i];
      elite[i] = elite[b];
      elite[b] = tg;
    }
  }
}

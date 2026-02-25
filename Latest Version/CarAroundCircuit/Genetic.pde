// =========================================================
// GENETIC ALGORITHM BASED ON YOUR PROVIDED STRUCTURE (PDE)
// =========================================================

// --- GA knobs ---
int generations = 5000;
int population  = 50;
int elites      = 5;

// Each "genome" chooses, for each step, a point between outer(0) and inner(2)
// gene[p][j] in [0..1]
float[][] genes;
float[][] nextGenes;

// Track best 5 per generation: [gen][rank 0..4][0=x, 1=y, 2=time]
// We'll store just time in [2], and optionally put start-point x/y in [0]/[1] as placeholders.
// (If you want the full best line saved, store the genes instead—see note below.)
double[][][] bestTimes;

// Reusable buffers to avoid allocations in tight loops
float[] lineX, lineY;
float[] radius, vMax, v;


// =========================================================
// MAIN ENTRY (matches your signature)
// points[lane][step][0=x,1=y]
// ratio: pixels per meter conversion used as meters = pixels/ratio
// steps: number of points around lap
// =========================================================
double getGeneticBestLap(double [][][] points, double ratio, int steps)
{
  // --- allocate once ---
  bestTimes = new double[generations][5][3];
  genes     = new float[population][steps];
  nextGenes = new float[population][steps];

  lineX  = new float[steps];
  lineY  = new float[steps];
  radius = new float[steps];
  vMax   = new float[steps];
  v      = new float[steps];

  // init bestTimes to +INF
  for (int i = 0; i < generations; i++) {
    for (int k = 0; k < 5; k++) bestTimes[i][k][2] = Double.POSITIVE_INFINITY;
  }

  // init population genes random in [0..1]
  for (int p = 0; p < population; p++) {
    for (int j = 0; j < steps; j++) genes[p][j] = (float)random(1);
    smoothGenesInPlace(genes[p], steps, 2); // optional smoothing like a sane person
  }

  // Car/tyre parameters (replace these with your own functions)
  float tyresMu = (float)getTyres()[0];     // if your getTyres()[0] is friction-like
  float accel   = (float)getAcceleration();
  float decel   = abs((float)getDeceleration());
  if (decel < 1e-6f) decel = 1e-6f;

  double globalBest = Double.POSITIVE_INFINITY;

  for(int i = 0; i < generations; i++)
  {
    // -------------------------------------------------
    // Evaluate each individual in this generation
    // -------------------------------------------------
    for(int p = 0; p < population; p++)
    {
      // choose a point along line between outer (0) and inner (2) for all steps
      // Build racing line from genes[p][j]
      for (int j = 0; j < steps; j++) {
        float t = genes[p][j];
        float x0 = (float)points[0][j][0];
        float y0 = (float)points[0][j][1];
        float x2 = (float)points[2][j][0];
        float y2 = (float)points[2][j][1];
        lineX[j] = lerp(x0, x2, t);
        lineY[j] = lerp(y0, y2, t);
      }

      // Calculate radius + max speed at each point
      for(int j = 0; j < steps; j++)
      {
        int jm1 = (j - 1 + steps) % steps;
        int jp1 = (j + 1) % steps;

        float r = (float)getRadius(
          lineX[jm1], lineY[jm1],
          lineX[j],   lineY[j],
          lineX[jp1], lineY[jp1]
        );
        // guard straights / numeric issues
        if (Float.isInfinite(r) || r > 1e12f) r = 1e12f;
        if (r < 1e-6f) r = 1e-6f;

        radius[j] = r;

        // Your original formula idea: sqrt(mu*g*radius)
        vMax[j] = sqrt(tyresMu * 9.81f * radius[j]);
      }

      // Get telemetry by adapting your code for a single lap
      // (Here we compute the speed profile v[] using accel/brake passes)
      float[] telemetryV = getTelemetry(lineX, lineY, vMax, accel, decel, (float)ratio, steps);

      // Compute lap time
      double laptime = getLapTime(lineX, lineY, telemetryV, (float)ratio, steps);

      // track best 5 of this generation (your original bestTimes idea)
      insertIntoBest5(bestTimes[i], lineX[0], lineY[0], laptime);

      if (laptime < globalBest) globalBest = laptime;
    }

    // -------------------------------------------------
    // GA: Selection + Crossover + Mutation -> nextGenes
    // -------------------------------------------------

    // Sort population indices by fitness (lap time) using this generation’s best ranking
    // We need fitness for every p; simplest: recompute a lightweight fitness array.
    // (Still uses existing buffers, no big allocations.)
    double[] fitness = new double[population];
    for (int p = 0; p < population; p++) {
      // quick fitness: evaluate again is simplest baseline; if this is too slow,
      // cache laptimes per p in an array during evaluation.
      fitness[p] = evaluateIndividual(genes[p], points, (float)ratio, steps, tyresMu, accel, decel);
    }

    int[] order = argsortByFitness(fitness); // best first

    // Elitism: copy top elites unchanged
    for (int e = 0; e < elites; e++) {
      int src = order[e];
      arrayCopy(genes[src], nextGenes[e]);
    }

    // Fill remainder
    for (int idx = elites; idx < population; idx++) {
      int p1 = tournamentPick(order, fitness, 3);
      int p2 = tournamentPick(order, fitness, 3);

      // crossover -> nextGenes[idx]
      crossoverTwoPoint(genes[p1], genes[p2], nextGenes[idx], steps);

      // mutate
      mutate(nextGenes[idx], steps, 0.08f, 0.15f);

      // optional smoothing mutation
      if (random(1) < 0.25f) smoothGenesInPlace(nextGenes[idx], steps, 1);
    }

    // swap generations
    float[][] tmp = genes;
    genes = nextGenes;
    nextGenes = tmp;
  }

  return globalBest;
}


// =========================================================
// TELEMETRY (your structure, filled in)
// Returns speed profile v[steps] (float[]).
// =========================================================
float[] getTelemetry(float[] x, float[] y, float[] vMax, float accel, float decel, float ratio, int steps)
{
  // forward pass
  v[0] = min(0.0f, vMax[0]);
  for (int i = 1; i < steps; i++) {
    float s = dist(x[i], y[i], x[i-1], y[i-1]) / ratio;
    float vPrev = v[i-1];
    float vCalc = sqrt(vPrev*vPrev + 2.0f * accel * s);
    v[i] = min(vCalc, vMax[i]);
  }

  // backward pass
  for (int i = steps - 2; i >= 0; i--) {
    float s = dist(x[i], y[i], x[i+1], y[i+1]) / ratio;
    float vNext = v[i+1];
    float vBrake = sqrt(vNext*vNext + 2.0f * decel * s);
    if (vBrake < v[i]) v[i] = vBrake;
  }

  return v; // reuse buffer
}


// =========================================================
// LAP TIME (your structure, filled in)
// =========================================================
double getLapTime(float[] x, float[] y, float[] v, float ratio, int steps)
{
  double totalTime = 0.0;

  for (int i = 1; i < steps; i++) {
    float s = dist(x[i], y[i], x[i-1], y[i-1]) / ratio;
    float vi = v[i];
    if (vi > 1e-6f) totalTime += (double)(s / vi);
    else totalTime += 1e9;
  }

  return totalTime;
}


// =========================================================
// Radius helper (circumcircle radius through 3 points)
// Keep your getRadius(...) signature if you already have one.
// =========================================================
double getRadius(float x1,float y1,float x2,float y2,float x3,float y3)
{
  float a = dist(x2,y2,x3,y3);
  float b = dist(x1,y1,x3,y3);
  float c = dist(x1,y1,x2,y2);

  float cross = abs((x2-x1)*(y3-y1) - (y2-y1)*(x3-x1));
  if (cross < 1e-6f) return Double.POSITIVE_INFINITY;

  float area = cross * 0.5f;
  return (double)(a*b*c) / (double)(4.0f*area);
}


// =========================================================
// Best-5 insert (shifts down)
// bestRow[k][2] holds time
// =========================================================
void insertIntoBest5(double[][] bestRow, float x0, float y0, double time)
{
  for (int k = 0; k < 5; k++) {
    if (time < bestRow[k][2]) {
      // shift down
      for (int s = 4; s > k; s--) {
        bestRow[s][0] = bestRow[s-1][0];
        bestRow[s][1] = bestRow[s-1][1];
        bestRow[s][2] = bestRow[s-1][2];
      }
      bestRow[k][0] = x0;
      bestRow[k][1] = y0;
      bestRow[k][2] = time;
      return;
    }
  }
}


// =========================================================
// Fitness evaluation helper for GA reproduction step
// (baseline: evaluates lap time for a given gene[])
// =========================================================
double evaluateIndividual(float[] gene, double[][][] points, float ratio, int steps,
                          float tyresMu, float accel, float decel)
{
  for (int j = 0; j < steps; j++) {
    float t = gene[j];
    float x0 = (float)points[0][j][0];
    float y0 = (float)points[0][j][1];
    float x2 = (float)points[2][j][0];
    float y2 = (float)points[2][j][1];
    lineX[j] = lerp(x0, x2, t);
    lineY[j] = lerp(y0, y2, t);
  }

  for (int j = 0; j < steps; j++) {
    int jm1 = (j - 1 + steps) % steps;
    int jp1 = (j + 1) % steps;
    float r = (float)getRadius(lineX[jm1], lineY[jm1], lineX[j], lineY[j], lineX[jp1], lineY[jp1]);
    if (Float.isInfinite(r) || r > 1e12f) r = 1e12f;
    if (r < 1e-6f) r = 1e-6f;
    vMax[j] = sqrt(tyresMu * 9.81f * r);
  }

  float[] vv = getTelemetry(lineX, lineY, vMax, accel, decel, ratio, steps);
  return getLapTime(lineX, lineY, vv, ratio, steps);
}


// =========================================================
// GA utilities (minimal, PDE-friendly)
// =========================================================
int[] argsortByFitness(double[] fitness)
{
  int n = fitness.length;
  int[] idx = new int[n];
  for (int i = 0; i < n; i++) idx[i] = i;

  // selection sort (n is small)
  for (int i = 0; i < n - 1; i++) {
    int best = i;
    for (int j = i + 1; j < n; j++) {
      if (fitness[idx[j]] < fitness[idx[best]]) best = j;
    }
    int tmp = idx[i]; idx[i] = idx[best]; idx[best] = tmp;
  }
  return idx;
}

int tournamentPick(int[] order, double[] fitness, int k)
{
  int best = order[(int)random(order.length)];
  for (int i = 1; i < k; i++) {
    int cand = order[(int)random(order.length)];
    if (fitness[cand] < fitness[best]) best = cand;
  }
  return best;
}

void crossoverTwoPoint(float[] a, float[] b, float[] child, int steps)
{
  int p1 = (int)random(steps);
  int p2 = (int)random(steps);
  if (p1 > p2) { int t = p1; p1 = p2; p2 = t; }

  for (int i = 0; i < steps; i++) {
    child[i] = (i >= p1 && i <= p2) ? a[i] : b[i];
  }
}

void mutate(float[] gene, int steps, float rate, float stdDev)
{
  for (int i = 0; i < steps; i++) {
    if (random(1) < rate) {
      float delta = (float)randomGaussian() * stdDev;
      gene[i] = constrain(gene[i] + delta, 0, 1);
    }
  }
}

void smoothGenesInPlace(float[] gene, int steps, int passes)
{
  for (int p = 0; p < passes; p++) {
    for (int i = 1; i < steps - 1; i++) {
      gene[i] = (gene[i-1] + gene[i] + gene[i+1]) / 3.0f;
    }
  }
}

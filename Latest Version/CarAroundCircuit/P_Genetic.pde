int generations = 2000;
int population  = 150;
int elites      = 15;

float[][] genes, nextGenes;
double[] currentFitness;
float[] lineX, lineY, v;
float[] geneticVMax; 
float[] bestVisualX, bestVisualY;
boolean hasBestLine = false;

double getGeneticBestLap(double[][][] points, double ratio, int steps, double tyre) {
  genes = new float[population][steps];
  nextGenes = new float[population][steps];
  currentFitness = new double[population];
  lineX = new float[steps]; 
  lineY = new float[steps];
  v = new float[steps];
  geneticVMax = new float[steps];
  bestVisualX = new float[steps];
  bestVisualY = new float[steps];

  for (int p = 0; p < population; p++) {
    for (int j = 0; j < steps; j++) {
      genes[p][j] = random(0.0f, 1.0f);
    }
    smoothGenesInPlace(genes[p], steps, 5);
  }

  double globalBest = Double.MAX_VALUE;

  for (int i = 0; i < generations; i++) {
    for (int p = 0; p < population; p++) {
      generateSplinePath(genes[p], points, steps);
      calculatePhysics((float)tyre, steps, ratio); 
      getTelemetry((float)getAcceleration(),(float)getDeceleration(),(float)ratio,steps);
      currentFitness[p] = getLapTime((float)ratio, steps);

      if (currentFitness[p] < globalBest) {
        globalBest = currentFitness[p];
        updateBestVisual(steps);
      }
    }
    evolve(steps, i);
  }
  return globalBest;
}

void generateSplinePath(float[] genome, double[][][] points, int steps) {
  for (int i = 0; i < steps; i++) {
    lineX[i] = lerp((float)points[0][i][0], (float)points[2][i][0], genome[i]);
    lineY[i] = lerp((float)points[0][i][1], (float)points[2][i][1], genome[i]);
  }
}

void calculatePhysics(float mu, int steps, double ratio) {
  for (int j = 0; j < steps; j++) {
    int prev = (j - 1 + steps) % steps;
    int next = (j + 1) % steps;
    double r = getRadius(lineX[prev], lineY[prev], lineX[j], lineY[j], lineX[next], lineY[next], ratio);
    geneticVMax[j] = sqrt(mu * 9.81f * (float)r);
  }
  geneticVMax[steps - 1] = 400;
}

void getTelemetry(float acc, float dec, float ratio, int steps) {
  v[0] = 0.0f;
  for (int i = 1; i < steps; i++) {
    float s = dist(lineX[i-1], lineY[i-1], lineX[i], lineY[i]) / ratio;
    v[i] = min(sqrt(sq(v[i-1]) + 2 * acc * s), geneticVMax[i]);
  }
  for (int i = steps - 2; i >= 0; i--) {
    float s = dist(lineX[i], lineY[i], lineX[i+1], lineY[i+1]) / ratio;
    float vBrake = sqrt(sq(v[i+1]) + 2 * dec * s);
    if (vBrake < v[i]) v[i] = vBrake;
  }
}

double getLapTime(float ratio, int steps) {
  double total = 0;
  for (int i = 1; i < steps; i++) {
    float s = dist(lineX[i-1], lineY[i-1], lineX[i], lineY[i]) / ratio;
    total += (v[i] > 0.1) ? (s / v[i]) : 1000;
  }
  return total;
}

void updateBestVisual(int steps) {
  if (bestVisualX == null || bestVisualX.length != steps) {
    bestVisualX = new float[steps];
    bestVisualY = new float[steps];
  }
  arrayCopy(lineX, bestVisualX);
  arrayCopy(lineY, bestVisualY);
  hasBestLine = true;
}

void drawBestLine() {
  if (!hasBestLine) return;
  noFill();
  stroke(147, 0, 211);
  strokeWeight(4);
  beginShape();
  for (int i = 0; i < bestVisualX.length; i++) {
    curveVertex(bestVisualX[i], bestVisualY[i]);
  }
  endShape(CLOSE);
  strokeWeight(2);
}

double getRadius(float x1, float y1, float x2, float y2, float x3, float y3, double ratio) {
  double a = dist(x1, y1, x2, y2);
  double b = dist(x2, y2, x3, y3);
  double c = dist(x3, y3, x1, y1);
  double area = abs(x1*(y2-y3) + x2*(y3-y1) + x3*(y1-y2)) * 0.5;
  double hold = (area < 0.01) ? 10000 : (a * b * c) / (4 * area);
  hold = hold / ratio;
  return hold;
}

void evolve(int steps, int currentGen) {
  float progress = (float)currentGen / generations; 
  float power = lerp(0.15f, 0.02f, progress);
  int[] order = argsortByFitness(currentFitness);

  for (int e = 0; e < elites; e++) {
    int srcIndex = order[e];
    arrayCopy(genes[srcIndex], nextGenes[e]);
  }

  for (int idx = elites; idx < population; idx++) {
    int p1 = tournamentPick(currentFitness, 6);
    int p2 = tournamentPick(currentFitness, 6);
    crossoverArithmetic(genes[p1], genes[p2], nextGenes[idx], steps);
    mutate(nextGenes[idx], steps, 0.08f, power); 
    if (random(1) < 0.4f) {
      smoothGenesInPlace(nextGenes[idx], steps, 3);
    }
  }

  for (int p = 0; p < population; p++) {
    arrayCopy(nextGenes[p], genes[p]);
  }
}

int tournamentPick(double[] fitness, int k) {
  int best = (int)random(population);
  for (int i = 1; i < k; i++) {
    int contender = (int)random(population);
    if (fitness[contender] < fitness[best]) {
      best = contender;
    }
  }
  return best;
}

void crossoverArithmetic(float[] p1, float[] p2, float[] child, int steps) {
  float weight = random(0.2, 0.8);
  for (int i = 0; i < steps; i++) {
    child[i] = (p1[i] * weight) + (p2[i] * (1.0f - weight));
  }
}

void mutate(float[] g, int steps, float rate, float power) {
  for (int i = 0; i < steps; i++) {
    if (random(1) < rate) {
      float change = random(-power, power);
      int window = 5; 
      for(int w = -window; w <= window; w++) {
        int idx = (i + w + steps) % steps;
        g[idx] += change * (1.0 - abs(w)/(float)window);
        g[idx] = constrain(g[idx], 0.0f, 1.0f);
      }
    }
  }
}

int[] argsortByFitness(double[] fitness) {
  int[] indices = new int[population];
  for (int i = 0; i < population; i++) indices[i] = i;
  for (int i = 0; i < population - 1; i++) {
    for (int j = i + 1; j < population; j++) {
      if (fitness[indices[j]] < fitness[indices[i]]) {
        int temp = indices[i];
        indices[i] = indices[j];
        indices[j] = temp;
      }
    }
  }
  return indices;
}

void smoothGenesInPlace(float[] g, int steps, int passes) {
  for (int p = 0; p < passes; p++) {
    for (int i = 0; i < steps; i++) {
      g[i] = (g[(i-1+steps)%steps] + g[i] + g[(i+1)%steps]) / 3.0f;
    }
  }
}

double[][] getGeneticStint(double[][][] points, double ratio, int steps, double[] tyres, int laps, double trackLength) {
  double[][] stints = new double[3][laps + 1];

  double softDegradation = 0.1;
  double mediumDegradation = 0.05;
  double hardDegradation = 0.025;

  for (int i = 0; i < 3; i++) {
    stints[i][0] = 0.0;

    fuel = (laps + 1) * (trackLength / 1000.0 * 2.5);

    for (int j = 1; j <= laps; j++) {
      double tyrelife;
      if (i == 0)      tyrelife = tyres[0] - (softDegradation * j);
      else if (i == 1) tyrelife = tyres[1] - (mediumDegradation * j);
      else             tyrelife = tyres[2] - (hardDegradation * j);
      if(tyrelife < 0.1)
      {
        tyrelife = 0.1;
      }
      fuel = fuel - (trackLength/1000.0 * 2.5);

      double time = getGeneticBestLap(points, ratio, steps, tyrelife);
      if(time > 200)
      {
      stints[i][j] = 200;
      }
      else
      {
        stints[i][j] = time;
        stints[i][0] += stints[i][j];
      }
      
    }
  }
  return stints;
}

void getGeneticStats(double[][][] points, double ratio, int steps, double[] tyres) {
  int laps = 30;
  double[][] lapTimes = new double[3][laps];
  double [] mean = new double[3];
  double [] standardDeviation = new double [3];
  for (int i = 0; i < 3; i++) {
    for(int j = 0; j < laps; j++)
    {
      double time = getGeneticBestLap(points, ratio, steps, tyres[i]);
      lapTimes [i][j] = (double)time;
    }
    mean[i] = mean(lapTimes[i]);
    standardDeviation[i] = 0;
    for(int j = 0; j < laps; j++)    {
      standardDeviation[i] += pow((float)(lapTimes[i][j] - mean[i]), 2);
    }
    standardDeviation[i] = sqrt((float)(standardDeviation[i] / laps));
  }
  if(bahrain)
  {
    println("Track: Bahrain");
  }
  else if(brands)
  {
    println("Track: Brands");
  }
  else
  {
    println("Track: Circle");
  }
  println(laps + " laps per tyre, generations: " + generations + ", population: " + population + ", elites: " + elites);
  println("Tyre Type\tMean Lap Time\tStandard Deviation\tCoefficient of Variation");
  println("Soft\t\t" + String.format("%.2f", mean[0]) + "\t\t" + String.format("%.2f", standardDeviation[0]) + "\t\t" + String.format("%.4f%%", (standardDeviation[0]/mean[0]) * 100));
  println("Medium\t\t" + String.format("%.2f", mean[1]) + "\t\t" + String.format("%.2f", standardDeviation[1]) + "\t\t" + String.format("%.4f%%", (standardDeviation[1]/mean[1]) * 100));
  println("Hard\t\t" + String.format("%.2f", mean[2]) + "\t\t" + String.format("%.2f", standardDeviation[2]) + "\t\t" + String.format("%.4f%%", (standardDeviation[2]/mean[2]) * 100));

  }

double mean(double[] values) {
  double sum = 0;
  for (double val : values) {
    sum += val;
  } 
  return sum / values.length;
}

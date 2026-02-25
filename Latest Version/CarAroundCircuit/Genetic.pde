// --- GA Globals ---
int generations = 5000;
int population  = 50;
int elites      = 5;

float[][] genes, nextGenes;
double[] currentFitness;
float[] lineX, lineY, vMax, v;

// --- Visualization Globals ---
float[] bestVisualX, bestVisualY;
boolean hasBestLine = false;

// =========================================================
// THE SPLINE-BASED GA LOGIC
// =========================================================
double getGeneticBestLap(double[][][] points, double ratio, int steps) {
  // 1. Initialization
  genes = new float[population][steps];
  nextGenes = new float[population][steps];
  currentFitness = new double[population];
  lineX = new float[steps]; 
  lineY = new float[steps];
  vMax = new float[steps]; 
  v = new float[steps];
  bestVisualX = new float[steps];
  bestVisualY = new float[steps];

  // 2. Initial Population (Moved inside the function)
  for (int p = 0; p < population; p++) {
    for (int j = 0; j < steps; j++) {
      genes[p][j] = random(0.0f, 1.0f); // Now covers 0 to 100% of your offset
    }
    smoothGenesInPlace(genes[p], steps, 5);
  }

  double globalBest = Double.MAX_VALUE;

  // 3. Evolution Loop
  for (int i = 0; i < generations; i++) {
    for (int p = 0; p < population; p++) {
      generateSplinePath(genes[p], points, steps);
      calculatePhysics(1.2f, steps); 
      getTelemetry(5.0f, 8.0f, (float)ratio, steps);
      currentFitness[p] = getLapTime((float)ratio, steps);

      if (currentFitness[p] < globalBest) {
        globalBest = currentFitness[p];
        updateBestVisual(steps);
      }
    }
    evolve(steps);
  }
  return globalBest;
}

void generateSplinePath(float[] genome, double[][][] points, int steps) {
  for (int i = 0; i < steps; i++) {
    // Correctly lerps between Inner (0) and Outer (2) boundaries
    lineX[i] = lerp((float)points[0][i][0], (float)points[2][i][0], genome[i]);
    lineY[i] = lerp((float)points[0][i][1], (float)points[2][i][1], genome[i]);
  }
}

// 2. Physics & Curvature
void calculatePhysics(float mu, int steps) {
  for (int j = 0; j < steps; j++) {
    int prev = (j - 1 + steps) % steps;
    int next = (j + 1) % steps;
    double r = getRadius(lineX[prev], lineY[prev], lineX[j], lineY[j], lineX[next], lineY[next]);
    vMax[j] = sqrt(mu * 9.81f * (float)r);
  }
}

// 3. Telemetry Pass
void getTelemetry(float acc, float dec, float ratio, int steps) {
  v[0] = min(15.0f, vMax[0]);
  for (int i = 1; i < steps; i++) {
    float s = dist(lineX[i-1], lineY[i-1], lineX[i], lineY[i]) / ratio;
    v[i] = min(sqrt(sq(v[i-1]) + 2 * acc * s), vMax[i]);
  }
  for (int i = steps - 2; i >= 0; i--) {
    float s = dist(lineX[i], lineY[i], lineX[i+1], lineY[i+1]) / ratio;
    float vBrake = sqrt(sq(v[i+1]) + 2 * dec * s);
    if (vBrake < v[i]) v[i] = vBrake;
  }
}

// 4. Lap Time Calculation
double getLapTime(float ratio, int steps) {
  double total = 0;
  for (int i = 1; i < steps; i++) {
    float s = dist(lineX[i-1], lineY[i-1], lineX[i], lineY[i]) / ratio;
    total += (v[i] > 0.1) ? (s / v[i]) : 1000;
  }
  return total;
}

// =========================================================
// VISUALIZATION & HELPERS
// =========================================================
void updateBestVisual(int steps) {
  if (bestVisualX == null || bestVisualX.length != steps) {
    bestVisualX = new float[steps];
    bestVisualY = new float[steps];
  }
  arrayCopy(lineX, bestVisualX); // Safe copy now
  arrayCopy(lineY, bestVisualY);
  hasBestLine = true;
}

void drawBestLine() {
  if (!hasBestLine) return;
  noFill();
  stroke(147, 0, 211); // Purple
  strokeWeight(4);
  beginShape();
  for (int i = 0; i < bestVisualX.length; i++) {
    // curveVertex creates the smooth spline visually
    curveVertex(bestVisualX[i], bestVisualY[i]);
  }
  endShape(CLOSE);
  strokeWeight(2);
}

double getRadius(float x1, float y1, float x2, float y2, float x3, float y3) {
  double a = dist(x1, y1, x2, y2);
  double b = dist(x2, y2, x3, y3);
  double c = dist(x3, y3, x1, y1);
  double area = abs(x1*(y2-y3) + x2*(y3-y1) + x3*(y1-y2)) * 0.5;
  return (area < 0.01) ? 10000 : (a * b * c) / (4 * area);
}

// =========================================================
// EVOLUTIONARY STEP (Selection, Crossover, Mutation)
// =========================================================
void evolve(int steps) {
  // 1. Sort the current population by lap time (lowest is best)
  int[] order = argsortByFitness(currentFitness);

  // 2. Elitism: Directly copy the top performers to the next generation
  for (int e = 0; e < elites; e++) {
    int srcIndex = order[e];
    arrayCopy(genes[srcIndex], nextGenes[e]);
  }

  // 3. Fill the rest of the population
  for (int idx = elites; idx < population; idx++) {
    // Tournament selection: pick two parents
    int p1 = tournamentPick(currentFitness, 3);
    int p2 = tournamentPick(currentFitness, 3);

    // Combine parents (Crossover)
    crossoverTwoPoint(genes[p1], genes[p2], nextGenes[idx], steps);

    // Randomly change some genes (Mutation)
    mutate(nextGenes[idx], steps, 0.05f, 0.12f);

    // Occasional smoothing mutation to keep the line "drivable"
    if (random(1) < 0.2f) {
      smoothGenesInPlace(nextGenes[idx], steps, 1);
    }
  }

  // 4. Swap the generations: nextGenes becomes the current genes
  for (int p = 0; p < population; p++) {
    arrayCopy(nextGenes[p], genes[p]);
  }
}

// --- Helper: Tournament Selection ---
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

// --- Helper: Crossover ---
void crossoverTwoPoint(float[] p1, float[] p2, float[] child, int steps) {
  int cp1 = (int)random(steps);
  int cp2 = (int)random(steps);
  if (cp1 > cp2) { int t = cp1; cp1 = cp2; cp2 = t; }

  for (int i = 0; i < steps; i++) {
    child[i] = (i >= cp1 && i <= cp2) ? p1[i] : p2[i];
  }
}

// --- Helper: Mutation ---
// Increase power if the track is wide (e.g., power = 0.15f)
void mutate(float[] g, int steps, float rate, float power) {
  for (int i = 0; i < steps; i++) {
    if (random(1) < rate) {
      g[i] += random(-power, power);
      // STRICT CONSTRAINT: Ensure genes never exceed the 0.0-1.0 range
      // which represents the boundaries set by your 'offset'
      if (g[i] < 0.0f) g[i] = 0.0f;
      if (g[i] > 1.0f) g[i] = 1.0f;
    }
  }
}

// --- Helper: Sort indices by fitness ---
int[] argsortByFitness(double[] fitness) {
  int[] indices = new int[population];
  for (int i = 0; i < population; i++) indices[i] = i;
  
  // Simple selection sort for the indices
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

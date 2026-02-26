// --- GA Globals ---
int generations = 2000;
int population  = 150;
int elites      = 15;

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
      double[] tyres = getTyres();
      calculatePhysics((float)tyres[0], steps, ratio); 
      getTelemetry(5.0f, 8.0f, (float)ratio, steps);
      currentFitness[p] = getLapTime((float)ratio, steps);

      if (currentFitness[p] < globalBest) {
        globalBest = currentFitness[p];
        updateBestVisual(steps);
      }
    }
    // Inside the for (int i = 0; i < generations; i++) loop:
    evolve(steps, i); // Pass 'i' so the function knows which generation it's on

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
void calculatePhysics(float mu, int steps, double ratio) {
  for (int j = 0; j < steps; j++) {
    int prev = (j - 1 + steps) % steps;
    int next = (j + 1) % steps;
    double r = getRadius(lineX[prev], lineY[prev], lineX[j], lineY[j], lineX[next], lineY[next],ratio);
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

double getRadius(float x1, float y1, float x2, float y2, float x3, float y3, double ratio) {
  double a = dist(x1, y1, x2, y2);
  double b = dist(x2, y2, x3, y3);
  double c = dist(x3, y3, x1, y1);
  double area = abs(x1*(y2-y3) + x2*(y3-y1) + x3*(y1-y2)) * 0.5;
  double hold = (area < 0.01) ? 10000 : (a * b * c) / (4 * area);
  hold = hold / ratio;
  return hold;
}

// =========================================================
// EVOLUTIONARY STEP (Selection, Crossover, Mutation)
// =========================================================
void evolve(int steps, int currentGen) { // Added 'currentGen' here
  
  // Calculate how far along we are (0.0 to 1.0)
  float progress = (float)currentGen / generations; 
  
  // Calculate Mutation Power: Starts at 0.15 (wide search) and 'cools' to 0.02 (fine-tuning)
  float power = lerp(0.15f, 0.02f, progress);
  
  // ... (rest of your sorting and elitism code stays the same
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
    int p1 = tournamentPick(currentFitness, 6);
    int p2 = tournamentPick(currentFitness, 6);

    // Combine parents (Crossover)
    // Replace the old crossoverTwoPoint line with this:
    crossoverArithmetic(genes[p1], genes[p2], nextGenes[idx], steps);


    // Randomly change some genes (Mutation)
    // Change this line inside the population loop:
    mutate(nextGenes[idx], steps, 0.08f, power); 


    // Increase probability to 40% and passes to 3-5 for high step counts
    if (random(1) < 0.4f) {
      smoothGenesInPlace(nextGenes[idx], steps, 3);
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

void crossoverArithmetic(float[] p1, float[] p2, float[] child, int steps) {
  float weight = random(0.2, 0.8);
  for (int i = 0; i < steps; i++) {
    // Blends the two parents instead of cutting them
    child[i] = (p1[i] * weight) + (p2[i] * (1.0f - weight));
  }
}

void mutate(float[] g, int steps, float rate, float power) {
  for (int i = 0; i < steps; i++) {
    if (random(1) < rate) {
      float change = random(-power, power);
      // Mutate a window of 5-10 points to keep the curve logical
      int window = 5; 
      for(int w = -window; w <= window; w++) {
        int idx = (i + w + steps) % steps;
        g[idx] += change * (1.0 - abs(w)/(float)window); // Taper the effect
        g[idx] = constrain(g[idx], 0.0f, 1.0f);
      }
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

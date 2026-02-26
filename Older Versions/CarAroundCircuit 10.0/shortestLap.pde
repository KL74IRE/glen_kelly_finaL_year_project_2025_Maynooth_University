// Global arrays for results
double[] shortestSpeeds; 
double[] shortestVmax;
double[] xShortest;
double[] yShortest;

double getShortestLap(double[][][] points, double ratio, int steps) {
  // 1. Initialize GA environment and global arrays
  genes = new float[population][steps];
  nextGenes = new float[population][steps];
  currentFitness = new double[population];
  
  lineX = new float[steps]; 
  lineY = new float[steps];
  v = new float[steps];
  geneticVMax = new float[steps];
  
  shortestSpeeds = new double[steps];
  shortestVmax   = new double[steps];
  xShortest      = new double[steps];
  yShortest      = new double[steps];

  // 2. Initial Population: Randomly distribute between inner (0) and outer (2)
  for (int p = 0; p < population; p++) {
    for (int j = 0; j < steps; j++) {
      genes[p][j] = random(0.0f, 1.0f);
    }
    smoothGenesInPlace(genes[p], steps, 5);
  }

  double globalShortestDist = Double.MAX_VALUE;

  // 3. Evolution Loop: Optimizing for DISTANCE
  for (int i = 0; i < generations; i++) {
    for (int p = 0; p < population; p++) {
      generateSplinePath(genes[p], points, steps);
      
      // Calculate total physical distance of this specific genome
      double totalDist = 0;
      for (int j = 1; j < steps; j++) {
        totalDist += dist(lineX[j-1], lineY[j-1], lineX[j], lineY[j]);
      }
      
      // Fitness is distance (lower is better)
      currentFitness[p] = totalDist;

      // If this is the shortest path found so far, update globals
      if (currentFitness[p] < globalShortestDist) {
        globalShortestDist = currentFitness[p];
        
        // 1. Calculate physics for this specific shortest path
        double[] tyres = getTyres();
        calculatePhysics((float)tyres[0], steps, ratio); 
        getTelemetry(5.0f, 8.0f, (float)ratio, steps);
        
        // 2. Store into global arrays for external use
        for (int k = 0; k < steps; k++) {
          xShortest[k] = (double)lineX[k];
          yShortest[k] = (double)lineY[k];
          shortestSpeeds[k] = (double)v[k];
          shortestVmax[k]   = (double)geneticVMax[k];
        }
        
        updateBestVisual(steps);
      }
    }
    // Evolve the population based on distance fitness
    evolve(steps, i);
  }

  // 4. Return the time it takes to drive this shortest path
  // (Using the speeds calculated during the best record update)
  double finalLapTime = 0;
  for (int i = 1; i < steps; i++) {
    double s = dist((float)xShortest[i-1], (float)yShortest[i-1], 
                    (float)xShortest[i],   (float)yShortest[i]) / ratio;
    finalLapTime += (shortestSpeeds[i] > 0.1) ? (s / shortestSpeeds[i]) : 0;
  }
  
  return finalLapTime;
}

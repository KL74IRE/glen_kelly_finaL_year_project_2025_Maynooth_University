double[] shortestSpeeds; 
double[] shortestVmax;
double[] xShortest;
double[] yShortest;

double getShortestLap(double[][][] points, double ratio, int steps) {
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

  for (int p = 0; p < population; p++) {
    for (int j = 0; j < steps; j++) {
      genes[p][j] = random(0.0f, 1.0f);
    }
    smoothGenesInPlace(genes[p], steps, 5);
  }

  double globalShortestDist = Double.MAX_VALUE;

  for (int i = 0; i < generations; i++) {
    for (int p = 0; p < population; p++) {
      generateSplinePath(genes[p], points, steps);
      double totalDist = 0;
      for (int j = 1; j < steps; j++) {
        totalDist += dist(lineX[j-1], lineY[j-1], lineX[j], lineY[j]);
      }
      currentFitness[p] = totalDist;
      if (currentFitness[p] < globalShortestDist) {
        globalShortestDist = currentFitness[p];
        double[] tyres = getTyres();
        calculatePhysics((float)tyres[0], steps, ratio); 
        getTelemetry((float)getAcceleration(),(float)getDeceleration(),(float)ratio,steps);
        for (int k = 0; k < steps; k++) {
          xShortest[k] = (double)lineX[k];
          yShortest[k] = (double)lineY[k];
          shortestSpeeds[k] = (double)v[k];
          shortestVmax[k]   = (double)geneticVMax[k];
        }
        updateBestVisual(steps);
      }
    }
    evolve(steps, i);
  }

  double finalLapTime = 0;
  for (int i = 1; i < steps; i++) {
    double s = dist((float)xShortest[i-1], (float)yShortest[i-1], 
                    (float)xShortest[i],   (float)yShortest[i]) / ratio;
    finalLapTime += (shortestSpeeds[i] > 0.1) ? (s / shortestSpeeds[i]) : 0;
  }
  
  return finalLapTime;
}

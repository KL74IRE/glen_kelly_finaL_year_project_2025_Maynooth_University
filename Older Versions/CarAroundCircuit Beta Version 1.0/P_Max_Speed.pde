double [] [] [] maxSpeed(double [] [] [] radius, int steps) {
  double [] tyres = getTyres();
  double [] [] [] Speeds = new double [3] [steps] [6];
    
  for (int j = 0; j < 3; j++) {
    for (int i = 0; i < steps; i++) {
      Speeds[j][i][0] = radius[j][i][0];
      Speeds[j][i][1] = radius[j][i][1];
      Speeds[j][i][2] = radius[j][i][2];
      Speeds[j][i][3] = Math.sqrt((float)tyres[0] * 9.81 * (float)radius[j][i][2]);
      Speeds[j][i][4] = Math.sqrt((float)tyres[1] * 9.81 * (float)radius[j][i][2]);
      Speeds[j][i][5] = Math.sqrt((float)tyres[2] * 9.81 * (float)radius[j][i][2]);
    }
    Speeds[j][steps-1][0] = Speeds[j][0][0];
    Speeds[j][steps-1][1] = Speeds[j][0][1];
    Speeds[j][steps-1][2] = Speeds[j][0][2];
    Speeds[j][steps-1][3] = Speeds[j][0][3];
    Speeds[j][steps-1][4] = Speeds[j][0][4];
    Speeds[j][steps-1][5] = Speeds[j][0][5];
    for (int i = 0; i < steps; i++) {
      if (Speeds[j][i][3] > 360) { Speeds[j][i][3] = 365; }
      if (Speeds[j][i][4] > 360) { Speeds[j][i][4] = 365; }
      if (Speeds[j][i][5] > 360) { Speeds[j][i][5] = 365; }
    }
  }
  return Speeds;
}

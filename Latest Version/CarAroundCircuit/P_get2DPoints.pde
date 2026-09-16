int offset = 10;

double[][][] get2DPoints(double[][] trackPoints, int steps, boolean trackLines) {
  double[][][] Points = new double[3][steps][2];
  for (int i = 0; i < steps; i++) {
    Points[1][i][0] = trackPoints[i][0];
    Points[1][i][1] = trackPoints[i][1];
  }
  for (int i = 0; i < steps; i++) {
    int iPrev = (i == 0) ? 0 : i - 1;
    int iNext = (i == steps - 1) ? steps - 1 : i + 1;
    double xPrev = trackPoints[iPrev][0];
    double yPrev = trackPoints[iPrev][1];
    double xNext = trackPoints[iNext][0];
    double yNext = trackPoints[iNext][1];
    double dx = xNext - xPrev;
    double dy = yNext - yPrev;
    double nx = -dy;
    double ny = dx;
    double len = Math.sqrt(nx * nx + ny * ny);
    if (len == 0) {
      Points[0][i][0] = Points[1][i][0];
      Points[0][i][1] = Points[1][i][1];
      Points[2][i][0] = Points[1][i][0];
      Points[2][i][1] = Points[1][i][1];
      continue;
    }
    nx /= len;
    ny /= len;
    double xA = trackPoints[i][0];
    double yA = trackPoints[i][1];
    Points[0][i][0] = xA + offset * nx;
    Points[0][i][1] = yA + offset * ny;
    Points[2][i][0] = xA - offset * nx;
    Points[2][i][1] = yA - offset * ny;
    if (trackLines) {
      stroke(#008080);
      strokeWeight(5);
      point((float)Points[0][i][0], (float)Points[0][i][1]);
      point((float)Points[1][i][0], (float)Points[1][i][1]);
      point((float)Points[2][i][0], (float)Points[2][i][1]);
      stroke(0);
      strokeWeight(2);
    }
  }
  return Points;
}

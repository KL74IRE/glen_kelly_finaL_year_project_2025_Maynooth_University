double[][][] radius(double[][][] points, int steps, double ratio) {
  double[][][] radius = new double[3][steps][3];
  for (int i = 0; i < 3; i++) {
    radius[i][0][0] = points[i][0][0];
    radius[i][0][1] = points[i][0][1];
    radius[i][0][2] = getRadius(
      points[i][steps - 2][0], points[i][steps - 2][1],
      points[i][0][0], points[i][0][1],
      points[i][1][0], points[i][1][1]
    ) / ratio;

    radius[i][steps - 1][0] = points[i][steps - 1][0];
    radius[i][steps - 1][1] = points[i][steps - 1][1];
    radius[i][steps - 1][2] = getRadius(
      points[i][steps - 2][0], points[i][steps - 2][1],
      points[i][steps - 1][0], points[i][steps - 1][1],
      points[i][1][0], points[i][1][1]
    ) / ratio;

    for (int j = 1; j < steps - 1; j++) {
      radius[i][j][0] = points[i][j][0];
      radius[i][j][1] = points[i][j][1];
      radius[i][j][2] = getRadius(
        points[i][j - 1][0], points[i][j - 1][1],
        points[i][j][0], points[i][j][1],
        points[i][j + 1][0], points[i][j + 1][1]
      ) / ratio;
    }
  }
  return radius;
}

double getRadius(double x1, double y1, double x2, double y2, double x3, double y3) {
  double d = 2 * (x1 * (y2 - y3) + x2 * (y3 - y1) + x3 * (y1 - y2));
  double cx = (
    (x1 * x1 + y1 * y1) * (y2 - y3) +
    (x2 * x2 + y2 * y2) * (y3 - y1) +
    (x3 * x3 + y3 * y3) * (y1 - y2)
  ) / d;
  double cy = (
    (x1 * x1 + y1 * y1) * (x3 - x2) +
    (x2 * x2 + y2 * y2) * (x1 - x3) +
    (x3 * x3 + y3 * y3) * (x2 - x1)
  ) / d;
  double radius = Math.sqrt((x1 - cx) * (x1 - cx) + (y1 - cy) * (y1 - cy));
  return radius;
}

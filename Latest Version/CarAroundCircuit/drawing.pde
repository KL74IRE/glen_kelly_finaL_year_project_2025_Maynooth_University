import org.apache.commons.math3.analysis.UnivariateFunction;
import org.apache.commons.math3.analysis.interpolation.SplineInterpolator;
import org.apache.commons.math3.analysis.polynomials.PolynomialSplineFunction;

void drawTrack(double[] x, double[] y, int steps, double offset)
{
  if (x.length < 3) return;
  double[] s = new double[x.length];
  s[0] = 0;
  for (int i = 1; i < x.length; i++) {
    double dx = x[i] - x[i - 1];
    double dy = y[i] - y[i - 1];
    double d  = Math.sqrt(dx * dx + dy * dy);
    if (d == 0) d = 1e-9;
    s[i] = s[i - 1] + d;
  }

  SplineInterpolator interpolator = new SplineInterpolator();
  PolynomialSplineFunction splineX = interpolator.interpolate(s, x);
  PolynomialSplineFunction splineY = interpolator.interpolate(s, y);

  UnivariateFunction dX = splineX.derivative();
  UnivariateFunction dY = splineY.derivative();

  double totalLen = s[s.length - 1];
  double startDistance = totalLen / 3.0;
  double endDistance   = 2.0 * totalLen / 3.0;

  if (steps < 2) steps = 2;
  double interval = (endDistance - startDistance) / (steps - 1);

  stroke(255, 0, 0);
  strokeWeight(2);
  noFill();

  beginShape();
  for (int j = 0; j < steps; j++)
  {
    double t = startDistance + j * interval;

    double cx = splineX.value(t);
    double cy = splineY.value(t);

    double tx = dX.value(t);
    double ty = dY.value(t);

    double nx = -ty;
    double ny =  tx;
    double len = Math.sqrt(nx*nx + ny*ny);
    if (len == 0) len = 1;
    nx /= len; ny /= len;

    vertex((float)(cx + offset * nx),
           (float)(cy + offset * ny));
  }
  endShape();

  stroke(0, 0, 255);

  beginShape();
  for (int j = 0; j < steps; j++)
  {
    double t = startDistance + j * interval;
    vertex((float)splineX.value(t),
           (float)splineY.value(t));
  }
  endShape();
  
  stroke(255, 165, 0);

  beginShape();
  for (int j = 0; j < steps; j++)
  {
    double t = startDistance + j * interval;

    double cx = splineX.value(t);
    double cy = splineY.value(t);

    double tx = dX.value(t);
    double ty = dY.value(t);

    double nx = -ty;
    double ny =  tx;
    double len = Math.sqrt(nx*nx + ny*ny);
    if (len == 0) len = 1;
    nx /= len; ny /= len;

    vertex((float)(cx - offset * nx),
           (float)(cy - offset * ny));
  }
  endShape();
  
  stroke(0);
}

void drawPoints(double x, double y, color c, double weight) {
  stroke(c);
  strokeWeight((float)weight);
  point((float)x, (float)y);
  stroke(0);
  strokeWeight(2);
}

void visualisationAllLanes(
  double[] x, double[] y,
  double[][][] speeds,
  double[][][] telemetry,
  int steps,
  boolean waypoints,
  boolean points,
  boolean speedLabels,
  boolean telemetryLabels,
  double[][] lapTime
){
  if (waypoints) drawWaypoints(x, y);

  if (points) drawPointIndices(speeds[1], steps);

  drawLane(speeds[0], telemetry[0], steps, speedLabels, telemetryLabels, #FF0000, #7A00FF);
  drawLane(speeds[1], telemetry[1], steps, speedLabels, telemetryLabels, #0066FF, #4B0082);
  drawLane(speeds[2], telemetry[2], steps, speedLabels, telemetryLabels, #FF8800, #4B0082);

  drawLapTimesHUD(lapTime);
}

void drawWaypoints(double[] x, double[] y) {
  for (int i = 0; i < x.length; i++) drawPoints(x[i], y[i], #9D00FF, 25);
}

double slopeBetween(double[][] pts, int i, int steps) {
  int next = (i < steps - 1) ? (i + 1) : 0;
  double dx = pts[next][0] - pts[i][0];
  double dy = pts[next][1] - pts[i][1];
  if (Math.abs(dx) < 1e-9) return (dy >= 0) ? 1e9 : -1e9;
  return dy / dx;
}

void drawLabelAtPoint(
  double x, double y,
  int i,
  double slope,
  String label,
  float dxEven, float dxOdd,
  float dyNormalEven, float dyNormalOdd,
  float dyFirst
){
  if (slope > 1 || slope < -1) {
    if (i % 2 == 0) text(label, (float)x + dxEven, (float)y);
    else            text(label, (float)x + dxOdd,  (float)y);
    return;
  }
  if (i == 0) {
    text(label, (float)x, (float)y + dyFirst);
    return;
  }
  if (i % 2 == 0) text(label, (float)x, (float)y + dyNormalEven);
  else            text(label, (float)x, (float)y + dyNormalOdd);
}

void drawPointIndices(double[][] speedsLane, int steps) {
  for (int i = 0; i < steps; i++) {
    fill(#FF0000);
    double slope = slopeBetween(speedsLane, i, steps);
    String label = "" + i;

    drawLabelAtPoint(
      speedsLane[i][0], speedsLane[i][1],
      i, slope, label,
      15, -15,
      16.5, -16.5,
      -10
    );

    drawPoints(speedsLane[i][0], speedsLane[i][1], #FF0000, 5);
  }
}

void drawLane(
  double[][] speedsLane, double[][] telemetryLane,
  int steps,
  boolean speedLabels, boolean telemetryLabels,
  int laneColour, int telemetryTextColour
){
  for (int i = 0; i < steps; i++) {
    drawPoints(speedsLane[i][0], speedsLane[i][1], laneColour, 5);
  }

  if (speedLabels) {
    textSize(8);
    for (int i = 0; i < steps; i++) {
      fill(laneColour);
      double slope = slopeBetween(speedsLane, i, steps);
      String label = nf((float)speedsLane[i][2], 3, 1);

      drawLabelAtPoint(
        speedsLane[i][0], speedsLane[i][1],
        i, slope, label,
        15, -65,
        16.5, -16.5,
        -5
      );
    }
  }

  if (telemetryLabels) {
    textSize(8);
    for (int i = 0; i < steps; i++) {
      fill(telemetryTextColour);
      double slope = slopeBetween(telemetryLane, i, steps);
      String label = nf((float)telemetryLane[i][2], 3, 1);

      drawLabelAtPoint(
        telemetryLane[i][0], telemetryLane[i][1],
        i, slope, label,
        35, -85,
        36.5, -36.5,
        -25
      );
    }
  }
}

void drawLapTimesHUD(double[][] lapTime) {
  textSize(16);
  fill(#FFFFFF);

  String t0 = String.format("Lane 0: %.0f:%05.2f", lapTime[0][0], lapTime[0][1]);
  String t1 = String.format("Lane 1: %.0f:%05.2f", lapTime[1][0], lapTime[1][1]);
  String t2 = String.format("Lane 2: %.0f:%05.2f", lapTime[2][0], lapTime[2][1]);
  String t3 = String.format("Optimal: %.0f:%05.2f", lapTime[3][0], lapTime[3][1]);

  text(t0, 50, 50);
  text(t1, 50, 70);
  text(t2, 50, 90);
  text(t3, 50, 110);
}

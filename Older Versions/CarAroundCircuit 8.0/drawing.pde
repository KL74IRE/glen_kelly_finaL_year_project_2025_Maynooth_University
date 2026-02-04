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

void visualisation(double [] x, double [] y, double [][] speeds, double [] [] telemetry, int steps, boolean waypoints, boolean points, boolean speed, boolean telemetryS, double [] lapTime)
{
  
  if(waypoints)
  {
    for(int i = 0; i < x.length; i++)
    {
      drawPoints(x[i],y[i], #9D00FF, 25);
    }
  }
  
  if(points)
  {
    for(int i = 0; i < steps; i++)
    {
      fill(#FF0000);
      double slope = 0;
      if(i<steps-1)
      {
        slope = (speeds [i+1][1]-speeds [i][1])/(speeds [i+1][0]-speeds [i][0]);
      }
      else
      {
        slope = (speeds [0][1]-speeds [i][1])/(speeds [0][0]-speeds [i][0]);
      }
      if(slope > 1 || slope < -1)
      {
        if(i % 2 == 0)
        {
        text(i, (float)speeds [i][0] +15, (float) speeds [i][1]);
        }
        else
        {
        text(i, (float)speeds [i][0] -15, (float) speeds [i][1]);
        }
      }
      else if(i==0)
      {
        text(i, (float)speeds [i][0], (float) speeds [i][1]-10);
      }
      else
      {
        if(i % 2 == 0)
        {
        text(i, (float)speeds [i][0], (float) speeds [i][1] +16.5);
        }
        else
        {
        text(i, (float)speeds [i][0], (float) speeds [i][1] -16.5);
        }
      }
      drawPoints(speeds [i][0] , speeds [i][1], #FF0000, 5);
    }
  }
   textSize(8); 
  if(speed)
  {
    for(int i = 0; i < steps; i++)
    {
      fill(#FF0000);
      double slope = 0;
      if(i<steps-1)
      {
        slope = (speeds [i+1][1]-speeds [i][1])/(speeds [i+1][0]-speeds [i][0]);
      }
      else
      {
        slope = (speeds [0][1]-speeds [i][1])/(speeds [0][0]-speeds [i][0]);
      }
      if(slope > 1 || slope < -1)
      {
        if(i % 2 == 0){
        text(nf((float)speeds[i][2],3,1), (float)speeds [i][0] +15, (float) speeds [i][1]);
        }
        else
        {
        text(nf((float)speeds[i][2],3,1), (float)speeds [i][0] -65, (float) speeds [i][1]);
        }
      }
      else if(i==0)
      {
        text(nf((float)speeds[i][2],3,1), (float)speeds [i][0], (float) speeds [i][1]-5);
      }
      else
      {
        if(i % 2 == 0){
        text(nf((float)speeds[i][2],3,1), (float)speeds [i][0], (float) speeds [i][1] + 16.5);
        }else{
        text(nf((float)speeds[i][2],3,1), (float)speeds [i][0], (float) speeds [i][1] - 16.5);
        }
      }
      drawPoints(speeds [i][0] , speeds [i][1], #FF0000, 5);
    }
  }
  
  if(telemetryS)
  {
    for(int i = 0; i < steps; i++)
    {
      fill(#4B0082);
      double slope = 0;
      if(i<steps-1)
      {
        slope = (telemetry [i+1][1]-telemetry [i][1])/(telemetry [i+1][0]-telemetry [i][0]);
      }
      else
      {
        slope = (telemetry [0][1]-telemetry [i][1])/(telemetry [0][0]-telemetry [i][0]);
      }
      if(slope > 1 || slope < -1)
      {
        if(i % 2 == 0){
        text(nf((float)telemetry[i][2],3,1), (float)telemetry [i][0] +35, (float) telemetry [i][1]);
        }
        else
        {
        text(nf((float)telemetry[i][2],3,1), (float)telemetry [i][0] -85, (float) telemetry [i][1]);
        }
      }
      else if(i==0)
      {
        text(nf((float)telemetry[i][2],3,1), (float)telemetry [i][0], (float) telemetry [i][1]-25);
      }
      else
      {
        if(i % 2 == 0){
        text(nf((float)telemetry[i][2],3,1), (float)telemetry [i][0], (float) telemetry [i][1] + 36.5);
        }else{
        text(nf((float)telemetry[i][2],3,1), (float)telemetry [i][0], (float) telemetry [i][1] - 36.5);
        }
      }
      drawPoints(telemetry [i][0] , telemetry [i][1], #FF0000, 5);
    }
  }
  
  textSize(20); 
  fill(#FF0000);
  String lap = String.format("%.0f:%05.2f", lapTime[0], lapTime[1]);
  text(lap, (float)50, (float)50);
}

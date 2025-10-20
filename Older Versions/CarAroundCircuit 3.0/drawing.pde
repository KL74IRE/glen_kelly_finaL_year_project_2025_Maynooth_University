import org.apache.commons.math3.analysis.interpolation.SplineInterpolator;
import org.apache.commons.math3.analysis.polynomials.PolynomialSplineFunction;

PolynomialSplineFunction splineX;
PolynomialSplineFunction splineY;

double[][] drawTrack(double[] x, double[] y, int start, int end, int steps)
{
  double[] s = new double[x.length];
  s[0] = 0;
  for (int i = 1; i < x.length; i++) {
    double dx = x[i] - x[i - 1];
    double dy = y[i] - y[i - 1];
    s[i] = s[i - 1] + Math.sqrt(dx * dx + dy * dy);
  }

  SplineInterpolator interpolator = new SplineInterpolator();
  splineX = interpolator.interpolate(s, x);
  splineY = interpolator.interpolate(s, y);
  double startDistance = s[Math.min(start, s.length-1)];
  double endDistance   = s[Math.max(0, s.length - end + 1)];
  double interval = (endDistance - startDistance) / (steps - 1);

  stroke(0);
  strokeWeight(2);
  noFill();
  beginShape();

  double[][] trackPoints = new double[steps][2];
  for (int j = 0; j < steps; j++) {
    double t = startDistance + j * interval;
    double tx = splineX.value(t);
    double ty = splineY.value(t);
    vertex((float) tx, (float) ty);
    trackPoints[j][0] = tx;
    trackPoints[j][1] = ty;
  }
  vertex((float) trackPoints[0][0], (float) trackPoints[0][1]);
  trackPoints[steps - 1][0] = trackPoints[0][0];
  trackPoints[steps - 1][1] = trackPoints[0][1];

  endShape();

  return trackPoints;
}


void drawPoints(double x, double y, color c, double weight) {
  stroke(c);
  strokeWeight((float)weight);
  point((float)x, (float)y);
  stroke(0);
  strokeWeight(2);
}

void visualisation(double [] x, double [] y, double [][] speeds, int steps, boolean waypoints, boolean points, boolean speed)
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
        text( (float)speeds [i][4] + " Km/h", (float)speeds [i][0] +15, (float) speeds [i][1]);
        }
        else
        {
        text( (float)speeds [i][4] + " Km/h", (float)speeds [i][0] -65, (float) speeds [i][1]);
        }
      }
      else if(i==0)
      {
        text( (float)speeds [i][4] + " Km/h", (float)speeds [i][0], (float) speeds [i][1]-5);
      }
      else
      {
        if(i % 2 == 0){
        text( (float)speeds [i][4] + " Km/h", (float)speeds [i][0], (float) speeds [i][1] + 16.5);
        }else{
        text( (float)speeds [i][4] + " Km/h", (float)speeds [i][0], (float) speeds [i][1] - 16.5);
        }
      }
      drawPoints(speeds [i][0] , speeds [i][1], #FF0000, 5);
    }
  }
}

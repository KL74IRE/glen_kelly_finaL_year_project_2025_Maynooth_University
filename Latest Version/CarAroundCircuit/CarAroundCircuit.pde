import org.apache.commons.math3.analysis.interpolation.SplineInterpolator;
import org.apache.commons.math3.analysis.polynomials.PolynomialSplineFunction;
PrintWriter output;

PolynomialSplineFunction splineX;
PolynomialSplineFunction splineY;

void setup() {
  size(1280, 800);
  background(255);

  brandsHatch();
  //basicCircle();
}

void brandsHatch()
{
    boolean showWaypoints = false;
    boolean showPoints = true;
    boolean showSpeeds = true;
    int steps = 40;
    int mTrackLength = 1944;
    double[] x = getXBrands();  //Get X
    double[] y = getYBrands();  //Get Y
    double ratio = ratio(x,y,20,21,steps,mTrackLength);
    double [] [] trackPoints = drawTrack(x,y,20,21,steps); //X points, Y points, Start of 2nd Run, End of 2nd Run, Points for 1 lap, Length in m desired
    double [] [] radius = radius(trackPoints,steps,ratio);
    double [] [] speeds = maxSpeed(radius,steps);
    visualisation(x,y,speeds,steps,showWaypoints,showPoints,showSpeeds);
    carAroundTrack(trackPoints,speeds);
}

void basicCircle()
{
    int steps = 1000000;
    int mTrackLength = 1944;
    double[] x = getXBrands();  //Get X
    double[] y = getYBrands();  //Get Y
    double ratio = ratio(x,y,4,5,steps,mTrackLength);
    double [] [] trackPoints = drawTrack(x,y,4,5,steps); //X points, Y points, Start of 2nd Run, End of 2nd Run, Points for 1 lap, Length in m desired
    double [] [] radius = radius(trackPoints,steps,ratio);
    double [] [] speeds = maxSpeed(radius,steps);
}

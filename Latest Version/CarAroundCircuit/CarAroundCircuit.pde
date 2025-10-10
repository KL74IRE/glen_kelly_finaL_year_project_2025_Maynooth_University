import org.apache.commons.math3.analysis.interpolation.SplineInterpolator;
import org.apache.commons.math3.analysis.polynomials.PolynomialSplineFunction;

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
    int steps = 100;
    int mTrackLength = 1944;
    double[] x = getXBrands();  //Get X
    double[] y = getYBrands();  //Get Y
    double ratio = ratio(x,y,20,21,steps,mTrackLength);
    double [] [] trackPoints = drawTrack(x,y,20,21,steps); //X points, Y points, Start of 2nd Run, End of 2nd Run, Points for 1 lap, Length in m desired
    double [] [] radius = radius(trackPoints,steps,ratio);
    double [] [] speeds = maxSpeed(radius,steps);
    carAroundTrack(trackPoints,speeds);
}

//void basicCircle()
//{
//    int steps = 40;
//    double[] x = getXCircle();  //Get X
//    double[] y = getYCircle();  //Get Y
//    double trackLength = trackLength(x,y,20,21,steps);
//    double [] [] trackPoints = drawTrack(x,y,4,5,steps);      //X points, Y points, Start of 2nd Run, End of 2nd Run, Points for 1 lap, Length in m desired
//    double [] tyreCompounds = getTyres();
//    //double [] [] speeds = maxSpeed(radius,steps, tyreCompounds);
//}

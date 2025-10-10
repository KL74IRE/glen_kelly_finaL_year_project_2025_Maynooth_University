import org.apache.commons.math3.analysis.interpolation.SplineInterpolator;
import org.apache.commons.math3.analysis.polynomials.PolynomialSplineFunction;

PolynomialSplineFunction splineX;
PolynomialSplineFunction splineY;

void setup() {
  size(1280, 800);
  background(255);

  brandsHatch();
  basicCircle();
}

void brandsHatch()
{
    double[] x = getXBrands();  //Get X
    double[] y = getYBrands();  //Get Y
    drawTrack(x,y,20,21,10000); //X points, Y points, Start of 2nd Run, End of 2nd Run, Points for 1 lap
}

void basicCircle()
{
    double[] x = getXCircle();  //Get X
    double[] y = getYCircle();  //Get Y
    drawTrack(x,y,4,5,80);      //X points, Y points, Start of 2nd Run, End of 2nd Run, Points for 1 lap
}

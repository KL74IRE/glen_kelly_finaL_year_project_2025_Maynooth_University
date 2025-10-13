import org.apache.commons.math3.analysis.interpolation.SplineInterpolator;
import org.apache.commons.math3.analysis.polynomials.PolynomialSplineFunction;
PrintWriter output;

PolynomialSplineFunction splineX;
PolynomialSplineFunction splineY;

void setup() {
  size(1280, 800);
  background(255);
  int steps = 100;
  brandsHatch(steps);
  basicCircle(steps);
}

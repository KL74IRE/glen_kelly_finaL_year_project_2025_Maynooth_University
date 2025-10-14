import org.apache.commons.math3.analysis.interpolation.SplineInterpolator;
import org.apache.commons.math3.analysis.polynomials.PolynomialSplineFunction;
PrintWriter output;

PolynomialSplineFunction splineX;
PolynomialSplineFunction splineY;

void setup() {
  size(1920, 980);
  background(255);
  int steps = 20;
  boolean excel = false;
  boolean showWaypoints = false;
  boolean showPoints = false;
  boolean showSpeeds = true;
  
  editingMode();
  //brandsHatch(steps,excel,showWaypoints,showPoints,showSpeeds);
  //basicCircle(steps,excel,showWaypoints,showPoints,showSpeeds);
  //bahrain(steps,excel,showWaypoints,showPoints,showSpeeds);
}

import org.apache.commons.math3.analysis.interpolation.SplineInterpolator;
import org.apache.commons.math3.analysis.polynomials.PolynomialSplineFunction;

double [] [] maxSpeed(double [] [] radius, int steps, double [] tyres)
{
  double [] [] Speeds = new double [steps] [2];
  for(int i = 0; i < steps; i++)
  {
    Speeds [i] [0] = i;
    Speeds [i] [1] = Math.sqrt(((float)tyres[1])*(9.81)*((float)radius [i] [1]));
  }
  
  for(int i = 0; i < steps; i++)
  {
    println("point: "+ nf(i,3,0) + ", t = " +  nf((float)(radius [i][0]),2,5) + ", radius = " +  nf((float)(radius [i][1]),4,5) +"m , Max Theoretical Speed:" + nf((float)Speeds [i] [1],3,3)+ "m/s / "+ nf((float)(3.6*(Speeds [i] [1])),3,3)+ "km/h");

  }
  
  return Speeds;
}

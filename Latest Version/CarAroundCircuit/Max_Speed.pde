import org.apache.commons.math3.analysis.interpolation.SplineInterpolator;
import org.apache.commons.math3.analysis.polynomials.PolynomialSplineFunction;

double [] [] maxSpeed(double [] [] radius, int steps)
{
  double [] tyres = getTyres();
  double [] [] Speeds = new double [steps] [6];
  for(int i = 0; i < steps; i++)
  {
    Speeds [i] [0] = radius [i] [0];                                                 //x
    Speeds [i] [1] = radius [i] [1];                                                 //y
    Speeds [i] [2] = radius [i] [2];                                                 //radius
    Speeds [i] [3] = (3.6*(Math.sqrt(((float)tyres[0])*(9.81)*((float)radius [i] [2]))));    //Soft
    Speeds [i] [4] = (3.6*(Math.sqrt(((float)tyres[1])*(9.81)*((float)radius [i] [2]))));    //Medium
    Speeds [i] [5] = (3.6*(Math.sqrt(((float)tyres[2])*(9.81)*((float)radius [i] [2]))));    //Hard
  }
  
  for(int i = 0; i < steps; i++)
  {
    println("Point: " + nf((float)i,3,0) +", x = " + nf(i, 3, 0) + ", y = " + nf((float)(radius[i][0]), 3, 5) + ", radius = " + nf((float)(radius[i][1]), 4, 5) + "m" + ", Max Speed (Soft): " + nf((float)(Speeds[i][3]), 4, 3) + "km/h" + " (Medium): " + nf((float)(Speeds[i][4]), 4, 3) + "km/h" + " (Hard): " + nf((float)(Speeds[i][5]), 4, 3) + "km/h");
  }
  
  return Speeds;
}

/*
Method to calculate the max speed of a corner based off a radius

Method should be able to call a method to get tyre data,
should be able to generate a 2D array and fill it with the co-ordinates and radius,
should be able to calculate the max speed of the corner for each tyre compound
*/

double [] [] [] maxSpeed(double [] [] [] radius, int steps)
{
  double [] tyres = getTyres();                                                               //Get tyre data
  double [] [] [] Speeds = new double [3] [steps] [6];                                               //Set up 2D array data
    
  for(int j = 0; j<3; j++)
  {
    for(int i = 0; i < steps; i++)                                                              //For all spline points
    {
      Speeds [j] [i] [0] = radius [j] [i] [0];                                                            //get x value
      Speeds [j] [i] [1] = radius [j] [i] [1];                                                            //get y value
      Speeds [j] [i] [2] = radius [j] [i] [2];                                                            //get radius
      Speeds [j] [i] [3] = ((Math.sqrt(((float)tyres[0])*(9.81)*((float)radius [j] [i] [2]))));       //Calculate Soft tyre max speed
      Speeds [j] [i] [4] = ((Math.sqrt(((float)tyres[1])*(9.81)*((float)radius [j] [i] [2]))));       //Calculate Medium tyre max speed
      Speeds [j] [i] [5] = ((Math.sqrt(((float)tyres[2])*(9.81)*((float)radius [j] [i] [2]))));       //Calculate Hard tyre max speed
    }
    
      Speeds [j] [steps-1] [0] = Speeds [j] [0] [0];                                                    //Set x value for Start Finish points to equal
      Speeds [j] [steps-1] [1] = Speeds [j] [0] [1];                                                    //Set y value for Start Finish points to equal
      Speeds [j] [steps-1] [2] = Speeds [j] [0] [2];                                                    //Set radius value for Start Finish points to equal
      Speeds [j] [steps-1] [3] = Speeds [j] [0] [3];                                                    //Set soft speed for Start Finish points to equal
      Speeds [j] [steps-1] [4] = Speeds [j] [0] [4];                                                    //Set medium speed for Start Finish points to equal
      Speeds [j] [steps-1] [5] = Speeds [j] [0] [5];                                                    //Set hard speed for Start Finish points to equal
      
    for(int i = 0; i < steps; i++)
    {
      if(Speeds [j] [i] [3] > 360)
      {Speeds [j] [i] [3] = 365;}
      if(Speeds [j] [i] [4] > 360)
      {Speeds [j] [i] [4] = 365;}
      if(Speeds [j] [i] [5] > 360)
      {Speeds [j] [i] [5] = 365;}
    }
  }
  
  return Speeds;                                                                              //return data
}

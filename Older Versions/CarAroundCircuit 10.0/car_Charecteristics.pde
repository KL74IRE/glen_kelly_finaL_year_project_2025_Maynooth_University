public double mass = 1200;
public double fuel = 300;

double getAcceleration()
{
  double force = 4500;
  double acceleration = force/(mass+fuel);
  
  return acceleration;
}

double getDeceleration()
{
  double force = 6000;
  double deceleration = force/(mass+fuel);
  
  return deceleration;
}

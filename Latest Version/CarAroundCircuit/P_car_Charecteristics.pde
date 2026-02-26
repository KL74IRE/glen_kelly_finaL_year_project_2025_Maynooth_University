public double mass = 1200;
public double fuel = 300;

double getAcceleration() {
  double force = 4500;
  double acceleration = force / (mass + fuel);
  return acceleration;
}

double getDeceleration() {
  double force = 6000;
  double deceleration = force / (mass + fuel);
  return deceleration;
}

double[] getTyres() {
  double soft = 1.2;
  double medium = 1.1;
  double hard = 1.0;
  double[] tyres = new double[3];
  tyres[0] = soft;
  tyres[1] = medium;
  tyres[2] = hard;
  return tyres;
}

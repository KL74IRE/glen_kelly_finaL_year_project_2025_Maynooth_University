public double mass = 1200;
public double fuel = 300;

double getAcceleration() {
  double force = 4600;
  double acceleration = force / (mass + fuel);
  return acceleration;
}

double getDeceleration() {
  double force = 5000;
  double deceleration = force / (mass + fuel);
  return deceleration;
}

double[] getTyres() {
  double soft = 1.4;
  double medium = 1.1;
  double hard = 0.8;
  double[] tyres = new double[3];
  tyres[0] = soft;
  tyres[1] = medium;
  tyres[2] = hard;
  return tyres;
}

PImage img;

void editingMode() {
  if (brands) {
    editBrands();
  } else if (bahrain) {
    editBahrain();
  } else if (circle) {
    editCircle();
  }
}

void editBrands() {
  img = loadImage("brands.jpg");
  img.resize(1450, 980);
  image(img, 150, 0);
  double[] x = getXBrands();
  double[] y = getYBrands();
  for (int i = 0; i < x.length; i++) {
    drawPoints(x[i], y[i], #9D00FF, 25);
  }
}

void editBahrain() {
  img = loadImage("bahrain.png");
  image(img, 0, -50);
  double[] x = getXBahrain();
  double[] y = getYBahrain();
  for (int i = 0; i < x.length; i++) {
    drawPoints(x[i], y[i], #9D00FF, 25);
  }
}

void editCircle() {
  double[] x = getXCircle();
  double[] y = getYCircle();
  for (int i = 0; i < x.length; i++) {
    drawPoints(x[i], y[i], #9D00FF, 25);
  }
}

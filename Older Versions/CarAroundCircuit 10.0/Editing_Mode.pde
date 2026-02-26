PImage img;                                     //Initialise an instance of an image

/*
Method should enable editing mode for whichever tracks are enabled

Method should enable whichever tracks are not commented out
*/
void editingMode()
{
  editBrands();
  //editCircle();
  //editBahrain();
}

void editBrands()
{
  img = loadImage("brands.jpg");
  img.resize(1450, 980);
  image(img, 150, 0);
  double[] x = getXBrands();
  double[] y = getYBrands();
  for(int i = 0; i < x.length; i++){
    drawPoints(x[i], y[i], #9D00FF, 25);
  }
}

void editBahrain()
{
  img = loadImage("bahrain.png");
  image(img, 0, -50);
  double[] x = getXBahrain();
  double[] y = getYBahrain();
  for(int i = 0; i < x.length; i++){
    drawPoints(x[i], y[i], #9D00FF, 25);
  }
}

void editCircle()
{
  double[] x = getXCircle();
  double[] y = getYCircle();
  for(int i = 0; i < x.length; i++){
    drawPoints(x[i], y[i], #9D00FF, 25);
  }
}

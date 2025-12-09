PImage img;                                     //Initialise an instance of an image

/*
Method should enable editing mode for whichever tracks are enabled

Method should enable whichever tracks are not commented out
*/
void editingMode()
{
  //editBrands();                               //Edit Brands Hatch Indy Circuit
  //editCircle();                               //Edit Circle
  editBahrain();                              //Edit Bahrain GP Circuit
}

/*
Method should load in reference image for Brands Hatch Indy Circuit and make it easier for editing

Method should load in Brands Hatch Indy Circuit reference,
should draw, scale, place and show the image,
should get waypoints,
should draw all waypoints
*/
void editBrands()
{
  img = loadImage("brands.jpg");                //Initialise Background Image
  img.resize(1450,980);                         //Re-size image
  image(img, 150, 0);                           //Place image
  double [] x = getXBrands();                   //Get x co-ordinates
  double [] y = getYBrands();                   //Get y co-ordinates
  for(int i = 0; i < x.length; i++){            //For all points
    drawPoints(x[i],y[i], #9D00FF, 25);         //Draw Points
  }
}

/*
Method should load in reference image for Bahrain GP Circuit and make it easier for editing

Method should load in Bahrain GP Circuit reference,
should draw, scale, place and show the image,
should get waypoints,
should draw all waypoints
*/

void editBahrain()
{
  img = loadImage("bahrain.png");               //Initialise Background Image
  image(img, 0, -50);                           //Place image
  double [] x = getXBahrain();                  //Get x co-ordinates
  double [] y = getYBahrain();                  //Get y co-ordinates
  for(int i = 0; i < x.length; i++){            //For all points
    drawPoints(x[i],y[i], #9D00FF, 25);         //Draw Points
  }
}

/*
Method should load in circle and make it easier for editing

should get waypoints,
should draw all waypoints
*/

void editCircle()
{
  double [] x = getXCircle();                   //Get x co-ordinates
  double [] y = getYCircle();                   //Get y co-ordinates
  for(int i = 0; i < x.length; i++){            //For all points
    drawPoints(x[i],y[i], #9D00FF, 25);         //Draw Points
  }
}

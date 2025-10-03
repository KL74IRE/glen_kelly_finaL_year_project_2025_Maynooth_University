PImage car;

void setup() {
  size(1280, 800);
  car = loadImage("car.png");
}

void draw() {
  background(255);
  
  Track();
  Points();
  car();
}

void Track()
{
    strokeWeight(2);

  PVector p1 = new PVector(200, 400);
  PVector p2 = new PVector(600, 100);
  PVector p3 = new PVector(1000,400);
  PVector p4 = new PVector(600, 700);
  PVector p5 = new PVector(200, 400); 

  beginShape();
    curveVertex(p1.x, p1.y);
    curveVertex(p1.x, p1.y);
    curveVertex(p2.x, p2.y);
    curveVertex(p3.x, p3.y);
    curveVertex(p4.x, p4.y);
    curveVertex(p1.x, p1.y);
    curveVertex(p2.x, p2.y);
    curveVertex(p3.x, p3.y);
    curveVertex(p4.x, p4.y);
    curveVertex(p1.x, p1.y);
    curveVertex(p2.x, p2.y);
    curveVertex(p3.x, p3.y);
    curveVertex(p4.x, p4.y);
    curveVertex(p5.x, p5.y);
    curveVertex(p5.x, p5.y);
  endShape();
}

void car()
{
  stroke(3);
  image(car, 200, 400,40,40);
}

void Points()
{
  stroke(20);
  strokeWeight(20);
  strokeCap(ROUND);
  
  point(200,400);
  point(600,100);
  point(1000,400);
  point(600,700);
  
}

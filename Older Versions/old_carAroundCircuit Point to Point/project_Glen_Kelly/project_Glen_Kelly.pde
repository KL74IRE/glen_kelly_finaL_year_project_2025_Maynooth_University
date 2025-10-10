PVector[] pts;
ArrayList<PVector> trackPoints;
float carDistance = 0;
float speed = 3;
PImage img;

void setup() {
  size(1280, 800);
  img = loadImage("map.jpg");
  pts = new PVector[] {
    new PVector(395, 470),  //Start-Finish
    new PVector(200, 470),  //Paddock
    new PVector(110, 410),  //Paddock
    new PVector(88, 320),   //Paddock
    new PVector(112, 250),  //Hailwoods
    new PVector(175, 130),  //Druids
    new PVector(240, 94),   //Druids
    new PVector(270, 160),  //Druids
    new PVector(215, 280),  //Graham Hill Bend
    new PVector(235, 345),  //Graham Hill Bend
    new PVector(310, 365),  //Graham Hill Bend
    new PVector(400, 370),  //Cooper Straight
    new PVector(520, 362),  //Surtees
    new PVector(555, 332),  //Surtees
    new PVector(580, 280),  //McLaren
    new PVector(630, 240),  //McLaren
    new PVector(690, 240),  //ClearWays
    new PVector(735, 300),  //Clark Curve
    new PVector(705, 400),  //Clark Curve
    new PVector(600, 460),
  };
  trackPoints = new ArrayList<PVector>();
  generateTrackPoints();
}

void draw() {
  background(255);
  drawTrack();
  showPoints();
  moveCar();
}

void generateTrackPoints() {
  for (int i = 0; i < pts.length; i++) {
    PVector p0 = pts[(i - 1 + pts.length) % pts.length];
    PVector p1 = pts[i % pts.length];
    PVector p2 = pts[(i + 1) % pts.length];
    PVector p3 = pts[(i + 2) % pts.length];
    for (float t = 0; t <= 1; t += 0.005) {
      float x = curvePoint(p0.x, p1.x, p2.x, p3.x, t);
      float y = curvePoint(p0.y, p1.y, p2.y, p3.y, t);
      trackPoints.add(new PVector(x, y));
    }
  }
}

void drawTrack() {
  text("Brands Hatch Indy Circuit", 10,10);
  image(img, 50, 50);
  stroke(0);
  noFill();
  beginShape();
  for (int i = 0; i < pts.length; i++) {
    PVector p0 = pts[(i - 1 + pts.length) % pts.length];
    PVector p1 = pts[i % pts.length];
    PVector p2 = pts[(i + 1) % pts.length];
    PVector p3 = pts[(i + 2) % pts.length];
    for (float t = 0; t <= 1; t += 0.005) {
      float x = curvePoint(p0.x, p1.x, p2.x, p3.x, t);
      float y = curvePoint(p0.y, p1.y, p2.y, p3.y, t);
      vertex(x, y);
    }
  }
  endShape(CLOSE);
}

void showPoints() {
  fill(0);
  noStroke();
  for (PVector p : pts) {
    ellipse(p.x, p.y, 10, 10);
  }
}

void moveCar() {
  carDistance += speed;
  if (carDistance >= trackPoints.size()) carDistance = 0;
  int idx = (int)carDistance;
  int nextIdx = (idx + 1) % trackPoints.size();
  PVector pos = trackPoints.get(idx);
  PVector next = trackPoints.get(nextIdx);
  float frac = carDistance - idx;
  float x = lerp(pos.x, next.x, frac);
  float y = lerp(pos.y, next.y, frac);
  float angle = atan2(next.y - pos.y, next.x - pos.x);
  pushMatrix();
  translate(x, y);
  rotate(angle);
  float size = 20;
  fill(#FF0000);
  triangle(0, -size/2, 0, size/2, size, 0);
  popMatrix();
}

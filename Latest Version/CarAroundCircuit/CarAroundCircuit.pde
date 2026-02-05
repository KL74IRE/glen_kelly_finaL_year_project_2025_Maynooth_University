/*
Final Year Project 2025

FYP25CM009 Simulation of a track car

Glen Kelly

Supervisor: Charles Markham
*/

/*
Main Start-Up Method,
Controls which tracks are initialised,
Controls which information can be displayed
Allows entering of specialised editing mode for tracks
*/

int steps = 180;

boolean excel = false;
boolean showWaypoints = false;
boolean showPoints = false;
boolean showSpeeds = false;
boolean showTPs = false;
boolean telemetryS = false;

boolean edit = false;
boolean brands = false;
boolean bahrain = false;
boolean circle = false;

Button[] buttons;

interface BoolSupplier {
  boolean get();
}

void setup() {
  size(1920, 980);

  float bx = width - 200;
  float by = 30;
  float bw = 170;
  float bh = 36;
  float gap = 8;

  buttons = new Button[] {
    new Button(bx, by, bw, bh, "Excel", () -> excel = !excel, () -> excel),
    new Button(bx, by += bh + gap, bw, bh, "Waypoints", () -> showWaypoints = !showWaypoints, () -> showWaypoints),
    new Button(bx, by += bh + gap, bw, bh, "Points", () -> showPoints = !showPoints, () -> showPoints),
    new Button(bx, by += bh + gap, bw, bh, "Speeds", () -> showSpeeds = !showSpeeds, () -> showSpeeds),
    new Button(bx, by += bh + gap, bw, bh, "TPs", () -> showTPs = !showTPs, () -> showTPs),
    new Button(bx, by += bh + gap, bw, bh, "TelemetryS", () -> telemetryS = !telemetryS, () -> telemetryS),
    new Button(bx, by += bh + gap + 12, bw, bh, "Edit Mode", () -> { edit = true; brands = false; bahrain = false; circle = false; }, () -> edit),
    new Button(bx, by += bh + gap, bw, bh, "Brands", () -> { brands = true; edit = false; bahrain = false; circle = false; }, () -> brands),
    new Button(bx, by += bh + gap, bw, bh, "Bahrain", () -> { bahrain = true; edit = false; brands = false; circle = false; }, () -> bahrain),
    new Button(bx, by += bh + gap, bw, bh, "Circle", () -> { circle = true; edit = false; brands = false; bahrain = false; }, () -> circle),
    new Button(bx, by += bh + gap + 12, bw, bh, "Rebuild", () -> rebuildScene(), () -> true)
  };

  rebuildScene();
}

void draw() {
  drawUI();
}

void drawUI() {
  noStroke();
  fill(255, 230);
  rect(width - 220, 20, 210, 520, 12);

  for (Button b : buttons) b.draw();
}

void mousePressed() {
  for (Button b : buttons) {
    if (b.hit(mouseX, mouseY)) {
      b.onClick.run();
      rebuildScene();
      break;
    }
  }
}

void rebuildScene() {
  background(255);
  runScene();
}

void runScene() {
  if (edit) {
    editingMode();
  }
  if (brands) {
    brandsHatch(steps, excel, showWaypoints, showPoints, showSpeeds, telemetryS, showTPs);
  }
  if (circle) {
    basicCircle(steps, excel, showWaypoints, showPoints, showSpeeds, telemetryS, showTPs);
  }
  if (bahrain) {
    bahrain(steps, excel, showWaypoints, showPoints, showSpeeds, telemetryS, showTPs);
  }
}

class Button {
  float x, y, w, h;
  String label;
  Runnable onClick;
  BoolSupplier state;

  Button(float x, float y, float w, float h, String label, Runnable onClick, BoolSupplier state) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.label = label;
    this.onClick = onClick;
    this.state = state;
  }

  void draw() {
    boolean over = hit(mouseX, mouseY);
    boolean on = state.get();

    stroke(0);
    if (on) {
      fill(over ? color(0, 180, 0) : color(0, 220, 0));
    } else {
      fill(over ? color(180, 0, 0) : color(220, 0, 0));
    }
    rect(x, y, w, h, 6);

    fill(255);
    textAlign(CENTER, CENTER);
    textSize(14);
    text(label, x + w/2, y + h/2);
    textAlign(LEFT, BASELINE);
  }

  boolean hit(float mx, float my) {
    return mx >= x && mx <= x + w && my >= y && my <= y + h;
  }
}

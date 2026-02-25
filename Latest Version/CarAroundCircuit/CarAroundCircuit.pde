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

public int steps = 100;

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
boolean genetic = false;
boolean hasError = false;
String testMessage = "";   // will show "TESTS PASSED/FAILED"

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
  float smallW = (bw - gap) / 2;

  buttons = new Button[] {
    new Button(bx, by, bw, bh, "Excel",
      () -> excel = !excel,
      () -> excel,
      false
    ),
    new Button(bx, by += bh + gap, bw, bh, "Waypoints",
      () -> showWaypoints = !showWaypoints,
      () -> showWaypoints,
      false
    ),
    new Button(bx, by += bh + gap, bw, bh, "Points",
      () -> showPoints = !showPoints,
      () -> showPoints,
      false
    ),
    new Button(bx, by += bh + gap, bw, bh, "Speeds",
      () -> showSpeeds = !showSpeeds,
      () -> showSpeeds,
      false
    ),
    new Button(bx, by += bh + gap, bw, bh, "TPs",
      () -> showTPs = !showTPs,
      () -> showTPs,
      false
    ),
    new Button(bx, by += bh + gap, bw, bh, "TelemetryS",
      () -> telemetryS = !telemetryS,
      () -> telemetryS,
      false
    ),

    new Button(bx, by += bh + gap + 12, bw, bh, "Edit Mode",
      () -> { edit = true; brands = false; bahrain = false; circle = false; },
      () -> edit,
      false
    ),
    new Button(bx, by += bh + gap, bw, bh, "Brands",
      () -> { brands = true; edit = false; bahrain = false; circle = false; },
      () -> brands,
      false
    ),
    new Button(bx, by += bh + gap, bw, bh, "Bahrain",
      () -> { bahrain = true; edit = false; brands = false; circle = false; },
      () -> bahrain,
      false
    ),
    new Button(bx, by += bh + gap, bw, bh, "Circle",
      () -> { circle = true; edit = false; brands = false; bahrain = false; },
      () -> circle,
      false
    ),
    new Button(bx, by += bh + gap + 12, smallW, bh, "-100",
      () -> { steps = max(100, steps - 100); rebuildScene(); },
      () -> true,
      true
    ),
    new Button(bx + smallW + gap, by, smallW, bh, "+100",
      () -> { steps += 100; rebuildScene(); },
      () -> true,
      true
    ),

    new Button(bx, by += bh + gap, smallW, bh, "-1000",
      () -> { steps = max(100, steps - 1000); rebuildScene(); },
      () -> true,
      true
    ),
    new Button(bx + smallW + gap, by, smallW, bh, "+1000",
      () -> { steps += 1000; rebuildScene(); },
      () -> true,
      true
    ),

    new Button(bx, by += bh + gap + 12, bw, bh, "Rebuild",
      () -> rebuildScene(),
      () -> true,
      true
    ),
    
    new Button(bx, by += bh + gap, bw, bh, "Genetic",
      () -> genetic = !genetic,
      () -> genetic,
      false
    ),
    
    new Button(bx, by += bh + gap + 12, smallW, bh, "-100 R",
      () -> { generations = max(10, generations - 100); },
      () -> true,
      true
    ),
    new Button(bx + smallW + gap, by, smallW, bh, "+100 R",
      () -> { generations += 100; },
      () -> true,
      true
    ),
    
    new Button(bx, by += bh + gap, smallW, bh, "-10 Pop",
      () -> { population = max(10, population - 10); },
      () -> true,
      true
    ),
    new Button(bx + smallW + gap, by, smallW, bh, "+10 Pop",
      () -> { population += 10; },
      () -> true,
      true
    ),
    
    new Button(bx, by += bh + gap, smallW, bh, "-10 Elites",
      () -> { elites = max(1, elites - 10); },
      () -> true,
      true
    ),
    new Button(bx + smallW + gap, by, smallW, bh, "+10 Elites",
      () -> { elites += 10; },
      () -> true,
      true
    ),

  };

  rebuildScene();
}

void draw() {
  drawUI();
  displayTestMessage();
  if(genetic)
  {
    drawBestLine();
  }
}

void drawUI() {
  noStroke();
  fill(255, 230);
  rect(width - 220, 20, 210, 700, 12);

  for (Button b : buttons) b.draw();

  fill(0);
  textSize(16);
  textAlign(LEFT);
  text("Steps: " + steps, 20, 230);
  text("Genetic Population: " + population, 20, 260);
  text("Genetic generations: " + generations, 20, 290);
  text("Genetic Keep: " + elites, 20, 320);
  textAlign(LEFT);
}

void displayTestMessage() {
  textAlign(LEFT, TOP);
  textSize(24);

  // background pill
  noStroke();
  fill(255, 240);
  rect(12, 912, 260, 38, 8);

  if (hasError) fill(255, 0, 0);
  else          fill(0, 180, 0);

  text(testMessage, 20, 916);
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
  testMessage = "REBUILDING...";
  hasError = false;

  background(255);
  runScene();

  if (!edit && !brands && !bahrain && !circle) {
    testMessage = "SELECT A TRACK";
  }
}

void runScene() {
  if (edit) editingMode();
  if (brands) brandsHatch(steps, excel, showWaypoints, showPoints, showSpeeds, telemetryS, showTPs);
  if (circle) basicCircle(steps, excel, showWaypoints, showPoints, showSpeeds, telemetryS, showTPs);
  if (bahrain) bahrain(steps, excel, showWaypoints, showPoints, showSpeeds, telemetryS, showTPs);
}

class Button {
  float x, y, w, h;
  String label;
  Runnable onClick;
  BoolSupplier state;
  boolean isAction;

  Button(float x, float y, float w, float h,
         String label, Runnable onClick,
         BoolSupplier state, boolean isAction) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.label = label;
    this.onClick = onClick;
    this.state = state;
    this.isAction = isAction;
  }

  void draw() {
    boolean over = hit(mouseX, mouseY);

    stroke(0);

    if (isAction) {
      fill(over ? color(180) : color(210));
    } else {
      boolean on = state.get();
      if (on) fill(over ? color(0, 180, 0) : color(0, 220, 0));
      else    fill(over ? color(180, 0, 0) : color(220, 0, 0));
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

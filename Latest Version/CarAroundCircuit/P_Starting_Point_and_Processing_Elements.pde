/*
Final Year Project 2025

FYP25CM009 Simulation of a track car

Glen Kelly

Supervisor: Charles Markham
*/

public int steps = 100;
public int laps = 20;
boolean stats = false;
boolean stintB = false;
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
String testMessage = "";
boolean one = true;
boolean two = false;
boolean three = false;
boolean showShortest = false;
Button[] buttons;

interface BoolSupplier {
  boolean get();
}

void setup() {
  size(1920, 980);

  float bx = width - 200;
  float by = 15;
  float bw = 170;
  float bh = 25;
  float gap = 6;
  float smallW = (bw - gap) / 2;
  float smallW2 = (bw - gap) / 2;
  float smallW3 = (bw - gap * 2) / 3;

  buttons = new Button[] {
    new Button(bx, by += bh + gap, bw, bh, "Excel Export",
      () -> excel = !excel,
      () -> excel, false),
    new Button(bx, by += bh + gap, bw, bh, "Most Recent Telemetry.XLXS",
      () -> { 
        launch(sketchPath("Track_Telemetry_Analysis.xlsx")); 
      },
      () -> true, true),
    new Button(bx, by += bh + gap + 12, smallW3, bh, "Inside",
      () -> { one = true; two = false; three = false; showShortest = false; },
      () -> one, false),
    new Button(bx + smallW3 + gap, by, smallW3, bh, "Center",
      () -> { one = false; two = true; three = false; showShortest = false; },
      () -> two, false),
    new Button(bx + smallW3 * 2 + gap * 2, by, smallW3, bh, "Outside",
      () -> { one = false; two = false; three = true; showShortest = false; },
      () -> three, false),
    new Button(bx, by += bh + gap, bw, bh, "Shortest",
      () -> { one = false; two = false; three = false; showShortest = true; },
      () -> showShortest, false),
    new Button(bx, by += bh + gap, bw, bh, "Waypoints",
      () -> showWaypoints = !showWaypoints,
      () -> showWaypoints, false),
    new Button(bx, by += bh + gap, bw, bh, "Vmax Possible",
      () -> { showSpeeds = !showSpeeds; if (showSpeeds) telemetryS = false; },
      () -> showSpeeds, false),
    new Button(bx, by += bh + gap, bw, bh, "Telemetry Speed",
      () -> { telemetryS = !telemetryS; if (telemetryS) showSpeeds = false; },
      () -> telemetryS, false),
    new Button(bx, by += bh + gap + 12, bw, bh, "Edit Mode",
      () -> { edit = !edit; },
      () -> edit, false),
    new Button(bx, by += bh + gap, bw, bh, "Brands",
      () -> { brands = true; edit = false; bahrain = false; circle = false; },
      () -> brands, false),
    new Button(bx, by += bh + gap, bw, bh, "Bahrain",
      () -> { bahrain = true; edit = false; brands = false; circle = false; },
      () -> bahrain, false),
    new Button(bx, by += bh + gap, bw, bh, "Circle",
      () -> { circle = true; edit = false; brands = false; bahrain = false; },
      () -> circle, false),
    new Button(bx, by += bh + gap, bw, bh, "Off",
      () -> { circle = false; edit = false; brands = false; bahrain = false; },
      () -> !circle && !edit && !brands && !bahrain, false),
    new Button(bx, by += bh + gap + 12, smallW, bh, "Steps (-100)",
      () -> { steps = max(100, steps - 100); rebuildScene(); },
      () -> true, true),
    new Button(bx + smallW + gap, by, smallW, bh, "Steps (+100)",
      () -> { steps += 100; rebuildScene(); },
      () -> true, true),
    new Button(bx, by += bh + gap, smallW, bh, "Steps (-1000)",
      () -> { steps = max(100, steps - 1000); rebuildScene(); },
      () -> true, true),
    new Button(bx + smallW + gap, by, smallW, bh, "Steps (+1000)",
      () -> { steps += 1000; rebuildScene(); },
      () -> true, true),
    new Button(bx, by += bh + gap + 12, bw, bh, "Rebuild",
      () -> rebuildScene(),
      () -> true, true),
    new Button(bx, by += bh + gap, bw, bh, "Genetic",
      () -> genetic = !genetic,
      () -> genetic, false),
    new Button(bx, by += bh + gap + 12, smallW2, bh, "-100 Gen",
      () -> { generations = max(10, generations - 100); },
      () -> true, true),
    new Button(bx + smallW2 + gap, by, smallW2, bh, "+100 Gen",
      () -> { generations += 100; },
      () -> true, true),
    new Button(bx, by += bh + gap, smallW, bh, "-10 Pop",
      () -> { population = max(10, population - 10); },
      () -> true, true),
    new Button(bx + smallW + gap, by, smallW, bh, "+10 Pop",
      () -> { population += 10; },
      () -> true, true),
    new Button(bx, by += bh + gap, smallW, bh, "-10 Keep",
      () -> { elites = max(1, elites - 10); },
      () -> true, true),
    new Button(bx + smallW + gap, by, smallW, bh, "+10 Keep",
      () -> { elites += 10; },
      () -> true, true),
    new Button(bx, by += bh + gap+10, smallW, bh, "-1 width",
      () -> { offset = max(1, offset - 5); },
      () -> true, true),
    new Button(bx + smallW + gap, by, smallW, bh, "+1 width",
      () -> { offset += 5; },
      () -> true, true),
    new Button(bx, by += bh + gap, smallW, bh, "-5 width",
      () -> { offset = max(1, offset - 5); },
      () -> true, true),
    new Button(bx + smallW + gap, by, smallW, bh, "+5 width",
      () -> { offset += 5; },
      () -> true, true),
    new Button(bx, by += bh + gap, bw, bh, "Width Reset",
      () -> { offset = 10; },
      () -> true, true),
    new Button(bx, by += bh + gap+10, smallW, bh, "-1 lap",
      () -> { laps = max(1, laps - 1); },
      () -> true, true),
    new Button(bx + smallW + gap, by, smallW, bh, "+1 lap",
      () -> { laps += 1; },
      () -> true, true),
    new Button(bx, by += bh + gap, smallW, bh, "-5 lap",
      () -> { laps = max(1, laps - 5); },
      () -> true, true),
    new Button(bx + smallW + gap, by, smallW, bh, "+5 lap",
      () -> { laps += 5; },
      () -> true, true),
    new Button(bx, by += bh + gap, bw, bh, "Stint Calc",
      () -> stintB = !stintB,
      () -> stintB, false),
    new Button(bx, by += bh + gap, bw, bh, "Stats Output (Console Only!)",
      () -> stats = !stats,
      () -> stats, false),
  };
  rebuildScene();
}

void draw() {
  drawUI();
  displayTestMessage();
  if (genetic) {
    drawBestLine();
  }
}

void drawUI() {
  noStroke();
  fill(245, 245, 255, 240);

  for (Button b : buttons) b.draw();

  fill(30, 30, 60);
  textSize(18);
  textAlign(LEFT, TOP);
  text("Simulation Settings", 20, 30);

  fill(0);
  textSize(15);
  text("Path Sampling Steps:", 20, 60);
  textSize(16);
  fill(40, 90, 180);
  text(steps, 20, 80);

  fill(0);
  textSize(15);
  text("Track Width (m):", 20, 100);
  textSize(16);
  fill(40, 90, 180);
  text(String.format("%.2f", offset * 2 / gRatio), 20, 120);
  fill(0);
  textSize(15);
  text("Stint Laps:", 20, 140);
  textSize(16);
  fill(40, 90, 180);
  text(laps, 20, 160);
  
  fill(30, 30, 60);
  textSize(18);
  text("Genetic Algorithm", 20, 200);

  fill(0);
  textSize(15);
  text("Population Size:", 20, 230);
  textSize(16);
  fill(40, 90, 180);
  text(population, 20, 250);

  fill(0);
  textSize(15);
  text("Generations:", 20, 280);
  textSize(16);
  fill(40, 90, 180);
  text(generations, 20, 300);

  fill(0);
  textSize(15);
  text("Elites Kept:", 20, 330);
  textSize(16);
  fill(40, 90, 180);
  text(elites, 20, 350);

  fill(30, 30, 60);
  textSize(18);
  textAlign(LEFT, TOP);
  text("Situation Details:", 20, 380);

  String circuit = edit ? "Editing Mode" : brands ? "Brands Hatch Indy Circuit" : bahrain ? "Bahrain International GP Circuit" : circle ? "Circle Track" : "No Track Selected";
  fill(0);
  textSize(15);
  text("Current Track:", 20, 410);
  textSize(16);
  fill(40, 90, 180);
  text(circuit, 20, 430);

  fill(0);
  textSize(15);
  text("Car:", 20, 460);
  textSize(16);
  fill(40, 90, 180);
  text("BMW M4 GT4 EVO", 20, 480);

  textAlign(LEFT, BASELINE);
  textSize(14);
  fill(0);
}

void displayTestMessage() {
  textAlign(LEFT, TOP);
  textSize(24);
  noStroke();
  fill(255, 240);
  rect(12, 912, 260, 38, 8);
  if (hasError) fill(255, 0, 0);
  else fill(0, 180, 0);
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

  Button(float x, float y, float w, float h, String label, Runnable onClick, BoolSupplier state, boolean isAction) {
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
      else fill(over ? color(180, 0, 0) : color(220, 0, 0));
    }
    rect(x, y, w, h, 6);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(14);
    text(label, x + w / 2, y + h / 2);
    textAlign(LEFT, BASELINE);
  }

  boolean hit(float mx, float my) {
    return mx >= x && mx <= x + w && my >= y && my <= y + h;
  }
}

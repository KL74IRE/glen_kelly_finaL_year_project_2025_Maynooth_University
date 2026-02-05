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

void setup() {
  size(1920, 980);
  background(255);
  int steps = 180;
  boolean excel = true;
  boolean showWaypoints = false;
  boolean showPoints = false;
  boolean showSpeeds = false;
  boolean telemetryS = false;
  boolean edit = false;
  boolean brands = false;
  boolean bahrain = true;
  boolean circle = false;
  boolean showTPs = true;
  
  if(edit){editingMode();}
  if(brands){brandsHatch(steps,excel,showWaypoints,showPoints,showSpeeds,telemetryS, showTPs);}
  if(circle){basicCircle(steps,excel,showWaypoints,showPoints,showSpeeds,telemetryS, showTPs);}
  if(bahrain){bahrain(steps,excel,showWaypoints,showPoints,showSpeeds, telemetryS, showTPs);}
}

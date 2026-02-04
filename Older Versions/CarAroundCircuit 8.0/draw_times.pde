void drawLapTimes(double[][] times) {
  textSize(16);
  textAlign(LEFT, TOP);

  float x = 20;
  float y = 20;
  float lineH = 20;

  for (int j = 0; j < times.length; j++) {
    int minutes = (int) times[j][0];
    double seconds = times[j][1];

    // Set colour
    if (j == 3) {
      fill(0, 255, 0);
    } else if (j==2){
      fill(255, 165, 0);         
    } else if (j==1){
      fill(0, 0, 255);           
    } else if (j==0){
      fill(255, 0, 0);           
    } else{
      fill(0);
    }

    String label = (j < 3) ? "Lane " + j : "Optimal";
    String s = String.format("%s: %02d:%06.3f", label, minutes, seconds);

    text(s, x, y + j * lineH);
  }
}

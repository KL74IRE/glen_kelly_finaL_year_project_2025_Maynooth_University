// -----------------------------
// Cubic Spline Circle Example
// -----------------------------

int n = 100; // number of points along the circle
float[] t = new float[n]; // parameter t
float[] x = new float[n]; // x coordinates
float[] y = new float[n]; // y coordinates

// Cubic spline coefficients for x(t)
float[] ax = new float[n];
float[] bx = new float[n-1];
float[] cx = new float[n];
float[] dx = new float[n-1];

// Cubic spline coefficients for y(t)
float[] ay = new float[n];
float[] by = new float[n-1];
float[] cy = new float[n];
float[] dy = new float[n-1];

// Step sizes between consecutive points in parameter t
float[] h = new float[n-1];

void setup() {
  size(500, 500);
  background(255);
  stroke(0);  // default stroke
  noFill();

  // -----------------------------
  // Define circle points
  // -----------------------------
  float cx0 = width/2;   // Circle center x
  float cy0 = height/2;  // Circle center y
  float r = 150;         // Circle radius

  for (int i = 0; i < n; i++) {
    t[i] = i; // Parameter for spline

    // Circle parametric coordinates
    float angle = map(i, 0, n, 0, TWO_PI);
    x[i] = cx0 + r * cos(angle);
    y[i] = cy0 + r * sin(angle);

    // Copy points into spline 'a' coefficients
    ax[i] = x[i];
    ay[i] = y[i];

    // -----------------------------
    // Draw original points
    // -----------------------------
    fill(255, 0, 0);   // red color
    noStroke();
    ellipse(x[i], y[i], 6, 6); // bigger points
  }

  // -----------------------------
  // Compute cubic spline coefficients
  // -----------------------------
  computeSplineCoefficients(ax, bx, cx, dx); // x(t)
  computeSplineCoefficients(ay, by, cy, dy); // y(t)

  // Draw the spline curve
  drawSpline();
}

// ------------------------------------------------------
// Function: computeSplineCoefficients
// Computes cubic spline coefficients for a given array 'a'
// Coefficients:
//   a[i] - the original point value at t[i] (already known)
//   b[i] - first derivative term for segment i (slope)
//   c[i] - second derivative term at point i (controls curvature)
//   d[i] - third derivative term for segment i (how curvature changes)
// ------------------------------------------------------
void computeSplineCoefficients(float[] a, float[] b, float[] c, float[] d) {

  // Step 1: Compute distances between consecutive t values (step sizes)
  // h[i] = t[i+1] - t[i], used in derivative calculations
  for (int i = 0; i < n-1; i++) h[i] = t[i+1] - t[i];

  // Step 2: Compute alpha coefficients for the tridiagonal system
  // These are related to the slopes between points and help enforce smoothness
  float[] alpha = new float[n-1];
  for (int i = 1; i < n-1; i++) {
    // alpha[i] is proportional to the difference in slopes between segments
    // (a[i+1]-a[i])/h[i] is the slope of the segment to the right
    // (a[i]-a[i-1])/h[i-1] is the slope of the segment to the left
    alpha[i] = (3/h[i])*(a[i+1]-a[i]) - (3/h[i-1])*(a[i]-a[i-1]);
  }

  // Step 3: Solve the tridiagonal system to find c[i] coefficients
  // This is a standard cubic spline approach
  float[] l = new float[n];   // diagonal elements of system
  float[] mu = new float[n];  // upper-diagonal coefficients
  float[] z = new float[n];   // right-hand side

  // Natural spline boundary at the first point: second derivative = 0
  l[0] = 1; mu[0] = 0; z[0] = 0;

  for (int i = 1; i < n-1; i++) {
    l[i] = 2*(t[i+1]-t[i-1]) - h[i-1]*mu[i-1]; // diagonal term
    mu[i] = h[i]/l[i];                         // upper-diagonal term
    z[i] = (alpha[i]-h[i-1]*z[i-1])/l[i];      // right-hand side
  }

  // Natural spline boundary at the last point: second derivative = 0
  l[n-1] = 1; z[n-1] = 0; c[n-1] = 0;

  // Step 4: Back-substitution to compute c, b, d coefficients
  for (int j = n-2; j >= 0; j--) {
    // c[j] = second derivative at t[j]
    c[j] = z[j] - mu[j]*c[j+1];

    // b[j] = first derivative term (slope) for segment i
    // This ensures the spline passes smoothly through a[i] to a[i+1]
    b[j] = (a[j+1]-a[j])/h[j] - h[j]*(c[j+1]+2*c[j])/3;

    // d[j] = third derivative term for segment i
    // This controls how curvature changes along the segment
    d[j] = (c[j+1]-c[j])/(3*h[j]);
  }

  // Summary of coefficients:
  // a[i] -> known value at the start of segment
  // b[i] -> slope of segment
  // c[i] -> curvature at segment start
  // d[i] -> change in curvature along segment
}


// ------------------------------------------------------
// Function: drawSpline
// Draws the cubic spline curve using the computed coefficients
// ------------------------------------------------------
void drawSpline() {
  stroke(0, 0, 255); // blue spline
  noFill();

  for (int i = 0; i < n-1; i++) {
    // Step through small t increments to draw smooth curve
    for (float tt = 0; tt < h[i]; tt += 0.5) {
      float xt = ax[i] + bx[i]*tt + cx[i]*tt*tt + dx[i]*tt*tt*tt;
      float yt = ay[i] + by[i]*tt + cy[i]*tt*tt + dy[i]*tt*tt*tt;
      point(xt, yt);
    }
  }
}

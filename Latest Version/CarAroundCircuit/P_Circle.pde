void basicCircle(int steps, boolean excel, boolean showWaypoints, boolean showPoints, boolean showSpeeds, boolean telemetryS, boolean showTPs) {
    int mTrackLength = 100;
    double[] x = getXCircle();
    double[] y = getYCircle();
    int start = 5;
    int end = 5;
    main(x, y, start, end, steps, mTrackLength, showWaypoints, showPoints, showSpeeds, excel, telemetryS, showTPs);
}

double[] getXCircle() {
    double[] x = {500, 800, 1100, 800, 500, 800, 1100, 800, 500, 800, 1100, 800, 500};
    return x;
}

double[] getYCircle() {
    double[] y = {400, 100, 400, 700, 400, 100, 400, 700, 400, 100, 400, 700, 400};
    return y;
}

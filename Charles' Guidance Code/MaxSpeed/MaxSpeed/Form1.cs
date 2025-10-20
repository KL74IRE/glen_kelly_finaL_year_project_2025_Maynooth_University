using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace MaxSpeed
{
    public partial class Form1 : Form
    {
        // Accelerate vehicle
        double a_max = 3.5; // Accelerating
        double b_max = 3.5; // Braking
        double u = 0.6;
        float v_top_speed = 300;


        static int N = 60;
        static float[] x = new float[N];
        static float[] y = new float[N];
        static float[] r = new float[N];
        static float[] v = new float[N];
        static float[] vmax = new float[N];

        public Form1()
        {
            InitializeComponent();

            // Define path of car (two sigmoid functions added together)
            for (int i = 0; i < N; i++)
            {
                x[i] = (float)i;
                y[i] = (10.0f / (1.0f + (float)Math.Exp(((double)N / 4.0) - (float)i))) - (10.0f / (1.0f + (float)Math.Exp((3.0 * (double)N / 4.0) - (float)i)));
            }

            // Caclulate radius for each point (-ve => colinear pts)
            r[0] = -1.0f;
            for (int i = 1; i < (N - 1); i++)
            {
                r[i] = radius(x[i - 1], y[i - 1], x[i], y[i], x[i + 1], y[i + 1]);
            }
            r[N - 1] = -1.0f;

            // Caclulate vmax for each point
            for (int i = 0; i < N; i++)
            {
                if (r[i] > 0.0f)
                {
                    vmax[i] = (float)Math.Sqrt(u * 9.81 * r[i]);
                    if (vmax[i] > v_top_speed) vmax[i] = v_top_speed;
                }
                else
                {
                    vmax[i] = v_top_speed;
                }
            }


            double s;

            // Set initial velocity
            v[0] = 0.0f;
            for (int i = 1; i < N; i++)
            {
                // Distance between two pts
                s = Math.Sqrt(Math.Pow(x[i] - x[i - 1], 2) + Math.Pow(y[i] - y[i - 1], 2));

                // Accelerate car at maximum possible rate between two points
                v[i] = (float)Math.Sqrt(Math.Pow((double)v[i - 1], 2.0) + (2.0 * a_max * s));

                // if car has exceed maximum speed possible
                if (v[i] > vmax[i])
                {
                    // Go back reducing velocity by maximum acceleration until it is same (or just below) that calculated in forward direction
                    v[i] = vmax[i];  // So point were spped was exceeded is set to vmax

                    for (int j = i - 1; j >= 0; j--)  // Work back through previous points j = i-1, i-2 etc (note j=i already done v=vmax)
                    {
                        s = Math.Sqrt(Math.Pow(x[j] - x[j + 1], 2) + Math.Pow(y[j] - y[j + 1], 2));         // Distance between (i and i-1 point)

                        float vn = (float)Math.Sqrt(Math.Pow((double)v[j + 1], 2.0) - (2.0 * b_max * s));     // vn    U=(V^2) - 2as,

                        // starting with reduced velocity in reverse direction accelerate back to begining keeeping new value if less than old
                        // j=-1 used to break on first instance speed change below exisiting velocity (only an optimisation may be better to leave out)
                        if (v[j] > vn) v[j] = vn; else j = -1;
                    }
                }

            }
        }

        // http://mathematica.stackexchange.com/questions/36995/code-to-give-center-of-circle-given-three-poin…
        public float radius(float ax, float ay, float bx, float by, float cx, float cy)
        {
            float a = bx - ax;
            float b = by - ay;
            float c = cx - ax;
            float d = cy - ay;
            float e = (a * (ax + bx)) + (b * (ay + by));
            float f = (c * (ax + cx)) + (d * (ay + cy));
            float g = g = 2 * ((a * (cy - by)) - (b * (cx - bx)));
            float centerx, centery, r = -1;

            if (g != 0.0)
            {
                centerx = ((d * e) - (b * f)) / g;
                centery = ((a * f) - (c * e)) / g;
                r = (float)Math.Sqrt((double)(Math.Pow((ax - centerx), 2) + Math.Pow((ay - centery), 2)));
            }
            return r;
        }

        private void panel1_Paint(object sender, PaintEventArgs e)
        {
            // Configure Font, Brush and Pen
            Font font;
            StringFormat strFormat = new StringFormat();
            font = new System.Drawing.Font("Consolas", 10, FontStyle.Bold);
            strFormat.Alignment = StringAlignment.Near;
            strFormat.LineAlignment = StringAlignment.Near;

            Brush cm = new SolidBrush(Color.Black);

            Pen pm = new Pen(Color.Green, 2);
            Graphics G = e.Graphics;

            pm = new Pen(Color.Blue, 2);

            for (int i = 0; i < x.Length; i++)
            {
                int px = 35 + (int)(((float)(panel1.Width - 60) * x[i]) / (float)N);
                int py = panel1.Height - 35 - (int)(((float)(panel1.Height - 60) * y[i]) / 10.0f);


                if (i % 2 == 0)
                {
                    cm = new SolidBrush(Color.Black);
                    G.DrawString(String.Format("{0,5:0.0}", vmax[i]), font, cm, new PointF(px - 10, py + 20));
                    G.DrawString(String.Format("{0,5:0.0}", v[i]), font, cm, new PointF(px - 10, py + 10));
                    G.FillEllipse(cm, new Rectangle(px, py, 10, 10));
                }
                else
                {
                    cm = new SolidBrush(Color.Red);
                    G.DrawString(String.Format("{0,5:0.0}", vmax[i]), font, cm, new PointF(px - 10, py - 25));
                    G.DrawString(String.Format("{0,5:0.0}", v[i]), font, cm, new PointF(px - 10, py - 15));
                    G.FillEllipse(cm, new Rectangle(px, py, 10, 10));
                }
            }

            G.Dispose();
            base.OnPaint(e);
        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }
    }
}
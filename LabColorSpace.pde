/* CSci-5609 Support Code created by Prof. Dan Keefe, Fall 2023

Routines for working with the Lab Color Space in Processing
*/

import java.lang.Math;

// Like Processing's built-in lerpColor() function, this function calculates a color
// between two colors at a specified increment.  The amt parameter is the amount to
// interpolate between the two values where 0.0 is equal to the first color, 0.1 is
// very near the first color, 0.5 is halfway between the two colors, etc.
// The key difference in this function is that the color interpolation is done in
// the perceptually uniform Lab color space rather than RGB space.
color lerpColorLab(color c1, color c2, float amt) {
  // convert input colors to Lab space
  float[] lab1 = colorToLab(c1);
  float[] lab2 = colorToLab(c2);
  
  // linearly interpolate the three L, a, b parmeters to find the in-between color
  // in Lab space
  float[] labNew = new float[3];
  labNew[0] = lerp(lab1[0], lab2[0], amt);
  labNew[1] = lerp(lab1[1], lab2[1], amt);
  labNew[2] = lerp(lab1[2], lab2[2], amt);
  
  // convert this Lab color back into a regular rgb color for drawing on the screen
  color c = labToColor(labNew);
  return c;
}

color MagnitudeColor(int magnitude){
  color[] color_list = new color[13];
  color_list[12] = #fd2fc2;
  color_list[0] = #444444;
  color_list[1] = #9bc4e4;
  color_list[2] = #00a0f1;
  color_list[3] = #0062f5;
  color_list[4] = #2de161;
  color_list[5] = #1cac5d;  
  color_list[6] = #ffbd2b;
  color_list[7] = #ff992b;
  color_list[8] = #fa5151;
  color_list[9] = #fa5151;
  color_list[10] = #ff000d;
  color_list[11] = #c20007;

  return color_list[magnitude];
}

// converts a color stored in processing's built-in color type to its Lab representation
public float[] colorToLab(color c) {
  pushStyle();
  colorMode(RGB, 1, 1, 1);
  float[] rgb01 = { red(c), green(c), blue(c) };
  float[] lab = rgb01ToLab(rgb01); 
  popStyle();
  return lab;
}

// converts a color defined in Lab space to rgb space and returns the result as a Processing color
public color labToColor(float[] lab) {
  float[] rgb01 = labToRgb01(lab);    
  pushStyle();
  colorMode(RGB, 1, 1, 1);
  color c = color(rgb01[0], rgb01[1], rgb01[2]);
  popStyle();
  return c;
}



// ----- BEGIN EXTERNAL CODE FOR RGB-LAB CONVERSION (including some minor edits) -----
// https://github.com/antimatter15/rgb-lab

/*
MIT License
Copyright (c) 2014 Kevin Kwok <antimatter15@gmail.com>
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

// the following functions are based off of the pseudocode
// found on www.easyrgb.com
  
float[] labToRgb01(float[] lab) {
  double y = (lab[0] + 16.0f) / 116.0f;
  double x = lab[1] / 500.0f + y;
  double z = y - lab[2] / 200.0f;
  double r, g, b;
  
  x = 0.95047f * ((x * x * x > 0.008856f) ? x * x * x : (x - 16.0f / 116.0f) / 7.787f);
  y = 1.00000f * ((y * y * y > 0.008856f) ? y * y * y : (y - 16.0f / 116.0f) / 7.787f);
  z = 1.08883f * ((z * z * z > 0.008856f) ? z * z * z : (z - 16.0f / 116.0f) / 7.787f);
  
  r = x * 3.2406f + y * -1.5372f + z * -0.4986f;
  g = x * -0.96890f + y * 1.8758f + z * 0.0415f;
  b = x * 0.05570f + y * -0.2040f + z * 1.0570f;
  
  r = (r > 0.0031308f) ? (1.055f * Math.pow(r, 1.0f / 2.4f) - 0.055f) : 12.92f * r;
  g = (g > 0.0031308f) ? (1.055f * Math.pow(g, 1.0f / 2.4f) - 0.055f) : 12.92f * g;
  b = (b > 0.0031308f) ? (1.055f * Math.pow(b, 1.0f / 2.4f) - 0.055f) : 12.92f * b;
  
  float[] rgb = new float[3];
  rgb[0] = constrain((float)r, 0, 1);
  rgb[1] = constrain((float)g, 0, 1);
  rgb[2] = constrain((float)b, 0, 1);
  return rgb;
}


float[] rgb01ToLab(float[] rgb) {
  double r = rgb[0];
  double g = rgb[1];
  double b = rgb[2];
  double x, y, z;

  r = (r > 0.04045f) ? Math.pow((r + 0.055f) / 1.055f, 2.4f) : r / 12.92f;
  g = (g > 0.04045f) ? Math.pow((g + 0.055f) / 1.055f, 2.4f) : g / 12.92f;
  b = (b > 0.04045f) ? Math.pow((b + 0.055f) / 1.055f, 2.4f) : b / 12.92f;

  x = (r * 0.4124f + g * 0.3576f + b * 0.1805f) / 0.95047f;
  y = (r * 0.2126f + g * 0.7152f + b * 0.0722f) / 1.00000f;
  z = (r * 0.0193f + g * 0.1192f + b * 0.9505f) / 1.08883f;

  x = (x > 0.008856f) ? Math.pow(x, 1.0f / 3.0f) : (7.787f * x) + 16.0f / 116.0f;
  y = (y > 0.008856f) ? Math.pow(y, 1.0f / 3.0f) : (7.787f * y) + 16.0f / 116.0f;
  z = (z > 0.008856f) ? Math.pow(z, 1.0f / 3.0f) : (7.787f * z) + 16.0f / 116.0f;

  float[] lab = new float[3];
  lab[0] = (float)(116.0f * y) - 16.0f;
  lab[1] = (float)(500.0f * (x - y));
  lab[2] = (float)(200.0f * (y - z));

  return lab;
}


 

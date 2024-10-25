/* CSci-5609 Support Code created by Prof. Dan Keefe, Fall 2023

Some useful utility functions for working with spatial data
*/

static class MathUtils {

  // Returns the Euclidian distance between two points (x1,y1) and (x2,y2) 
  static public float getDistanceFromTo(float x1, float y1, float x2, float y2) {
    float dx = x2 - x1;
    float dy = y2 - y1;
    return sqrt(dx*dx + dy*dy);
  }
  
  // If the angle is outside the range -180 to +180, the function returns an equivalent angle within
  // the range -180 to +180.
  static public float angleToPlusMinus180(float a) {
    while (a <= -180) {
      a += 360; 
    }
    while (a > 180) {
      a -= 360; 
    }
    return a;
  }
   
}

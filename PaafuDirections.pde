/* CSci-5609 Support Code created by Prof. Dan Keefe, Fall 2023

An object that models a Paafu circle.  The angles and names for each direction
are read from a data table.  The class provides methods to access and work
with these data.
*/
 //<>//
public class PaafuDirections {

  // Initializes the class by loading data from the Paafu-Directions.csv file
  public PaafuDirections() {
    directionTable = loadTable("earthquake_data.csv", "header");
    println("Paafu table:", directionTable.getRowCount(), "x", directionTable.getColumnCount()); 
  } 
  
  // Returns the angle in degrees relative to Wenewenenfuhemakit (i.e., North) for the provided 
  // Paafu direction.  the angle ranges from -180 to +180 and increases positively when rotating
  // to the East of North and decreases negatively when rotating to the West of North.
  public float getAngle(String directionName) {
    TableRow r = directionTable.findRow(directionName, "Direction");
    return r.getFloat("Angle");
  }
  
  // Returns the closest Paafu direction to the angle, which is specified in degrees east of north.
  public String getDirection(float angle) {
    int closestID = 0;
    float closestDiff = abs(directionTable.getRow(0).getFloat("Angle") - angle);
    for (int r=1; r<directionTable.getRowCount(); r++) {
      float diff = abs(angle - directionTable.getRow(r).getFloat("Angle"));
      if (diff < closestDiff) {
        closestID = r;
        closestDiff = diff;
      }
    }
    return directionTable.getRow(closestID).getString("Direction");
  }
  
  // Returns the angle (i.e., heading) to take to move from the point(fromLatitude, fromLongitude) to
  // a new location (toLatitude, toLongitude).  Assumes zero degrees points North and angles increase
  // when rotating to the East from North and decrease when rotating to the West of North.
  public float getAngleFromTo(float fromLatitude, float fromLongitude, float toLatitude, float toLongitude) {
    float dx = toLongitude - fromLongitude;
    float dy = toLatitude - fromLatitude;
    float a = atan2(dy,dx);
    a = -a + PI/2.0; // invert and shift so a=0 points north and angles increase rotating east
    a = degrees(a);  // convert to degrees
    a = MathUtils.angleToPlusMinus180(a);    
    return a;
  }
  
  // Returns the name of the closest Paafu direction to take to move from one location to another
  public String getDirectionFromTo(float fromLatitude, float fromLongitude, 
                                   float toLatitude, float toLongitude) 
  {
    float a = getAngleFromTo(fromLatitude, fromLongitude, toLatitude, toLongitude);
    return getDirection(a);
  }
  
  
  public float getDirectionCount() {
    return directionTable.getRowCount(); 
  }

  public String getDirection(int id) {
    return directionTable.getRow(id).getString("Direction"); 
  }
  
  public float getAngle(int id) {
    return directionTable.getRow(id).getFloat("Angle");
  } 
   
  Table directionTable;
}

/* CSci-5609 Support Code created by Prof. Dan Keefe, Fall 2023

Routines for identifying and accessing Paafu kinship relationships between islands
*/

import java.util.Collections;

// This class combines Paafu direction data with the locations of islands to indentify kinship 
// relationships between the islands.  In Paafu, islands that lie in the same direction are 
// considered to be tied together through a bond of kinship.
class KinshipTies {

  // The constructor analyses the direction and location data to find kinship ties, which can later
  // be accessed through the getKinshipTies*() functions.
  public KinshipTies(PaafuDirections paafuDirections, Table locationTable) {
    buildKinshipDataStructure(paafuDirections, locationTable);
  }

  
  // Returns an ordered list (i.e., sorted by distance from the startingMunicipality) of the 
  // municipalities that you will find when starting at the startingMunicipality and traveling
  // (approximately) in the direction of paafuDirection.  An empty ArrayList is returned if
  // there are no kinship ties for the specified direction.
  public ArrayList<String> getKinshipTiesForDirection(String startingMunicipality, String paafuDirection) {
    return kinshipData.get(startingMunicipality).get(paafuDirection);
  }
  
  
  // Returns all of the kinship ties for a given municipality organized by Paafu direction.  This is
  // the same information as provided in the previous function, which accesses the data for just a single
  // direction.  This function returns a HashMap that provides access to the data for ALL directions.
  // Example to loop through the HashMap, to access all kinship ties for the island of Weno (Moen):
  //    String municipality1 = "Weno (Moen)";
  //    HashMap<String, ArrayList<String>> kinshipTiesByDirection = kinshipTies.getKinshipTies(municipality1);
  //    for (String paafuDirection : kinshipTiesByDirection.keySet()) {
  //      ArrayList<String> municipalityList = kinshipTiesByDirection.get(paafuDirection);
  //      if (municipalityList.size() > 0) {
  //        println("From " + municipality1 + " in direction " + paafuDirection + ":");
  //        for (String municipality2 : municipalityList) {
  //          println("  " + municipality2);
  //        }
  //      }
  //    }
  public HashMap<String, ArrayList<String>> getKinshipTies(String municipality) {
    return kinshipData.get(municipality); 
  }


    
  // Returns the maximum number of kinship ties found in the data.  In other words, the max number of
  // islands found in a single direction, across the whole dataset.
  public int getMaxKinshipTies() {
    return maxKinshipTies; 
  }
    
    
  // internal method to build the kinship data structure
  void buildKinshipDataStructure(PaafuDirections paafuDirections, Table locationTable) {
    kinshipData = new HashMap<String, HashMap<String, ArrayList<String>>>();
    maxKinshipTies = 0;

    for (int m1=0; m1<locationTable.getRowCount(); m1++) {
      HashMap<String, ArrayList<String>> kinshipForM1 = new HashMap<String, ArrayList<String>>();
      TableRow m1Row = locationTable.getRow(m1);
      String m1Name = m1Row.getString("Municipality");
      float m1Lat = m1Row.getFloat("Latitude");
      float m1Long = m1Row.getFloat("Longitude");
      
      for (int d=0; d<paafuDirections.getDirectionCount(); d++) {
        String direction = paafuDirections.getDirection(d);
        ArrayList<MunicipalityWithDistance> municipalitiesInDirection = new ArrayList<MunicipalityWithDistance>();
        for (int m2=0; m2<locationTable.getRowCount(); m2++) {        
          if (m2 != m1) {
            TableRow m2Row = locationTable.getRow(m2);
            float m2Lat = m2Row.getFloat("Latitude");
            float m2Long = m2Row.getFloat("Longitude");
            float angle = paafuDirections.getAngleFromTo(m1Lat, m1Long, m2Lat, m2Long);
            String m1ToM2Direction = paafuDirections.getDirection(angle);
            if (m1ToM2Direction == direction) {
              MunicipalityWithDistance mwd = new MunicipalityWithDistance();
              mwd.municipality = m2Row.getString("Municipality");;
              mwd.distance = MathUtils.getDistanceFromTo(m1Lat, m1Long, m2Lat, m2Long);
              municipalitiesInDirection.add(mwd);
            }
          }
        } // end of gathering islands that lie along this paafu direction 
        
        // sort the municipalities in this direction by distance
        Collections.sort(municipalitiesInDirection);
        // save the result in simple list of strings
        ArrayList<String> sortedMunicipalities = new ArrayList<String>();
        for (MunicipalityWithDistance m : municipalitiesInDirection) {
          sortedMunicipalities.add(m.municipality);
        }
        if (sortedMunicipalities.size() > maxKinshipTies) {
          maxKinshipTies = sortedMunicipalities.size(); 
        }
        
        kinshipForM1.put(direction, sortedMunicipalities);
      } // end for each paafu direction around m1
      
      kinshipData.put(m1Name, kinshipForM1);
    } // end for each island in the location table
  }
  
  
  // temporary class to help with sorting municipalities by distance while building the datastructure
  class MunicipalityWithDistance implements Comparable<MunicipalityWithDistance>{
    String municipality;
    Float distance;
    
    public int compareTo(MunicipalityWithDistance o) {
        return this.distance.compareTo(o.distance);
    }
  }
  
  // The data are stored internally as a double hashmap of arraylists so that lookups can be done
  // based on the name of the starting municipality and the direction to travel from that starting
  // location, like this:
  // ArrayList<String> municipalatiesInDirection = kinshipData.get(startingMunicipalityName).get(paafuDirectionName);
  // The list that is returned is sorted.
  HashMap<String, HashMap<String, ArrayList<String>>> kinshipData;
  int maxKinshipTies;
}

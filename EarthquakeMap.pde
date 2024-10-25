/* CSci-5609 Assignment 1: Visualization of the Islands of Micronesia
*/

// === GLOBAL VARIABLES ===

// Raw data tables
Table locationTable;


// Derived data: mins and maxes for each data variable
float minLatitude, maxLatitude;
float minLongitude, maxLongitude;
float minMagnitude, maxMagnitude;
float minDepth, maxDepth;
PFont labelFont;
PImage world_map_image,d200,d400,d600,d800,das,daf,dna,deu,doc,dsa,all;
// Graphics objects
PanZoomMap panZoomMap;
String highlightedCont = "";
String highlightedSize = "";
String selectedSize ="";
String selectedCont = "";
String highlightedEvent = "";
String selectedEvent = "";
String highlightedSecondEvent = "";
String selectedSecond = "";
float lower = 0.0;
float upper = 0.0;

void setup() {
  // size of the graphics window
  loadRawDataTables();

  world_map_image = loadImage("world_map_pic.jpg");
  world_map_image.resize(1080,540);
  size(1600, 900, P2D);
  panZoomMap = new PanZoomMap(0, 0, 1080, 540);
  
  labelFont = loadFont("Arial-Black-12.vlw");
}


void draw() {
  highlightedCont = getContMouse();
  highlightedSize = getSizeMouse();
  highlightedEvent = getEventMouse();
  highlightedSecondEvent = getEventMouse();
  // clear the screen
  background(0);
  noStroke();
  textureMode(NORMAL);
  float x1 = panZoomMap.longitudeToScreenX(0);
  float y1 = panZoomMap.latitudeToScreenY(0);
  float x2 = panZoomMap.longitudeToScreenX(1080);
  float y2 = panZoomMap.latitudeToScreenY(540);
  beginShape();
  texture(world_map_image);
  vertex(x1, y1, 1, 1);
  vertex(x2, y1, 0, 1);
  vertex(x2, y2, 0, 0);
  vertex(x1, y2, 1, 0);
  endShape(CLOSE);
  
// drawing the legend to better understanding
  fill(250);
  stroke(111, 87, 0);
  rect(1300, -10, 1610, 910);
  
  int nSwatches = 5;
  color from = MagnitudeColor((int)minMagnitude);
  color to = MagnitudeColor((int)maxMagnitude);
  fill(0,0,0);
  text("Magnitude: ", 1310 ,140);
  
  for (int i=0; i<=nSwatches; i++) {
    float amt = (float)i / (float)nSwatches;
    color interpCol = lerpColor(from, to, amt);
    fill(interpCol);
    rect(1340 + 40*i, 160, 40, 40);
    
    fill(0);
    float temp = (9.1-6.5)/5*i+6.5;
    text(temp,1340 + 40*i, 210);
  }
  
  fill(0,0,0);
  text("Depth: ", 1310 ,30);
  
  for (int j = 0; j<=nSwatches; j++){
    fill(255,255,255);
    float radius = 18/5*j+2;
    circle(1320+50*j, 60, radius);
    fill(0,0,0);
    float temp2 = (670.81-2.7)/5*j+2.7;
    text(int(temp2),1320+50*j, 100);
  }
  
  
  // write down the filter opinion
  fill(255,255,255);
  rect(30, 500,150,290);
  fill(0,0,0);
  text("Filter :",35,510);
  for (int x = 530; x <= 770; x=x+40){
    rect(50,x,10,10);
  }
  text("Asia",70,540);
  text("Africa",70,580);
  text("North America",70, 620);
  text("Europe", 70, 660);
  text("South America", 70, 700);
  text("Oceania", 70, 740);
  text("All", 70 ,780);
  for (int x = 530; x <= 690; x=x+40){
    rect(120,x,10,10);
  }
  text("Depth :",100, 510);
  text("0-200",135,540);
  text("200-400",135,580);
  text("400-600", 135, 620);
  text("600-800", 135, 660);
  
  
  //text(selectedEvent,mouseX,mouseY);

  for (int i=1; i<locationTable.getRowCount();i++){
      float cur_x = panZoomMap.longitudeToScreenX(locationTable.getFloat(i, 2));
      float cur_y = panZoomMap.latitudeToScreenY(locationTable.getFloat(i, 1));
      TableRow rowData = locationTable.getRow(i);
      float latitude = (rowData.getFloat("Latitude")-minLatitude)/(maxLatitude - minLatitude)*540;
      float longitude = (rowData.getFloat("Longitude")-minLongitude)/(maxLongitude - minLongitude)*1080;
      float screenX = panZoomMap.longitudeToScreenX(longitude);
      float screenY = panZoomMap.latitudeToScreenY(latitude);
      float magnitude = (rowData.getFloat("magnitude")-minMagnitude)/(maxMagnitude - minMagnitude); 
      float depth = (rowData.getFloat("depth")-minDepth)/(maxDepth - minDepth); 
      String country = rowData.getString("country");
      // For the radius of each circle here, I made a double check for the area data in the population table with
      // the data in the wikipedia and local geographic data, I could confirm that the area data's unit is hectare(1 acre almost euqal 0.405 hectare, 0.01 km^2).
      // Also, since most of the island in the dataset are reef island, the real island area data changed a lot after the 
      // data in our dataset be reported.
      // In order to avoid the island's name be overlap after zoom in, I put the name text a little far from the island's circle.
      // Furthermore, since the island's circle is pretty small due to their real size, I made the island's name remain in the same 
      // letter size after the user zoom in.
      //fill(255);
      //ellipseMode(RADIUS);
      //circle(cur_x, cur_y, 5);
      String clean_check = "All";
      if (clean_check.equals(selectedCont)){
        highlightedCont = "";
        highlightedSize = "";
        selectedSize ="";
        selectedCont = "";
        highlightedEvent = "";
        selectedEvent = "";
        highlightedSecondEvent = "";
        selectedSecond = "";
      }
      if (selectedCont!= ""){
        String Cont = rowData.getString("continent");
        if (Cont.equals(selectedCont)){
        float radius = lerp(2, 20, depth);
        color c = MagnitudeColor((int)rowData.getFloat("magnitude"));
        fill(c,150);
        noStroke();
        ellipseMode(RADIUS);
        circle(screenX, screenY, radius);
      //fill(155);
      //text(country,screenX,screenY);
        }
      }
      else if (selectedSize !=""){
        if (rowData.getFloat("depth") <= upper && rowData.getFloat("depth") >= lower){
          float radius = lerp(2, 20, depth);
          color c = MagnitudeColor((int)rowData.getFloat("magnitude"));
          fill(c,150);
          noStroke();
          ellipseMode(RADIUS);
          circle(screenX, screenY, radius);
        }
      }
      if (selectedEvent != ""&&selectedSecond == ""){
        //Jonah Should start drawing diagram here!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        fill(0);
        text(selectedEvent,1320,260);
        text("Magnitude: "+getMagnitude(selectedEvent),1320,270);
        text("Latitude: "+getLatitude(selectedEvent),1320,280);
        text("Longitude: "+getLongitude(selectedEvent),1320,290);
        //if(selectedSecond != ""){
        //  text(selectedSecond,1320,360);
        //  text("Magnitude: "+getMagnitude(selectedSecond),1320,370);
        //  text("Latitude: "+getLatitude(selectedSecond),1320,380);
        //  text("Longitude: "+getLongitude(selectedSecond),1320,390);
        //}
      }
      else if (selectedEvent != ""&&selectedSecond != ""){
        //Jonah Should start Comparison here !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        fill(0);
        text(selectedEvent,1320,260);
        text("Magnitude: "+getMagnitude(selectedEvent),1320,270);
        text("Latitude: "+getLatitude(selectedEvent),1320,280);
        text("Longitude: "+getLongitude(selectedEvent),1320,290);
        
        text(selectedSecond,1320,360);
        text("Magnitude: "+getMagnitude(selectedSecond),1320,370);
        text("Latitude: "+getLatitude(selectedSecond),1320,380);
        text("Longitude: "+getLongitude(selectedSecond),1320,390);
      }
      else{
        float radius = lerp(2, 20, depth);
        color c = MagnitudeColor((int)rowData.getFloat("magnitude"));
        fill(c,150);
        noStroke();
        ellipseMode(RADIUS);
        circle(screenX, screenY, radius);
      //fill(155);
      //text(country,screenX,screenY);
      }
  }
      if (selectedSize == "0-200"){
    d200 = loadImage("200.jpg");
    d200.resize(250,250);
    image(d200, 1320, 300);
    all = loadImage("all.jpg");
    all.resize(250,250);
    image(all, 1320, 500);
  }
  if (selectedSize == "200-400"){
    d400 = loadImage("400.jpg");
    d400.resize(250,250);
    image(d400, 1320, 300);
    all = loadImage("all.jpg");
    all.resize(250,250);
    image(all, 1320, 500);
  }
  if (selectedSize == "400-600"){
    d600 = loadImage("600.jpg");
    d600.resize(250,250);
    image(d600, 1320, 300);
    all = loadImage("all.jpg");
    all.resize(250,250);
    image(all, 1320, 500);
  }
  if (selectedSize == "600-800"){
    d800 = loadImage("800.jpg");
    d800.resize(250,250);
    image(d800, 1320, 300);
    all = loadImage("all.jpg");
    all.resize(250,250);
    image(all, 1320, 500);
  }
  if (selectedCont == "Asia"){
    das = loadImage("asia.jpg");
    das.resize(250,250);
    image(das, 1320, 300);
    all = loadImage("all.jpg");
    all.resize(250,250);
    image(all, 1320, 500);
  }
  if (selectedCont == "Africa"){
    daf = loadImage("africa.jpg");
    daf.resize(250,250);
    image(daf, 1320, 300);
    all = loadImage("all.jpg");
    all.resize(250,250);
    image(all, 1320, 500);
  }
  if (selectedCont == "North America"){
    dna = loadImage("north america.jpg");
    dna.resize(250,250);
    image(dna, 1320, 300);
    all = loadImage("all.jpg");
    all.resize(250,250);
    image(all, 1320, 500);
  }
  if (selectedCont == "Europe"){
    deu = loadImage("europe.jpg");
    deu.resize(250,250);
    image(deu, 1320, 300);
    all = loadImage("all.jpg");
    all.resize(250,250);
    image(all, 1320, 500);
  }
  if (selectedCont == "South America"){
    dsa = loadImage("south america.jpg");
    dsa.resize(250,250);
    image(dsa, 1320, 300);
    all = loadImage("all.jpg");
    all.resize(250,250);
    image(all, 1320, 500);
  }
   if (selectedCont == "Oceania"){
    doc = loadImage("oc.jpg");
    doc.resize(250,250);
    image(doc, 1320, 300);
    all = loadImage("all.jpg");
    all.resize(250,250);
    image(all, 1320, 500);
  }
  
  
}

float getLatitude(String Event) {
  TableRow r = locationTable.findRow(Event, "Position");
  return r.getFloat("Latitude");
}
float getLongitude(String Event) {
  TableRow r = locationTable.findRow(Event, "Position");
  return r.getFloat("Longitude");
}
float getMagnitude(String Event) {
  TableRow r = locationTable.findRow(Event, "Position");
  return r.getFloat("magnitude");
}

float getDepth(String municipalityName) {
  TableRow popRow = locationTable.findRow(municipalityName, "Position");
  int D = popRow.getInt("depth");
  float Depth = (D - minDepth) / (maxDepth - minDepth);
  return Depth;
}
float getRadius(String municipalityName) {
  float minRadius = 2;
  float maxRadius = 20;
  float amt = getDepth(municipalityName);
  return lerp(minRadius, maxRadius, amt);
}

String getEventMouse(){
  float smallestRadiusSquared = Float.MAX_VALUE;
  String underMouse = "";
  for (int i=0; i<locationTable.getRowCount(); i++) {
    TableRow rowData = locationTable.getRow(i);
    String municipality = rowData.getString("Position");
    float latitude = (rowData.getFloat("Latitude")-minLatitude)/(maxLatitude - minLatitude)*540;
      float longitude = (rowData.getFloat("Longitude")-minLongitude)/(maxLongitude - minLongitude)*1080;
    float screenX = panZoomMap.longitudeToScreenX(longitude);
    float screenY = panZoomMap.latitudeToScreenY(latitude);
    float distSquared = (mouseX-screenX)*(mouseX-screenX) + (mouseY-screenY)*(mouseY-screenY);
    float radius = getRadius(municipality);
    float radiusSquared = constrain(radius*radius, 1, height);
    if ((distSquared <= radiusSquared) && (radiusSquared < smallestRadiusSquared)) {
      underMouse = municipality;
      smallestRadiusSquared = radiusSquared;
    }
  }
  return underMouse;
}

String getContMouse() {
  String underMouse = "";
  for (int i=0; i<7; i++) {
    float screenX = 50;
    float screenY = 530+i*40;
    float distSquared = (mouseX-screenX)*(mouseX-screenX) + (mouseY-screenY)*(mouseY-screenY);
    float radiusSquared = 100;
    if ((distSquared <= radiusSquared)) {
      if (i==0){
        underMouse = "Asia";
      }
      else if (i==1){
        underMouse = "Africa";
      }
      else if (i==2){
        underMouse = "North America";
      }
      else if (i==3){
        underMouse = "Europe";
      }
      else if (i==4){
        underMouse = "South America";
    }
      else if (i==5){
        underMouse = "Oceania";
      }
      else if (i==6){
        underMouse = "All";
      }
  }
  }
return underMouse;  
}

String getSizeMouse() {

  String underMouse = "";
  for (int i=0; i<4; i++) {
    float screenX = 120;
    float screenY = 530+i*40;
    float distSquared = (mouseX-screenX)*(mouseX-screenX) + (mouseY-screenY)*(mouseY-screenY);
    float radiusSquared = 100;
    if ((distSquared <= radiusSquared)) {
      if (i==0){
        underMouse = "0-200";
        lower = 0.0;
        upper = 200.0;
      }
      else if (i==1){
        underMouse = "200-400";
        lower =200.0;
        upper =400.0;
      }
      else if (i==2){
        underMouse = "400-600";
        lower = 400.0;
        upper = 600.0;
      }
      else{
        underMouse = "600-800";
        lower = 600.0;
        upper = 800.0;
      }
    }
  }
  return underMouse;  
} 


// === PROCESSING BUILT-IN FUNCTIONS ===
void keyPressed() {
  if (key == ' ') {
    println("current scale: ", panZoomMap.scale, " current translation: ", panZoomMap.translateX, "x", panZoomMap.translateY);
  }
}


void mousePressed() {
  if (highlightedCont != "") {
    selectedCont = highlightedCont;
    println("Selected: " + selectedCont);
  }
  if(highlightedSize != ""){
    selectedSize = highlightedSize;
    
    println("Selected: " + selectedSize);
  }
  if(highlightedEvent != ""){
    selectedEvent = highlightedEvent;
    
    println("Selected: Eathquake Event: " + selectedEvent);
    
  }
  if (highlightedSecondEvent != ""){
      selectedSecond = highlightedSecondEvent;
      
    }
    println("Compare "+ selectedEvent + " with "+selectedSecond);
  panZoomMap.mousePressed();
  
}


void mouseDragged() {
  panZoomMap.mouseDragged();
}


void mouseWheel(MouseEvent e) {
  panZoomMap.mouseWheel(e);
}


void loadRawDataTables() {
  locationTable = loadTable("earthquake_data.csv", "header");
  println("Location table:", locationTable.getRowCount(), "x", locationTable.getColumnCount()); 
  
  // lookup min/max data ranges for the variables we will want to depict
  minLatitude = TableUtils.findMinFloatInColumn(locationTable, "Latitude");
  maxLatitude = TableUtils.findMaxFloatInColumn(locationTable, "Latitude");
  println("Latitude range:", minLatitude, "to", maxLatitude);

  minLongitude = TableUtils.findMinFloatInColumn(locationTable, "Longitude");
  maxLongitude = TableUtils.findMaxFloatInColumn(locationTable, "Longitude");
  println("Longitude range:", minLongitude, "to", maxLongitude);
  
  minMagnitude = TableUtils.findMinFloatInColumn(locationTable, "magnitude");
  maxMagnitude = TableUtils.findMaxFloatInColumn(locationTable, "magnitude");
  println("Magnitude range:", minMagnitude, "to", maxMagnitude);
  
  minDepth = TableUtils.findMinFloatInColumn(locationTable, "depth");
  maxDepth = TableUtils.findMaxFloatInColumn(locationTable, "depth");
  println("Depth range:", minDepth, "to", maxDepth);
}

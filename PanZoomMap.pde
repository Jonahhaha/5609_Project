/* CSci-5609 Support Code created by Prof. Dan Keefe, Fall 2023

This class extends the PanZoomPage base class.  Please read the comments at the top of
that file before continuing...

The PanZoomMap class provides a special wrapper around a PanZoomPage.  It automatically fits
a rectangular region defined in earth coordinates, i.e., (latitude, longitude), into the
virtual page provided by a PanZoomPage.  This is useful when working with data that are
supplied in (lat,long) coordinates.  The PanZoomMap class provides functions for converting
(lat,long) to the Page coordinate space (the virtual page of the PanZoomPage) AND also for
converting (lat,long) all the way to Processing's Screen coordinate space (i.e., pixels).

When you construct a PanZoomMap, you need to provide the coordinates of the rectagle of the map
(i.e., min and max latitude and longitude).  These coordinates do not need to carve out a square.
It can be any rectangle.  The PanZoomMap class will auto-fit that rectangle into the center of
its square-shaped virtual page on startup.  The approach to drawing graphics defined in the 
(lat,long) coordinate system is analogous to that used in the PanZoomPage base class.  The
difference is simply that PanZoomMap provides coordinate conversion routines that work directly
with latitude and longitude.

Since the class was created to support visualizations in Micronesia, it (currently) assumes 
latitude is North of the Equator and longitude is East of the Prime Meridian.  
TODO: Test with negative values for lat,long and document a convention; be careful when 
importing W longitudes and S latitudes, which are often stored as positive numbers but 
increasing from right to left and top to bottom, the opposite of what this class assumes.

class PanZoomMap extends PanZoomPage {
  
  public PanZoomMap(float minLat, float minLong, float maxLat, float maxLong) {
    minLatitude = minLat;
    minLongitude = minLong;
    maxLatitude = maxLat;
    maxLongitude = maxLong;
    
    mapScale = 1;
    mapTranslateX = 0;
    mapTranslateY = 0;
    
    fitMapOnPage();
  }
  
  void fitMapOnPage() {
    float deltaLat = maxLatitude - minLatitude;
    float deltaLong = maxLongitude - minLongitude;
    if (deltaLong >= deltaLat) {
      mapScale = 1.0 / deltaLong;
      mapTranslateX = 0;
      mapTranslateY = (1.0 - deltaLat * mapScale) / 2.0;
    }
    else {
      mapScale = 1.0 / deltaLat;
      mapTranslateY = 0;
      mapTranslateX = (1.0 - deltaLong * mapScale) / 2.0;      
    }
  }
  
  float longitudeToPageX(float longitude) {
    float relativeLong = longitude - minLongitude;
    return relativeLong * mapScale + mapTranslateX;
  }
  
  float latitudeToPageY(float latitude) {
    float relativeLat = latitude - minLatitude;
    return 1.0 - (relativeLat * mapScale + mapTranslateY);
  }
  
  float mapLengthToPageLength(float mapLen) {
    return mapLen * mapScale;
  }
  
  float pageXtoLongitude(float pageX) {
    return (pageX - mapTranslateX) / mapScale + minLongitude;
  }
  
  float pageYtoLatitude(float pageY) {
    return ((1.0 - pageY) - mapTranslateY) / mapScale + minLatitude;
  }
  
  float pageLengthToMapLength(float pageLen) {
    return pageLen / mapScale;
  }
  
  
  float longitudeToScreenX(float longitude) {
    float pageX = longitudeToPageX(longitude);
    return pageXtoScreenX(pageX);
  }
  
  float latitudeToScreenY(float latitude) {
    float pageY = latitudeToPageY(latitude);
    return pageYtoScreenY(pageY);
  }
  
  float mapLengthToScreenLength(float mapLen) {
    float pageLen = mapLengthToPageLength(mapLen);
    return pageLengthToScreenLength(pageLen); 
  }
  
  
  float screenXtoLongitude(float screenX) {
    float pageX = screenXtoPageX(screenX);
    return pageXtoLongitude(pageX);
  }
  
  float screenYtoLatitude(float screenY) {
    float pageY = screenYtoPageY(screenY);
    return pageYtoLatitude(pageY);
  }
  
  float screenLengthToMapLength(float screenLen) {
    float pageLen = screenLengthToPageLength(screenLen);
    return pageLengthToMapLength(pageLen); 
  }
  
  float mapScale;
  float mapTranslateX;
  float mapTranslateY;
  
  float minLatitude;
  float maxLatitude;
  float minLongitude;
  float maxLongitude;
}
*/


class PanZoomMap extends PanZoomPage {
  
  public PanZoomMap(float minLat, float minLong, float maxLat, float maxLong) {
    minLatitude = minLat;
    maxLatitude = maxLat;
    minLongitude = minLong;
    maxLongitude = maxLong;
    
    mapScale = 1;
    mapTranslateX = 0;
    mapTranslateY = 0;
    
    fitMapOnPage();
  }
  
  void fitMapOnPage() {
    float deltaLat = maxLatitude - minLatitude;
    float deltaLong = maxLongitude - minLongitude;
    if (deltaLong >= deltaLat) {
      mapScale = 1.0 / deltaLong;
      mapTranslateX = 0;
      mapTranslateY = (1.0 - deltaLat * mapScale) / 2.0;
    }
    else {
      mapScale = 1.0 / deltaLat;
      mapTranslateY = 0;
      mapTranslateX = (1.0 - deltaLong * mapScale) / 2.0;      
    }
  }
  
  float longitudeToPageX(float longitude) {
    float relativeLong = longitude - minLongitude;
    return relativeLong * mapScale + mapTranslateX;
  }
  
  float latitudeToPageY(float latitude) {
    float relativeLat = latitude - minLatitude;
    return 1.0 - (relativeLat * mapScale + mapTranslateY);
  }
  
  float mapLengthToPageLength(float mapLen) {
    return mapLen * mapScale;
  }
  
  float pageXtoLongitude(float pageX) {
    return (pageX - mapTranslateX) / mapScale + minLongitude;
  }
  
  float pageYtoLatitude(float pageY) {
    return (1.0 - pageY - mapTranslateY) / mapScale + minLatitude;
  }
  
  float pageLengthToMapLength(float pageLen) {
    return pageLen / mapScale;
  }
  
  
  float longitudeToScreenX(float longitude) {
    float pageX = longitudeToPageX(longitude);
    return pageXtoScreenX(pageX);
  }
  
  float latitudeToScreenY(float latitude) {
    float pageY = latitudeToPageY(latitude);
    return pageYtoScreenY(pageY);
  }
  
  float mapLengthToScreenLength(float mapLen) {
    float pageLen = mapLengthToPageLength(mapLen);
    return pageLengthToScreenLength(pageLen); 
  }
  
  
  float screenXtoLongitude(float screenX) {
    float pageX = screenXtoPageX(screenX);
    return pageXtoLongitude(pageX);
  }
  
  float screenYtoLatitude(float screenY) {
    float pageY = screenYtoPageY(screenY);
    return pageYtoLatitude(pageY);
  }
  
  float screenLengthToMapLength(float screenLen) {
    float pageLen = screenLengthToPageLength(screenLen);
    return pageLengthToMapLength(pageLen); 
  }
  
  float mapScale;
  float mapTranslateX;
  float mapTranslateY;
  
  float minLatitude;
  float maxLatitude;
  float minLongitude;
  float maxLongitude;
}

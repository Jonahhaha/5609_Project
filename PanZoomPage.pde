/* CSci-5609 Visualization Support Code  created by Prof. Dan Keefe, Fall 2023

This class is useful for creating 2D visualizations that are larger than the screen
and require panning and zooming with the mouse.  The way it works is that you draw
your visualization using the coordinate system of the PanZoomPage, and this class
keeps track of how that coordinate system relates to Processing's coordinate system.
The virtual page is always a square.  The origin (0,0) is at the top-left corner, like
Processing's coordinate system, but unlike Processing, the bottom-right corner of
the page has coordinates (1,1).  In other words, the virtual page is exactly 1 unit
wide by 1 unit tall.  This means anything you wish to draw within the page should have
floating point coordinates in the range 0.0 to 1.0.  In many ways this makes drawing
graphics a lot easier than Processing's default, which is 1 unit = 1 pixel.  To put
an object in the middle of the virtual page, you simply place it at (0.5, 0.5) -- no
need to check the width and height of the window and then divide by two as you would
with Processing's default coordinate system.  When the class is constructed, it
automatically sets an appropriate scale so that the virtual page fills the processing
window.  The class is quite lightweight.  It does not actually do any drawing for you.
It simply provides routines to convert from virtual page coordinates to Processing's
screen coordinates.  The way to use these is to define your graphics using virtual
page coordinates.  Then, right before drawing the graphics, use the conversion
functions to transform those virtual page coordinates into screen coordinates taking
into account the current zoom level and panning.

The code below provides a complete working example use of the class.  Click and drag
the left mouse button to pan the virtual page, and scroll the mouse wheel up or down
to zoom in and out.  

PanZoomPage panZoomPage;

void setup() {
  size(1600, 900);
  panZoomPage = new PanZoomPage(); 
}

void draw() {
  background(100);
  
  // draw a white square that covers the entire virtual page
  fill(255);
  stroke(0);
  rectMode(CORNERS);
  rect(panZoomPage.pageXtoScreenX(0), panZoomPage.pageYtoScreenY(0),
       panZoomPage.pageXtoScreenX(1), panZoomPage.pageYtoScreenY(1));

  // draw a circle at the center of the page with a radius 0.25 times the width
  // of the page
  float radius = panZoomPage.pageLengthToScreenLength(0.25);
  float cx = panZoomPage.pageXtoScreenX(0.5);
  float cy = panZoomPage.pageYtoScreenY(0.5);
  fill(200,0,200);
  ellipseMode(RADIUS);
  circle(cx, cy, radius);  
}

void mousePressed() {
  panZoomPage.mousePressed();
}

void mouseDragged() {
  panZoomPage.mouseDragged();
}

void mouseWheel(MouseEvent e) {
  panZoomPage.mouseWheel(e);
}
*/
public class PanZoomPage { 
  
  public PanZoomPage() {
    scale = 1.0;
    translateX = 0.0;
    translateY = 0.0;
    lastMouseX = 0;
    lastMouseY = 0;
  
    fitPageOnScreen(); 
  }
  
  
  float pageXtoScreenX(float pageX) {
    return pageX * scale + translateX; 
  }
  
  float pageYtoScreenY(float pageY) {
    return pageY * scale + translateY; 
  }
  
  float pageLengthToScreenLength(float l) {
    return l * scale; 
  }
  
  
  float screenXtoPageX(float screenX) {
    return (screenX - translateX) / scale;
  }
  
  float screenYtoPageY(float screenY) {
    return (screenY - translateY) / scale;
  }
  
  float screenLengthToPageLength(float l) {
    return l / scale; 
  }
  
  void fitPageOnScreen() {
    if (width >= height) {
      scale = height;
      translateY = 0;
      translateX = (width - height) / 2.0;
    }
    else {
      scale = width;
      translateX = 0;
      translateY = (height - width) / 2.0;
    }
  }

  void mousePressed() {
    if (mouseButton == LEFT) {
      lastMouseX = mouseX;
      lastMouseY = mouseY;
    }
  }
  
  void mouseDragged() {
    if (mouseButton == LEFT) {
      int deltaX = mouseX - lastMouseX;
      int deltaY = mouseY - lastMouseY;
      translateX += deltaX;
      translateY += deltaY;
      lastMouseX = mouseX;
      lastMouseY = mouseY;
    }
  }

  void mouseWheel(MouseEvent e)
  {
    float scaleDelta = 1.0;
    if (e.getCount() > 0) {
      scaleDelta = 1.02;
    } 
    else if (e.getCount() < 0) {
      scaleDelta = 0.98;
    }
  
    if (scaleDelta != 1.0) {
      translateX -= mouseX;
      translateY -= mouseY;
      scale *= scaleDelta;
      translateX *= scaleDelta;
      translateY *= scaleDelta;
      translateX += mouseX;
      translateY += mouseY;
    }
  }
  
  float scale = 1.0;
  float translateX = 0.0;
  float translateY = 0.0;
  int lastMouseX = 0;
  int lastMouseY = 0;
}

import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

// A list for all of our rectangles
ArrayList<Box> boxes;
ArrayList boundaries;
Box2DProcessing box2d;        
Box d,a;
void setup() {
  size(1000,1000);
  smooth();
  // Initialize and create the Box2D world
  box2d = new Box2DProcessing(this);    
  box2d.createWorld();
  d = new Box(width/2,height/2,25,310,BodyType.STATIC);
  a = new Box(width/2,2*height/3,400,30,BodyType.STATIC);
  
  // Create ArrayLists
  boxes = new ArrayList<Box>();
  
  boundaries = new ArrayList();
  boundaries.add(new Boundary(width/2,height-5,width,10,0));
  boundaries.add(new Boundary(width/2,5,width,10,0));
  boundaries.add(new Boundary(width-5,height/2,10,height,0));
  boundaries.add(new Boundary(5,height/2,10,height,0));
}

void draw() {
  background(255);
  
  // We must always step through time!
  box2d.step();    
  d.display();
  a.display();
  // When the mouse is clicked, add a new Box object
  if (mousePressed) {
    
    Box p = new Box(mouseX,mouseY,16,16,BodyType.DYNAMIC);
    boxes.add(p);
  }
  
  // Display all the boxes
  for (Box b: boxes) {
    b.display();
  }
}

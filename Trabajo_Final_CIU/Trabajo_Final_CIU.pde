import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;
// A list for all of our rectangles
ArrayList<Box> boxes;
ArrayList boundaries;
ArrayList<Piece> pieceCollection; 
ArrayList<Integer> staticMaker;
Box2DProcessing box2d;        
//Box d,a;
Box apile1,apile2,apile3;
Box piece1,piece2,piece3,piece4,piece5;
HandBox handBox ;
int conter;
Spring spring;
Boolean pressed = false;
void setup() {
  staticMaker = new ArrayList<Integer>();
  conter = 0;
  size(1000,1000);
  smooth();
  // Initialize and create the Box2D world
  box2d = new Box2DProcessing(this);    
  box2d.createWorld();
  box2d.setGravity(0, -10);
  
  //d = new Box(width/2,height/2,25,310,BodyType.STATIC);
  //piece1 = new Box(width/6,2*height/3,200,30,BodyType.DYNAMIC);
  spring = new Spring();
  apile1 = new Box(width/6,2*height/3,200,30,BodyType.STATIC);
  apile2 = new Box(width/6 * 3,2*height/3,200,30,BodyType.STATIC);
  apile3 = new Box(width/6 * 5,2*height/3,200,30,BodyType.STATIC);
  
  // Create ArrayLists
  boxes = new ArrayList<Box>();
  createBoundaries();
  createPieces(6);
  box2d.listenForCollisions();
}

void draw() {
  background(255);
  conter++;
  // We must always step through time!
  theStaticMaker();
  box2d.step();    
  
  spring.update(mouseX,mouseY);
  //d.display();
  //a.display();
  apile1.display();
  apile2.display();
  apile3.display();
  
  
  // When the mouse is clicked, add a new Box object
  
  
  // Display all the boxes
  /*for (Box b: boxes) {
    b.display();
  }*/

  if(mousePressed){
    //handBox.updatePosition(mouseX,mouseY);
    handBox.display();
  }
  for (Piece p: pieceCollection){
    p.display();
  }

  /*if(handBox != null)
    handBox.killBody();
    handBox = null;*/
    line(width/3,0,width/3,1000);
    line(width/3 * 2,0,width/3*2,1000);
}
void createPieces(int nPieces){
  pieceCollection = new ArrayList<Piece>();
  int maxWidth = width/6; 
  int totalHeight = height/5;
  int firstHeight =  2*height/3;
  int pieceHeight = (totalHeight/nPieces);
  for (int i = 0; i < nPieces; i++){
    Piece newPiece = new Piece(width/6,firstHeight - (pieceHeight*(i+1 ))
      ,maxWidth * (nPieces - i)/nPieces,pieceHeight,i,BodyType.DYNAMIC,
      color((255/nPieces)*(nPieces - i),(255/nPieces)*(i+1),255));
    pieceCollection.add(newPiece);
  }
}
void createBoundaries(){
  boundaries = new ArrayList();
  boundaries.add(new Boundary(width/2,height-5,width,10,0));
  boundaries.add(new Boundary(width/2,5,width,10,0));
  boundaries.add(new Boundary(width-5,height/2,10,height,0));
  boundaries.add(new Boundary(5,height/2,10,height,0));
}
void mouseReleased(){
  pressed = false;
  spring.destroy();
  handBox.killBody();
  
}
void mousePressed(){
  /*if (!pressed){
    
    //
  
    
    pressed = true; 
    
  }*/
  //handBox = new HandBox(mouseX,mouseY,20,20,BodyType.KINEMATIC);
  handBox = new HandBox(mouseX,mouseY,20,20,BodyType.DYNAMIC);
  handBox.teleport(box2d.coordPixelsToWorld(mouseX,mouseY));
  spring.bind(mouseX,mouseY,handBox);
   
  
}

void beginContact(Contact con){
    Fixture f1 = con.getFixtureA();
    Fixture f2 = con.getFixtureB();
    
    Body b1 = f1.getBody();
    Body b2 = f2.getBody();
    
    Object o1 = b1.getUserData();
    Object o2 = b2.getUserData();
    if (o1 == null ||o2 == null || o1.getClass() == HandBox.class || o2.getClass() == HandBox.class) return;
    //System.out.println("Hay colisión");
    
    if (o1.getClass() == Piece.class &&
        o2.getClass() == Piece.class)
        pieceToPieceController(o1,o2);  
    else if(o1.getClass() == Box.class || o2.getClass() == Box.class )
        pieceToBoxController(o1,o2);    
  }
  
  void endContact(Contact con){
    Fixture f1 = con.getFixtureA();
    Fixture f2 = con.getFixtureB();
    
    Body b1 = f1.getBody();
    Body b2 = f2.getBody();
    
    Object o1 = b1.getUserData();
    Object o2 = b2.getUserData();
    if (o1.getClass() == Piece.class &&
        o2.getClass() == Piece.class){ 
         
        Piece p1 = (Piece)o1;
        Piece p2 = (Piece)o2;
        
        p1.getBodyType();
    }    
  }
  
  void theStaticMaker(){
    if(staticMaker.size() > 0){
      for (Integer id : staticMaker){
        pieceCollection.get(id).makeStatic();
      }
    }  
  }
  
  void pieceToPieceController(Object o1, Object o2){
        Piece p1 = (Piece)o1;
        Piece p2 = (Piece)o2;
        
        if(p1.getBody().getPosition().y > p2.getBody().getPosition().y && p1.getBodyType() != BodyType.STATIC){
          System.out.println(p1.getId() + " > " + p2.getId());
          //p2.makeStatic();
          staticMaker.add(p2.getId());
          //p2.getBody().setType(BodyType.STATIC);
        }else if(p2.getBodyType() != BodyType.STATIC){
          System.out.println(p2.getId() + " > " + p1.getId());
          staticMaker.add(p1.getId());
        }
  }
  
  void pieceToBoxController(Object o1, Object o2){
    Box b;
    Piece p;
    if(o1.getClass() == Box.class){
      b = (Box)o1;
      p = (Piece)o2;
    }
    else{
      b = (Box)o2;
      p = (Piece)o1;
    }
    
  }

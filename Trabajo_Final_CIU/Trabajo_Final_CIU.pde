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
ArrayList<Integer> staticMaker,staticCola;
ArrayList<Integer> dynamicMaker,dynamicCola;
Box2DProcessing box2d;        
//Box d,a;
Box apile1, apile2, apile3;
//Box piece1, piece2, piece3, piece4, piece5;
HandBox handBox ;
int conter;
Spring spring;
Boolean pressed = false;
int freeId;
int[] towerLastId;
boolean staticAccess,dynamicAccess;
int numberOfPieces = 6;
void setup() {
  staticMaker = new ArrayList<Integer>();
  dynamicMaker = new ArrayList<Integer>();
  staticCola = new ArrayList<Integer>();
  dynamicCola = new ArrayList<Integer>();
  conter = 0;
  size(1000, 1000);
  smooth();
  // Initialize and create the Box2D world
  box2d = new Box2DProcessing(this);    
  box2d.createWorld();
  box2d.setGravity(0, -10);

  //d = new Box(width/2,height/2,25,310,BodyType.STATIC);
  //piece1 = new Box(width/6,2*height/3,200,30,BodyType.DYNAMIC);
  spring = new Spring();
  apile1 = new Box(width/6, 2*height/3, 200, 30, BodyType.STATIC,0);
  apile2 = new Box(width/6 * 3, 2*height/3, 200, 30, BodyType.STATIC,1);
  apile3 = new Box(width/6 * 5, 2*height/3, 200, 30, BodyType.STATIC,2);

  // Create ArrayLists
  boxes = new ArrayList<Box>();
  createBoundaries();
  createPieces(numberOfPieces);
  box2d.listenForCollisions();

  freeId = -1;
  towerLastId = new int[3];
  towerLastId[0]=5; 
  towerLastId[1]=-1; 
  towerLastId[2]=-1;
  
  for (int i = 0; i < 5; i++){
    staticMaker.add(i);
  }
}
void draw() {
  println(towerLastId);
  theDynamicMaker();
  theStaticMaker();
  //if(freeId != -1 && pieceCollection.get(freeId).getBodyType() == BodyType.STATIC);
  background(255);
  conter++;
  // We must always step through time!
  
  
  box2d.step();    

  spring.update(mouseX, mouseY);
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

  if (mousePressed) {
    //handBox.updatePosition(mouseX,mouseY);
    handBox.display();
  }
  for (Piece p : pieceCollection) {
    p.display();
  }

  /*if(handBox != null)
   handBox.killBody();
   handBox = null;*/
  line(width/3, 0, width/3, 1000);
  line(width/3 * 2, 0, width/3*2, 1000);
}
void createPieces(int nPieces) {
  pieceCollection = new ArrayList<Piece>();
  int maxWidth = width/6; 
  int totalHeight = height/5;
  int firstHeight =  2*height/3;
  int pieceHeight = (totalHeight/nPieces);
  for (int i = 0; i < nPieces; i++) {
    Piece newPiece = new Piece(width/6, firstHeight - (pieceHeight*(i+1 ))
      , maxWidth * (nPieces - i)/nPieces, pieceHeight, i, BodyType.DYNAMIC, 
      color((255/nPieces)*(nPieces - i), (255/nPieces)*(i+1), 255));
    pieceCollection.add(newPiece);
  }
}
void createBoundaries() {
  boundaries = new ArrayList();
  boundaries.add(new Boundary(width/2, height-5, width, 10, 0));
  boundaries.add(new Boundary(width/2, 5, width, 10, 0));
  boundaries.add(new Boundary(width-5, height/2, 10, height, 0));
  boundaries.add(new Boundary(5, height/2, 10, height, 0));
}
void mouseReleased() {
  pressed = false;
  spring.destroy();
  handBox.killBody();
}
void mousePressed() {
  /*if (!pressed){
   
   //
   
   
   pressed = true; 
   
   }*/
  //handBox = new HandBox(mouseX,mouseY,20,20,BodyType.KINEMATIC);
  handBox = new HandBox(mouseX, mouseY, 20, 20, BodyType.DYNAMIC);
  handBox.teleport(box2d.coordPixelsToWorld(mouseX, mouseY));
  spring.bind(mouseX, mouseY, handBox);
}

void beginContact(Contact con) {
  Fixture f1 = con.getFixtureA();
  Fixture f2 = con.getFixtureB();

  Body b1 = f1.getBody();
  Body b2 = f2.getBody();

  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();
  
  if (o1 == null ||o2 == null || o1.getClass() == HandBox.class || o2.getClass() == HandBox.class) return ; 
  //System.out.println("Hay colisión");
  
  if (o1.getClass() == Piece.class &&
    o2.getClass() == Piece.class){
      Piece p1 = (Piece)o1;
      Piece p2 = (Piece)o2;
      if (p1.getBody().getPosition().y > p2.getBody().getPosition().y  && freeId == p1.getId() && -1 != contains(towerLastId,p2.getId()) ) {
        int tower = contains(towerLastId,p2.getId());
        towerLastId[tower] = p1.getId();
        freeId = -1;
        makeArrayDynamic(towerLastId);
      }else if(freeId == p2.getId() && -1 != contains(towerLastId,p1.getId())){
        int tower = contains(towerLastId,p1.getId());
        towerLastId[tower] = p2.getId();
        freeId = -1;
        makeArrayDynamic(towerLastId);
      }
    //pieceToPieceController(o1, o2);  
  }
  else if (o1.getClass() == Box.class || o2.getClass() == Box.class ){
    Box b;
    Piece p;
    if (o1.getClass() == Box.class) {
      b = (Box)o1;
      p = (Piece)o2;
    } else {
      b = (Box)o2;
      p = (Piece)o1;
    }
    if(freeId == p.getId() && towerLastId[b.getId()] == -1 ){
      towerLastId[b.getId()]= p.getId();
      freeId = -1;
      makeArrayDynamic(towerLastId);
      
      
    }
    //pieceToBoxController(o1, o2);*/
    
  }
  //println(towerLastId);
}

void endContact(Contact con) {
  Fixture f1 = con.getFixtureA();
  Fixture f2 = con.getFixtureB();

  Body b1 = f1.getBody();
  Body b2 = f2.getBody();

  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();
  if (o1 == null ||o2 == null || o1.getClass() == HandBox.class || o2.getClass() == HandBox.class) return ; 
  
  if (o1.getClass() == Piece.class &&
    o2.getClass() == Piece.class) { 
    Piece p1 = (Piece)o1;
    Piece p2 = (Piece)o2;
    int tower = contains(towerLastId,p1.getId());
    if (tower != -1 && freeId == -1){//p2.getId() != freeId && p1.getBodyType() != BodyType.STATIC){
      //print("p1 es " + p1.getId() + " Sale");
      int id = p1.getId() ;
      freeId = id;
      towerLastId[tower] = p2.getId();
      allStaticExcept(new int[] {id});
      return;
    }
    tower = contains(towerLastId,p2.getId());
    if(tower != -1 && freeId == -1){//p1.getId() != freeId ){
      //print("p2 es " + p2.getId() + " Sale");
      int id = p2.getId() ;
      freeId = id;
      towerLastId[tower] = p1.getId();
      allStaticExcept(new int[] {id});
      return;
    }
   
  }
  else if (o1.getClass() == Box.class || o2.getClass() == Box.class ){
    Box b;
    Piece p;
    if (o1.getClass() == Box.class) {
      b = (Box)o1;
      p = (Piece)o2;
    } else {
      b = (Box)o2;
      p = (Piece)o1;
    }
    
    if(-1 != contains(towerLastId,p.getId())&& freeId == -1){
        int id = p.getId() ;
        freeId = id;
        towerLastId[b.getId()] = -1;
        allStaticExcept(new int[] {id});
    }
  }
}

void theStaticMaker() {
  if(staticCola.size() > 0){ staticMaker.addAll(staticCola);staticCola.clear();}
  if (staticMaker.size() > 0) {
    //println("Static " + staticMaker);
    for (Integer id : staticMaker) {
      //println("Static de " + id);
      pieceCollection.get(id).makeStatic();
    }
    staticMaker.clear();
  }
}

void theDynamicMaker() {
  if(dynamicCola.size() > 0){ dynamicMaker.addAll(dynamicCola);dynamicCola.clear();}
  if (dynamicMaker.size() > 0) {
    //println("Dynamic " + dynamicMaker);
    for (Integer id : dynamicMaker) {
       //println("Dynamic de " + id);
      pieceCollection.get(id).makeDynamic();
    }
  }
  dynamicMaker.clear();
}

/*void pieceToPieceController(Object o1, Object o2) {
  Piece p1 = (Piece)o1;
  Piece p2 = (Piece)o2;

  if (p1.getBody().getPosition().y > p2.getBody().getPosition().y && p1.getBodyType() != BodyType.STATIC) {
    System.out.println(p1.getId() + " > " + p2.getId());
    //p2.makeStatic();
    staticMaker.add(p2.getId());
    //p2.getBody().setType(BodyType.STATIC);
  } else if (p2.getBodyType() != BodyType.STATIC) {
    System.out.println(p2.getId() + " > " + p1.getId());
    staticMaker.add(p1.getId());
  }
}
*/
void pieceToBoxController(Object o1, Object o2) {
  Box b;
  Piece p;
  if (o1.getClass() == Box.class) {
    b = (Box)o1;
    p = (Piece)o2;
  } else {
    b = (Box)o2;
    p = (Piece)o1;
  }
}


void pieceToPieceReleaser(Object o1, Object o2) {
  Piece p1 = (Piece)o1;
  Piece p2 = (Piece)o2;

  if (p1.getBody().getPosition().y > p2.getBody().getPosition().y && p1.getBodyType() != BodyType.DYNAMIC) {
    //System.out.println(p1.getId() + " > " + p2.getId());
    //p2.makeStatic();
    
      dynamicMaker.add(p2.getId());
    //p2.getBody().setType(BodyType.STATIC);
  } else if (p2.getBodyType() != BodyType.DYNAMIC) {
    //System.out.println(p2.getId() + " > " + p1.getId());
    dynamicMaker.add(p1.getId());
  }
}


void allStaticExcept(int[] nonStaticId){
  for (Piece p : pieceCollection){
    if (contains(nonStaticId,p.getId()) == -1 && !staticCola.contains(p.getId()) ) {
      //println("Static = " + p.getId());
      staticCola.add(p.getId());
    }
  }
}

void makeArrayDynamic(int[] toDynamic){
  for (int n : toDynamic){
    
    if (n != -1 && !dynamicCola.contains(n) ) {
      //println("Static = " + p.getId());
     
      dynamicCola.add(n);
    }
  }
}

int contains(int[] array,int v) {
  int cont = 0;
  int result = -1;
  for(int i : array){
    if(i == v){
      result = cont;
      break;
    }
    cont++;
  }
  return result;
}

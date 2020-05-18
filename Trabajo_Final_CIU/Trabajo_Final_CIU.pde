import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

ArrayList<Box> boxes;
ArrayList boundaries;
ArrayList<Piece> pieceCollection; 
ArrayList<Integer> staticMaker,staticCola;
ArrayList<Integer> dynamicMaker,dynamicCola;
static Box2DProcessing box2d;
;
Box leftBase, centerBase, rightBase;
HandBox handBox ;
int accountant;
Spring spring;
Boolean pressed = false;
int freeId;
int[] towerLastId;
boolean staticAccess,dynamicAccess;
int numberOfPieces = 6;

void setup() {
  
  size(1000, 1000);
  arrayListInitizalizers();
  accountant = 0;
  smooth();
  createBox2DWorld();

  spring = new Spring();
  createBases();
  createGameField();
   
  initilizePiecesLogic();
  
  for (int i = 0; i < numberOfPieces - 1; i++){
    staticMaker.add(i);
  }
}

void draw() {
  background(255);
  theDynamicMaker();
  theStaticMaker();
  
  accountant++;
  
  box2d.step();    

  spring.update(mouseX, mouseY);
  displayBases();
  
  if (mousePressed) {
    handBox.display();
  }
  displayGameObjects();

  
}


void createPieces(int nPieces) {
  for (int i = 0; i < nPieces; i++) {
    PieceDTO pieceDTO = fillPieceDTO(nPieces,i);
    Piece newPiece = new Piece(pieceDTO.x, pieceDTO.y,pieceDTO.w, pieceDTO.h, pieceDTO.id, pieceDTO.bodyType,pieceDTO.tone);
    pieceCollection.add(newPiece);
  }
}



void mouseReleased() {
  pressed = false;
  spring.destroy();
  handBox.killBody();
  println(freeId);
  println(freeId);
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
      if (p1.getBody().getPosition().y > p2.getBody().getPosition().y  && freeId == p1.getId() && -1 != contains(towerLastId,p2.getId()) && p1.getId() > p2.getId() ) {
        println(p1.getId() + " toca a " + p2.getId() );
        int tower = contains(towerLastId,p2.getId());
        towerLastId[tower] = p1.getId();
        freeId = -1;
        makeArrayDynamic(towerLastId);
      }else if(freeId == p2.getId() && -1 != contains(towerLastId,p1.getId()) && p2.getId() > p1.getId() ){
        println(p2.getId() + " toca a " + p1.getId() );
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
      println(p.getId() + " toca un bloque " );
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
    if (tower != -1 && freeId == -1 && p1.getBodyType() != BodyType.STATIC){//p2.getId() != freeId && p1.getBodyType() != BodyType.STATIC){
      println( p1.getId() + " se separa de " + p2.getId());
      int id = p1.getId() ;
      freeId = id;
      towerLastId[tower] = p2.getId();
      allStaticExcept(new int[] {id});
      return;
    }
    tower = contains(towerLastId,p2.getId());
    if(tower != -1 && freeId == -1 && p2.getBodyType() != BodyType.STATIC){//p1.getId() != freeId ){
      println( p2.getId() + " se separa de " + p1.getId());
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
    
    if(-1 != contains(towerLastId,p.getId()) && freeId == -1 && p.getBodyType() != BodyType.STATIC){
        println( p.getId() + " se separa de un bloque" );
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

  if (p1.getBody().getPosition().y > p2.getBody().getPosition().y && p1.getBodyType() != BodyType.DYNAMIC ) {
    
      dynamicMaker.add(p2.getId());
  } else if (p2.getBodyType() != BodyType.DYNAMIC) {
    dynamicMaker.add(p1.getId());
  }
}


void allStaticExcept(int[] nonStaticId){
  for (Piece p : pieceCollection){
    if (contains(nonStaticId,p.getId()) == -1 && !staticCola.contains(p.getId()) ) {
      staticCola.add(p.getId());
    }
  }
}

void makeArrayDynamic(int[] toDynamic){
  for (int n : toDynamic){
    
    if (n != -1 && !dynamicCola.contains(n) ) {
     
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

void arrayListInitizalizers(){
  staticMaker = new ArrayList<Integer>();
  dynamicMaker = new ArrayList<Integer>();
  staticCola = new ArrayList<Integer>();
  dynamicCola = new ArrayList<Integer>();
  pieceCollection = new ArrayList<Piece>();
  boxes = new ArrayList<Box>();
  boundaries = new ArrayList();
}

void createBox2DWorld(){
  box2d = new Box2DProcessing(this);    
  box2d.createWorld();
  box2d.setGravity(0, -10);
  box2d.listenForCollisions();
}

void createBases(){
  leftBase = new Box(width/6, 2*height/3, 200, 30, BodyType.STATIC,0);
  centerBase = new Box(width/6 * 3, 2*height/3, 200, 30, BodyType.STATIC,1);
  rightBase = new Box(width/6 * 5, 2*height/3, 200, 30, BodyType.STATIC,2);
}

void initilizePiecesLogic(){
  freeId = -1;
  towerLastId = new int[3];
  towerLastId[0]= numberOfPieces -1; 
  towerLastId[1]=-1; 
  towerLastId[2]=-1;
}

void createGameField(){
  createBoundaries();
  createPieces(numberOfPieces);
}

void displayBases(){
  leftBase.display();
  centerBase.display();
  rightBase.display();

}

void createBoundaries() {
  boundaries.add(new Boundary(width/2, height-5, width, 10, 0));
  boundaries.add(new Boundary(width/2, 5, width, 10, 0));
  boundaries.add(new Boundary(width-5, height/2, 10, height, 0));
  boundaries.add(new Boundary(5, height/2, 10, height, 0));
}

void displayGameObjects(){
  for (Piece p : pieceCollection) {
    p.display();
  }
  line(width/3, 0, width/3, 1000);
  line(width/3 * 2, 0, width/3*2, 1000);
  
}

PieceDTO fillPieceDTO(int nPieces, int index){
  HashMap<String,Float> pieceParameters = getPieceParameters(nPieces);
  PieceDTO pieceDTO = new PieceDTO();
  
  pieceDTO.x = pieceParameters.get("maxWidth");
  pieceDTO.y = pieceParameters.get("firstHeight") - (pieceParameters.get("pieceHeight")*(index+1 ));
  pieceDTO.w = pieceParameters.get("maxWidth") * (nPieces - index)/nPieces;
  pieceDTO.h = pieceParameters.get("pieceHeight");
  pieceDTO.id = index;
  pieceDTO.bodyType = BodyType.DYNAMIC;
  pieceDTO.tone = color((255/nPieces)*(nPieces - index), (255/nPieces)*(index+1), 255);
  
  return pieceDTO;
   
}

HashMap getPieceParameters(int nPieces){
  HashMap<String,Float> map = new HashMap<String,Float>();
  map.put("maxWidth",width/6.0);
  map.put("firstHeight",2*height/3.0);
  map.put("pieceHeight",(height/5.0)/nPieces);
  return map;
}

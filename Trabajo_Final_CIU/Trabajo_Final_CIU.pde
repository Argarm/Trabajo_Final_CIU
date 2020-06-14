import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;
import arb.soundcipher.*;
import java.util.ArrayDeque;
import kinect4WinSDK.Kinect;
import kinect4WinSDK.SkeletonData;
import java.awt.Point;
import java.awt.Color;
import controlP5.*;

ArrayDeque<Integer>[] torres;
ArrayList<Box> boxes;
ArrayList boundaries;
ArrayList<Piece> pieceCollection;
ArrayList<Integer> staticMaker,staticCola;
ArrayList<Integer> dynamicMaker,dynamicCola;
static Box2DProcessing box2d;

//Kinect kinect;
Box leftBase, centerBase, rightBase;
HandBox rightHandBox, leftHandBox;
int accountant;
Spring springRightHand, springLeftHand;
Boolean pressed = false;
int freeId;
int[] towerLastId;
boolean staticAccess,dynamicAccess;
int numberOfPieces = 6;
SoundCipher sc;
Estado estado;
enum Estado{
  menuPrincipal,
  menuOpciones,
  juego,
  pausa

}
color myColor;
ControlP5 cp5;
//ArrayList <SkeletonData> bodies;
Point rightHandPos;
Point leftHandPos;
int posXButton;
int tamXButton;
int tamYButton;
int posYButtonOffset;
int buttonYSeparator;
boolean cam;
void setup(){
  
  size(640, 480);
  cp5 = new ControlP5(this);
  //kinect = new Kinect(this);
  buttonParametersInitializers();
  arrayListInitizalizers();
  accountant = 0;
  smooth();
  createBox2DWorld();
  estado = Estado.menuPrincipal;
  dibujaMenuPrincipal();
  //bodies = new ArrayList<SkeletonData>();
  springRightHand = new Spring();
  springLeftHand = new Spring();
  createBases();
  createGameField();
   
  initilizePiecesLogic();
  torres = new ArrayDeque[3];
  torres[0] = new ArrayDeque<Integer>();
  torres[1] = new ArrayDeque<Integer>();
  torres[2] = new ArrayDeque<Integer>();
  for (int i = 0; i < numberOfPieces - 1; i++){
    staticMaker.add(i);
    torres[0].push(i);
  }
  torres[0].push(numberOfPieces - 1);
  sc = new SoundCipher(this);

  leftHandBox = new HandBox(width / 2, height / 2 - 50, 20,  20, BodyType.DYNAMIC);
  leftHandBox.teleport(box2d.coordPixelsToWorld(width / 2, height / 2 - 50));
  springLeftHand.bind(width / 2, height / 2 - 50, leftHandBox);
  
  rightHandBox = new HandBox(width / 2, height / 2 - 50, 20,  20, BodyType.DYNAMIC);
  rightHandBox.teleport(box2d.coordPixelsToWorld(width / 2, height / 2 - 50));
  springRightHand.bind(width / 2, height / 2 - 50, rightHandBox);
}

void draw(){
  background(0);
  //image(kinect.GetImage(),0,0,width,height);
  
  /*for (int i=0; i<bodies.size (); i++)
    drawSkeleton(bodies.get(i));
  */
  if(estado == Estado.juego){
    theDynamicMaker();
    theStaticMaker();
    
    accountant++;
    
    box2d.step();    

    if (rightHandPos != null){
      springRightHand.update(rightHandPos.x, rightHandPos.y); 
    }

    if (leftHandPos != null){
      springLeftHand.update(leftHandPos.x, leftHandPos.y); 
    }
      
    displayBases();

    rightHandBox.display();
    leftHandBox.display();
    
    displayGameObjects();
  }
}

void createPieces(int nPieces){
  for (int i = 0; i < nPieces; i++) {
    PieceDTO pieceDTO = fillPieceDTO(nPieces,i);
    Piece newPiece = new Piece(pieceDTO.x, pieceDTO.y,pieceDTO.w, pieceDTO.h, pieceDTO.id, pieceDTO.bodyType,pieceDTO.tone);
    pieceCollection.add(newPiece);
  }
}

void beginContact(Contact con) {
  Fixture f1 = con.getFixtureA();
  Fixture f2 = con.getFixtureB();

  Body b1 = f1.getBody();
  Body b2 = f2.getBody();

  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();
  
  
  if (o1 == null ||o2 == null || o1.getClass() == HandBox.class || o2.getClass() == HandBox.class){ sc.playNote(5, 40, 0.1);;return; }; 
  
  
  if (o1.getClass() == Piece.class &&
    o2.getClass() == Piece.class){
      Piece p1 = (Piece)o1;
      Piece p2 = (Piece)o2;
      if(freeId != -1 ) sc.playNote((10 + p1.getId())*5, 75, 0.2);
      if (p1.getBody().getPosition().y > p2.getBody().getPosition().y  && freeId == p1.getId() && -1 != towerHead(p2.getId()) && p1.getId() > p2.getId() ) {
        
        println(p1.getId() + " toca a " + p2.getId() );
        int tower = towerHead(p2.getId());
        
        torres[tower].push(p1.getId());
        freeId = -1;
        towerHeadsDynamic();
      }else if(freeId == p2.getId() && -1 != towerHead(p1.getId()) && p2.getId() > p1.getId() ){
        
        println(p2.getId() + " toca a " + p1.getId() );
        int tower = towerHead(p1.getId());
        torres[tower].push(p2.getId());
        freeId = -1;
        
        towerHeadsDynamic();
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
    if(freeId != -1 ) sc.playNote((10 + p.getId())*6, 50, 0.2);
    if(freeId == p.getId() && torres[b.getId()].isEmpty() ){
      sc.playNote((10 + p.getId())*5, 75, 0.2);
      println(p.getId() + " toca un bloque " );
      
      torres[b.getId()].push(p.getId());
      freeId = -1;
      towerHeadsDynamic();
      
      
    }
    
    
  }else sc.playNote((10), 45, 0.2);
  print("freeId = " + freeId + ";  towers = ");
  for(int i = 0; i < torres.length; i++){
    println(torres[i]);
  }
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
    
    int tower = towerHead(p1.getId());
    
    if (tower != -1 && freeId == -1 && p1.getBodyType() != BodyType.STATIC ){
      println( p1.getId() + " se separa de " + p2.getId());
      int id = p1.getId() ;
      freeId = id;
      
      torres[tower].pop();
      if (torres[tower].peek() == p2.getId()){
        freeId = id;
        allStaticExcept(new int[] {id});
      }
      else
        torres[tower].push(id);
      return;
    }
    tower = towerHead(p2.getId());
    if(tower != -1 && freeId == -1 && p2.getBodyType() != BodyType.STATIC){
      println( p2.getId() + " se separa de " + p1.getId());
      int id = p2.getId() ;
      
      torres[tower].pop();
      if (torres[tower].peek() == p1.getId()){
        freeId = id;
        allStaticExcept(new int[] {id});
      }
      else
        torres[tower].push(id);
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
    
    if(-1 != towerHead(p.getId()) && freeId == -1 && p.getBodyType() != BodyType.STATIC){
        println( p.getId() + " se separa de un bloque" );
        int id = p.getId();
        freeId = id;
        if(!torres[towerHead(p.getId())].isEmpty())torres[towerHead(p.getId())].pop();
        allStaticExcept(new int[] {id});
        
    }
  }
  print("freeId = " + freeId + ";  towers = ");
  for(int i = 0; i < torres.length; i++){
    println(torres[i]);
  }

}

void theStaticMaker() {
  if(staticCola.size() > 0){
    staticMaker.addAll(staticCola);
    staticCola.clear();
  }
  if (staticMaker.size() > 0) {
    for (Integer id : staticMaker) {
      pieceCollection.get(id).makeStatic();
    }
    staticMaker.clear();
  }
}

void theDynamicMaker() {
  if(dynamicCola.size() > 0){ 
    dynamicMaker.addAll(dynamicCola);
    dynamicCola.clear();
  }
  if (dynamicMaker.size() > 0) {
    for (Integer id : dynamicMaker) {
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

void towerHeadsDynamic(){
  for (ArrayDeque<Integer> n : torres){
    
    if (!n.isEmpty() && !dynamicCola.contains(n.peek()) ) {
     
      dynamicCola.add(n.peek());
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

int towerHead(int v){
  int cont = 0;
  int result = -1;
  
  for(ArrayDeque<Integer> i : torres){
    if(!i.isEmpty() && i.peek() == v){
      
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
  leftBase = new Box(width/6, height - height/5, width/4, height/15, BodyType.STATIC,0);
  centerBase = new Box(width/6 * 3, height - height/5,width/4, height/15, BodyType.STATIC,1);
  rightBase = new Box(width/6 * 5, height - height/5, width/4, height/15, BodyType.STATIC,2);
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
  map.put("firstHeight",height - height/5.0);
  map.put("pieceHeight",(height/5.0)/nPieces);
  return map;
}

void drawSkeleton(SkeletonData _s){
  
  leftHandPos = DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_WRIST_LEFT, 
  Kinect.NUI_SKELETON_POSITION_HAND_LEFT);
  println("LEFT: ");
  println(leftHandPos);
  
  rightHandPos = DrawBone(_s, 
  Kinect.NUI_SKELETON_POSITION_WRIST_RIGHT, 
  Kinect.NUI_SKELETON_POSITION_HAND_RIGHT);
  println("RIGHT: ");
  println(rightHandPos);
}

Point DrawBone(SkeletonData _s, int _j1, int _j2){
  Point result = null;

  pushStyle();
  fill(255, 255, 0);
  stroke(255, 255, 0);
  if (_s.skeletonPositionTrackingState[_j1] != Kinect.NUI_SKELETON_POSITION_NOT_TRACKED &&
    _s.skeletonPositionTrackingState[_j2] != Kinect.NUI_SKELETON_POSITION_NOT_TRACKED) {
  
    result = getRectangle(_s, _j1, _j2);
  }
  popStyle();
  return result;
}

Point getRectangle(SkeletonData _s, int _j1, int _j2){

  float x, y, w, h;
  float wristX = _s.skeletonPositions[_j1].x*width;
  float wristY = _s.skeletonPositions[_j1].y*height;
  float handX = _s.skeletonPositions[_j2].x*width;
  float handY = _s.skeletonPositions[_j2].y*height;

  if (wristX < handX){
    x = wristX;
    w = handX - wristX;
  }else{
    x = handX;
    w = wristX - handX;
  }
  
  if (wristY < handY){
    y = wristY;
    h = handY - wristY;
  }else{
    y = handY;
    h = wristY - handY;
  }

  return new Point((int)(x + w/2), (int)(y + h/2));

}

void appearEvent(SkeletonData _s){
  if (_s.trackingState == Kinect.NUI_SKELETON_NOT_TRACKED) return;

  /*synchronized(bodies) {
    bodies.add(_s);
  }*/
}

void disappearEvent(SkeletonData _s){
  /*synchronized(bodies) {
    for (int i=bodies.size ()-1; i>=0; i--) 
    {
      if (_s.dwTrackingID == bodies.get(i).dwTrackingID) 
        bodies.remove(i);
    }
  }*/
}

void moveEvent(SkeletonData _b, SkeletonData _a){
  if (_a.trackingState == Kinect.NUI_SKELETON_NOT_TRACKED) return;

  /*synchronized(bodies) {
    for (int i=bodies.size ()-1; i>=0; i--) 
    {
      if (_b.dwTrackingID == bodies.get(i).dwTrackingID) 
      {
        bodies.get(i).copy(_a);
        break;
      }
    }
  }*/
}

void keyPressed() {
    if(key == ' '){
      if(estado == Estado.juego){
        estado = Estado.pausa;
        dibujaMenuPausa();
      }else {
        estado = Estado.juego;
        borraMenuPausa();
      }
    }
}

public void Comenzar() {
  borraMenuPrincipal();
  estado = Estado.juego;
}

public void Opciones() {
  dibujaMenuOpciones();
}


public void Salir() {
  delay(1000);
  exit();
}

public void Sonido(){
  int slidderX = round(posXButton + 1.1*tamXButton);
  int slidderY = height/4;
  int sliderWidth = 30;
  int sliderHeight = 200;
  if(cp5.getController("Volumen") != null)cp5.getController("Volumen").remove();
  else cp5.addSlider("Volumen",0,10,5,slidderX,slidderY,sliderWidth,sliderHeight);
}

public void Dificultad(){

}
public void Camara(){
  cam = !cam;
  if(cam){
    myColor = color(0,150,0);
    cp5.getController("Camara")
       .setColorBackground(myColor);
  }else{
    myColor = color(150,0,0);
    cp5.getController("Camara")
       .setColorBackground(myColor);
  }
  
}
public void Atras(){
  dibujaMenuPrincipal();
}

public void Reanudar(){
  borraMenuPausa();
  estado = Estado.juego;
}

void dibujaMenuPrincipal(){
  if(estado == Estado.menuOpciones){
    borraMenuOpciones();
    estado = Estado.menuPrincipal;
  }
  cp5.addButton("Comenzar")
     .setPosition(posXButton,posYButtonOffset)
     .setSize(tamXButton,tamYButton);
  

  cp5.addButton("Opciones")
     .setPosition(posXButton,posYButtonOffset+buttonYSeparator+tamYButton)
     .setSize(tamXButton,tamYButton);
     
  cp5.addButton("Salir")
     .setPosition(posXButton,posYButtonOffset+2*(buttonYSeparator+tamYButton))
     .setSize(tamXButton,tamYButton);

}

void borraMenuOpciones(){
  cp5.getController("Sonido").remove();
  cp5.getController("Dificultad").remove();
  cp5.getController("Camara").remove();
  cp5.getController("Atras").remove();
}


void dibujaMenuOpciones(){
  if(estado == Estado.menuPrincipal){
    borraMenuPrincipal();
    estado = Estado.menuOpciones;
  }
  if(estado == Estado.pausa){
    borraMenuPausa();
  }
  int posYButtonOffsetOpciones = height/4;
  cp5.addButton("Sonido")
     .setPosition(posXButton,posYButtonOffsetOpciones)
     .setSize(tamXButton,tamYButton);
  
  
  cp5.addButton("Dificultad")
     .setPosition(posXButton,posYButtonOffsetOpciones+buttonYSeparator+tamYButton)
     .setSize(tamXButton,tamYButton);
     
  cp5.addButton("Camara").setColorBackground(myColor)
     .setPosition(posXButton,posYButtonOffsetOpciones+2*(buttonYSeparator+tamYButton))
     .setSize(tamXButton,tamYButton);

  cp5.addButton("Atras")
     .setPosition(posXButton,posYButtonOffsetOpciones+3*(buttonYSeparator+tamYButton))
     .setSize(tamXButton,tamYButton);
  
}

void borraMenuPrincipal(){
  cp5.getController("Comenzar").remove();
  cp5.getController("Opciones").remove();
  cp5.getController("Salir").remove();
}

void dibujaMenuPausa(){
  cp5.addButton("Reanudar")
     .setPosition(posXButton,posYButtonOffset)
     .setSize(tamXButton,tamYButton);
  

  /*cp5.addButton("Opciones")
     .setPosition(posXButton,posYButtonOffset+buttonYSeparator+tamYButton)
     .setSize(tamXButton,tamYButton);
  */  
  cp5.addButton("Salir")
     .setPosition(posXButton,posYButtonOffset+1*(buttonYSeparator+tamYButton))
     .setSize(tamXButton,tamYButton);
}

void borraMenuPausa(){
  cp5.getController("Reanudar").remove();
  //cp5.getController("Opciones").remove();
  cp5.getController("Salir").remove();
}

void buttonParametersInitializers(){
  tamXButton = 300;
  posXButton = width/2-tamXButton/2;
  tamYButton = 50;
  posYButtonOffset = height/3;
  buttonYSeparator = 3*(tamYButton/4);
  myColor = color(0,150,0);
  cam = true;
}
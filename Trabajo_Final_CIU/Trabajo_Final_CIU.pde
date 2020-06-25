
void setup() {
  volumen = 50;
  victoria = new SoundFile(this, "victoria.wav");
  victoria.amp(volumen/100);
  tiempo_progressbar = -1;
  box2d = new Box2DProcessing(this);
  //size(1280, 960);
  size(640, 480);
  cp5 = new ControlP5(this);
  kinect = new Kinect(this);
  buttonParametersInitializers();
  arrayListInitizalizers();
  accountant = 0;
  iconPosition = new PVector(32, 32);
  iconSize = new PVector(32, 32);
  smooth();
  sonido = true;
  createBox2DWorld();

  estado = Estado.menuPrincipal;
  dibujaMenuPrincipal();
  bodies = new ArrayList<SkeletonData>();
  springRightHand = new Spring();
  springLeftHand = new Spring();

  camara = loadImage("camara.png");
  nocamara = loadImage("nocamara.png");
  altavoz = loadImage("altavoz.png");
  noaltavoz = loadImage("noaltavoz.png");
  pausa = loadImage("pausa.png");
  play = loadImage("play.png");
  sc = new SoundCipher(this);

  leftHandBox = new HandBox(width / 2, height / 2 - 50, 40, 40, BodyType.DYNAMIC);
  leftHandBox.teleport(box2d.coordPixelsToWorld(width / 2, height / 2 - 50));
  springLeftHand.bind(width / 2, height / 2 - 50, leftHandBox);

  rightHandBox = new HandBox(width / 2, height / 2 - 50, 20, 20, BodyType.DYNAMIC);
  rightHandBox.teleport(box2d.coordPixelsToWorld(width / 2, height / 2 - 50));
  springRightHand.bind(width / 2, height / 2 - 50, rightHandBox);

  leftHandBoxPosition = new PVector(leftHandBox.getBody().getPosition().x+10, leftHandBox.getBody().getPosition().y+10);
  rightHandBoxPosition = new PVector(rightHandBox.getBody().getPosition().x+10, rightHandBox.getBody().getPosition().y+10);
  d_progressbar = 30;
}

void compruebaFinDeJuego() {
  Object[] estadoFin = estadoFinal.toArray();
  Object[] ultimaTorre = torres[2].toArray();
  if (estadoFin.length == ultimaTorre.length) {
    estado = Estado.ganar;
    victoria.play();
  }
}

void draw() {
  background(200);
  if (cam)image(kinect.GetImage(), 0, 0, width, height);
  if (cp5.getController("Volumen") != null)
    volumen = cp5.getController("Volumen").getValue();
    
  for (int i=0; i<bodies.size (); i++)
    drawSkeleton(bodies.get(i));

  if (estado == Estado.juego) {
    if (cam)image(camara, iconPosition.x, iconPosition.y, iconSize.x, iconSize.y);
    else image(nocamara, iconPosition.x, iconPosition.y, iconSize.x, iconSize.y);
    if (sonido)image(altavoz, width-2*iconPosition.x, iconPosition.y, iconSize.x, iconSize.y);
    else image(noaltavoz, width-2*iconPosition.x, iconPosition.y, iconSize.x, iconSize.y);
    image(pausa, width/2 - iconSize.x/2, iconPosition.y, iconSize.x, iconSize.y);
    compruebaFinDeJuego();
    theDynamicMaker();
    theStaticMaker();
    accountant++;

    box2d.step();
    if (rightHandPos != null) {
      springRightHand.update(rightHandPos.x, rightHandPos.y);
    }

    if (leftHandPos != null) {
      springLeftHand.update(leftHandPos.x, leftHandPos.y);
    }

    rightHandBox.display();
    leftHandBox.display();

    displayBases(); //<>//
    displayGameObjects();

    if (boundingBoxAltavoz()) {
      soundprogress++;
      drawProgressBar(soundprogress, width-2*iconPosition.x, iconPosition.y);
      if (soundprogress > 140) {
        soundprogress = 0;
        tiempo_progressbar = -1;
        sonido = !sonido;
      }
    }else if(soundprogress > 0){
      soundprogress = 0;
    }

    if (boundingBoxCamara()) {
      camprogress++;
      drawProgressBar(camprogress, iconPosition.x, iconPosition.y);
      if (camprogress > 140) {
        camprogress = 0;
        tiempo_progressbar = -1;
        cam = !cam;
      }
    }else if(camprogress > 0){
      camprogress = 0;
    }

    if (boundingBoxPausa()) {
      pausaprogress++;
      drawProgressBar(pausaprogress, width/2 - iconSize.x/2, iconPosition.y);
      if (pausaprogress > 140) {
        pausaprogress = 0;
        tiempo_progressbar = -1;
        estado = Estado.pausa;
        dibujaMenuPausa();
      }
    }else if(pausaprogress > 0){
      pausaprogress = 0;
    }
    
  } else if (estado == Estado.ganar) {
    textAlign(CENTER);
    textSize(50);
    fill(10,210,30);
    ellipse( width/2 - 5, height/2-2*iconPosition.y + 63,50,50);
    fill(10,210,30);
    text("¡HAS GANADO!", width/2, height/2-2*iconPosition.y);
    image(play, width/2 - iconSize.x/2, height/2 - iconSize.y/2, iconSize.x, iconSize.y);
    
    box2d.step();
    if (rightHandPos != null) {
      springRightHand.update(rightHandPos.x, rightHandPos.y);
    }

    if (leftHandPos != null) {
      springLeftHand.update(leftHandPos.x, leftHandPos.y);
    }

    rightHandBox.display();
    leftHandBox.display();
    
    if (boundingBoxPlay()){
      playprogress++;
      drawProgressBar(playprogress,width/2- iconSize.x/2,height/2- iconSize.y/2);
      if (playprogress > 140) {
        playprogress = 0;
        tiempo_progressbar = -1;
        estado = Estado.menuPrincipal;
        for (Piece piece : pieceCollection){
          piece.killBody();
        }

        arrayListInitizalizers();
        dibujaMenuPrincipal();
      }
    }
    if(!pieceCollection.isEmpty()){
      for (Piece piece : pieceCollection){
        piece.killBody();
      }
      arrayListInitizalizers();
    }
  }
}

void drawProgressBar(float progress, float x, float y) {
  ellipseMode(CENTER);
  fill(#26221A);
  ellipse(x+iconSize.x/2, y+iconSize.y/2, d_progressbar, d_progressbar);
  fill(#1C2420);

  showArcs(progress, x+iconSize.x/2, y+iconSize.y/2);

  fill(255);
}

void showArcs(float progress, float x, float y) { 
  fill(#B77C08);   
  arc(x, y, d_progressbar, d_progressbar, PI+HALF_PI, map(progress, 0, 100, PI+HALF_PI, PI+HALF_PI+PI+HALF_PI));  

  noFill();
  arc(x, y, d_progressbar-20, d_progressbar-20, 0, TWO_PI);
}

void updateRightHandBoxsPositions() {
  if (rightHandPos != null) {
    x_progressbar = rightHandPos.x;
    y_progressbar = rightHandPos.y;
  }
}

void updateLeftHandBoxsPositions() {
  if (leftHandPos != null) {
    x_progressbar = leftHandPos.x;
    y_progressbar = leftHandPos.y;
  }
}

boolean boundingBoxAltavoz() {
  updateRightHandBoxsPositions();
  boolean rightHandX = x_progressbar > (width-2*iconPosition.x) && x_progressbar < (width-2*iconPosition.x)+iconSize.x;
  boolean rightHandY = (y_progressbar > iconPosition.y) && y_progressbar < (iconPosition.y + iconSize.y);
  return (rightHandX && rightHandY);

}

boolean boundingBoxCamara() {
  updateLeftHandBoxsPositions();
  boolean leftHandX = x_progressbar > iconPosition.x && x_progressbar < iconPosition.x+iconSize.x;
  boolean leftHandY = y_progressbar >iconPosition.y  && y_progressbar < iconPosition.y+iconSize.y;
  return (leftHandX && leftHandY);
}

boolean boundingBoxPausa() {
  updateLeftHandBoxsPositions();
  boolean leftHandX = x_progressbar > width/2 - iconSize.x/2 && x_progressbar < (width/2 - iconSize.x/2 +iconSize.x);
  boolean leftHandY = y_progressbar >iconPosition.y  && y_progressbar < iconPosition.y+iconSize.y;
  updateRightHandBoxsPositions();
  boolean rightHandX = x_progressbar > width/2 - iconSize.x/2 && x_progressbar < (width/2 - iconSize.x/2 +iconSize.x);
  boolean rightHandY = (y_progressbar > iconPosition.y) && y_progressbar < (iconPosition.y + iconSize.y);
  return ((leftHandX && leftHandY) || (rightHandX && rightHandY));
}

boolean boundingBoxPlay(){
  updateLeftHandBoxsPositions();
  boolean leftHandX = x_progressbar > width/2 - iconSize.x/2 && x_progressbar < (width/2 - iconSize.x/2 +iconSize.x);
  boolean leftHandY = y_progressbar > height/2 - iconSize.y/2 && y_progressbar < (height/2 - iconSize.y/2 +iconSize.y);
  updateRightHandBoxsPositions();
  boolean rightHandX = x_progressbar > width/2 - iconSize.x/2 && x_progressbar < (width/2 - iconSize.x/2 +iconSize.x);
  boolean rightHandY = y_progressbar > height/2 - iconSize.y/2 && y_progressbar < (height/2 - iconSize.y/2 +iconSize.y);
  return ((leftHandX && leftHandY) || (rightHandX && rightHandY));
}

void keyPressed() {
  if (key == ' ' && estado == Estado.juego) {
    estado = Estado.pausa;
    dibujaMenuPausa();
  }
}

void mouseClicked() {
  if (estado == Estado.ganar) {
    estado = Estado.menuPrincipal;
    for (Piece piece : pieceCollection) {
      piece.killBody();
    }
    arrayListInitizalizers();
    dibujaMenuPrincipal();
  }
}


void setup() {
  volumen = 64;
  box2d = new Box2DProcessing(this);
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
  createBox2DWorld(box2d);

  estado = Estado.menuPrincipal;
  dibujaMenuPrincipal();
  bodies = new ArrayList<SkeletonData>();
  springRightHand = new Spring();
  springLeftHand = new Spring();

  camara = loadImage("camara.png");
  nocamara = loadImage("nocamara.png");
  altavoz = loadImage("altavoz.png");
  noaltavoz = loadImage("noaltavoz.png");
  sc = new SoundCipher(this);

  leftHandBox = new HandBox(width / 2, height / 2 - 50, 20, 20, BodyType.DYNAMIC);
  leftHandBox.teleport(box2d.coordPixelsToWorld(width / 2, height / 2 - 50));
  springLeftHand.bind(width / 2, height / 2 - 50, leftHandBox);

  rightHandBox = new HandBox(width / 2, height / 2 - 50, 20, 20, BodyType.DYNAMIC);
  rightHandBox.teleport(box2d.coordPixelsToWorld(width / 2, height / 2 - 50));
  springRightHand.bind(width / 2, height / 2 - 50, rightHandBox);
}

void draw() {
  background(255);
  if (cam)image(kinect.GetImage(), 0, 0, width, height);
  if (cp5.getController("Volumen") != null)
  volumen = cp5.getController("Volumen").getValue()*127/100;
  for (int i=0; i<bodies.size (); i++)
    drawSkeleton(bodies.get(i));

  if (estado == Estado.juego) {
    if (cam)image(camara, iconPosition.x, iconPosition.y, iconSize.x, iconSize.y);
    else image(nocamara, iconPosition.x, iconPosition.y, iconSize.x, iconSize.y);
    if (sonido)image(altavoz, width-2*iconPosition.x, iconPosition.y, iconSize.x, iconSize.y);
    else image(noaltavoz, width-2*iconPosition.x, iconPosition.y, iconSize.x, iconSize.y);
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

    displayBases();
    rightHandBox.display();
    leftHandBox.display();
    displayGameObjects();
  }
}

void createPieces(int nPieces) {
  for (int i = 0; i < nPieces; i++) {
    PieceDTO pieceDTO = fillPieceDTO(nPieces, i);
    Piece newPiece = new Piece(pieceDTO.x, pieceDTO.y, pieceDTO.w, pieceDTO.h, pieceDTO.id, pieceDTO.bodyType, pieceDTO.tone);
    pieceCollection.add(newPiece);
  }
}

void mouseClicked() {
  if (boundingBoxAltavoz()) {
    sonido = !sonido;
  }
  if (boundingBoxCamara()) {
    cam = !cam;
  }
}

boolean boundingBoxAltavoz() {
  if (mouseX > (width-2*iconPosition.x) && mouseX < (width-2*iconPosition.x)+iconSize.x) {
    if ((mouseY > iconPosition.y) && mouseY < (iconPosition.y + iconSize.y)) {
      return true;
    }
  }
  return false;
}

boolean boundingBoxCamara() {
  if (mouseX > iconPosition.x && mouseX < iconPosition.x+iconSize.x) {
    if (mouseY >iconPosition.y  && mouseY < iconPosition.y+iconSize.y) {
      return true;
    }
  }
  return false;
}

void beginContact(Contact con) {
  Fixture f1 = con.getFixtureA();
  Fixture f2 = con.getFixtureB();

  Body b1 = f1.getBody();
  Body b2 = f2.getBody();

  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();


  if (o1 == null ||o2 == null || o1.getClass() == HandBox.class || o2.getClass() == HandBox.class) { 
    if (sonido) {
      sc.playNote(5, max(volumen - 10,1.0), 0.1);
    } 
    return;
  }; 


  if (o1.getClass() == Piece.class &&
    o2.getClass() == Piece.class) {
    Piece p1 = (Piece)o1;
    Piece p2 = (Piece)o2;
    if (freeId != -1 && sonido) sc.playNote((10 + p1.getId())*5, volumen, 0.2);
    if (p1.getBody().getPosition().y > p2.getBody().getPosition().y  && freeId == p1.getId() && -1 != towerHead(p2.getId()) && p1.getId() > p2.getId() ) {

      println(p1.getId() + " toca a " + p2.getId() );
      int tower = towerHead(p2.getId());

      torres[tower].push(p1.getId());
      freeId = -1;
      towerHeadsDynamic();
    } else if (freeId == p2.getId() && -1 != towerHead(p1.getId()) && p2.getId() > p1.getId() ) {

      println(p2.getId() + " toca a " + p1.getId() );
      int tower = towerHead(p1.getId());
      torres[tower].push(p2.getId());
      freeId = -1;

      towerHeadsDynamic();
    }
  } else if (o1.getClass() == Box.class || o2.getClass() == Box.class ) {
    Box b;
    Piece p;
    if (o1.getClass() == Box.class) {
      b = (Box)o1;
      p = (Piece)o2;
    } else {
      b = (Box)o2;
      p = (Piece)o1;
    }
    if (freeId != -1 && sonido) sc.playNote((10 + p.getId())*6, max(volumen-5,2), 0.2);
    if (freeId == p.getId() && torres[b.getId()].isEmpty() && sonido) {
      sc.playNote((10 + p.getId())*5, volumen, 0.2);
      println(p.getId() + " toca un bloque " );

      torres[b.getId()].push(p.getId());
      freeId = -1;
      towerHeadsDynamic();
    }
  } else if (sonido) {
    sc.playNote((10), max(volumen-10,1), 0.2);
  };

  print("freeId = " + freeId + ";  towers = ");
  for (int i = 0; i < torres.length; i++) {
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

    if (tower != -1 && freeId == -1 && p1.getBodyType() != BodyType.STATIC ) {
      println( p1.getId() + " se separa de " + p2.getId());
      int id = p1.getId() ;
      freeId = id;

      torres[tower].pop();
      if (torres[tower].peek() == p2.getId()) {
        freeId = id;
        allStaticExcept(new int[] {id});
      } else
        torres[tower].push(id);
      return;
    }
    tower = towerHead(p2.getId());
    if (tower != -1 && freeId == -1 && p2.getBodyType() != BodyType.STATIC) {
      println( p2.getId() + " se separa de " + p1.getId());
      int id = p2.getId() ;

      torres[tower].pop();
      if (torres[tower].peek() == p1.getId()) {
        freeId = id;
        allStaticExcept(new int[] {id});
      } else
        torres[tower].push(id);
      return;
    }
  } else if (o1.getClass() == Box.class || o2.getClass() == Box.class ) {
    Box b;
    Piece p;
    if (o1.getClass() == Box.class) {
      b = (Box)o1;
      p = (Piece)o2;
    } else {
      b = (Box)o2;
      p = (Piece)o1;
    }

    if (-1 != towerHead(p.getId()) && freeId == -1 && p.getBodyType() != BodyType.STATIC) {
      println( p.getId() + " se separa de un bloque" );
      int id = p.getId();
      freeId = id;
      if (!torres[towerHead(p.getId())].isEmpty())torres[towerHead(p.getId())].pop();
      allStaticExcept(new int[] {id});
    }
  }
  print("freeId = " + freeId + ";  towers = ");
  for (int i = 0; i < torres.length; i++) {
    println(torres[i]);
  }
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

void makeArrayDynamic(int[] toDynamic) {
  for (int n : toDynamic) {

    if (n != -1 && !dynamicCola.contains(n) ) {

      dynamicCola.add(n);
    }
  }
}

void keyPressed() {
  if (key == ' ') {
    if (estado == Estado.juego) {
      estado = Estado.pausa;
      dibujaMenuPausa();
    } else {
      estado = Estado.juego;
      borraMenuPausa();
    }
  }
}

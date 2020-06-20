void theStaticMaker() {
  if (staticCola.size() > 0) {
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
  if (dynamicCola.size() > 0) { 
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

void allStaticExcept(int[] nonStaticId) {
  for (Piece p : pieceCollection) {
    if (contains(nonStaticId, p.getId()) == -1 && !staticCola.contains(p.getId()) ) {
      staticCola.add(p.getId());
    }
  }
}

void towerHeadsDynamic() {
  for (ArrayDeque<Integer> n : torres) {
    if (!n.isEmpty() && !dynamicCola.contains(n.peek()) ) {
      dynamicCola.add(n.peek());
    }
  }
}

int contains(int[] array, int v) {
  int cont = 0;
  int result = -1;

  for (int i : array) {
    if (i == v) {
      result = cont;
      break;
    }
    cont++;
  }

  return result;
}

int towerHead(int v) {
  int cont = 0;
  int result = -1;

  for (ArrayDeque<Integer> i : torres) {
    if (!i.isEmpty() && i.peek() == v) {
      result = cont;
      break;
    }
    cont++;
  }

  return result;
}

void arrayListInitizalizers() {
  staticMaker = new ArrayList<Integer>();
  dynamicMaker = new ArrayList<Integer>();
  staticCola = new ArrayList<Integer>();
  dynamicCola = new ArrayList<Integer>();
  pieceCollection = new ArrayList<Piece>();
  boxes = new ArrayList<Box>();
  boundaries = new ArrayList();
}

void createBox2DWorld() {
  box2d.createWorld();
  box2d.setGravity(0, -10);
  box2d.listenForCollisions();
}

void createBases() {
  leftBase = new Box(width/6, height - height/5, width/4, height/30, BodyType.STATIC, 0);
  centerBase = new Box(width/6 * 3, height - height/5, width/4, height/30, BodyType.STATIC, 1);
  rightBase = new Box(width/6 * 5, height - height/5, width/4, height/30, BodyType.STATIC, 2);
}

void createPieces(int nPieces) {
  for (int i = 0; i < nPieces; i++) {
    PieceDTO pieceDTO = fillPieceDTO(nPieces, i);
    Piece newPiece = new Piece(pieceDTO.x, pieceDTO.y, pieceDTO.w, pieceDTO.h, pieceDTO.id, pieceDTO.bodyType, pieceDTO.tone);
    pieceCollection.add(newPiece);
  }
}

void initilizePiecesLogic() {
  freeId = -1;
  towerLastId = new int[3];
  towerLastId[0]= numberOfPieces -1; 
  towerLastId[1]=-1; 
  towerLastId[2]=-1;
}

void createGameField() {
  createBoundaries();
  createPieces(numberOfPieces);
}

void displayBases() {
  leftBase.display();
  centerBase.display();
  rightBase.display();
}

void createBoundaries() {
  boundaries.add(new Boundary(width/2, (height - height/5) + 30, width, 10, 0));
  boundaries.add(new Boundary(width/2, 5, width, 10, 0));
  boundaries.add(new Boundary(width-5, height/2, 10, height, 0));
  boundaries.add(new Boundary(5, height/2, 10, height, 0));
}

void displayGameObjects() {
  for (Piece p : pieceCollection) p.display();
}

PieceDTO fillPieceDTO(int nPieces, int index) {
  HashMap<String, Float> pieceParameters = getPieceParameters(nPieces);
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

HashMap getPieceParameters(int nPieces) {
  HashMap<String, Float> map = new HashMap<String, Float>();
  map.put("maxWidth", width/6.0);
  map.put("firstHeight", height - height/5.0);
  map.put("pieceHeight", (height/5.0)/nPieces);
  return map;
}

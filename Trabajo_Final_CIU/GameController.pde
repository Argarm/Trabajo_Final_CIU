
void beginContact(Contact con) {
  Fixture f1 = con.getFixtureA();
  Fixture f2 = con.getFixtureB();

  Body b1 = f1.getBody();
  Body b2 = f2.getBody();

  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();


  if (o1 == null ||o2 == null || o1.getClass() == HandBox.class || o2.getClass() == HandBox.class) { 
    if (sonido) {
      sc.playNote(5, max(volumen - 10, 1.0), 0.1);
    } 
    return;
  }; 


  if (o1.getClass() == Piece.class &&
    o2.getClass() == Piece.class) {
    Piece p1 = (Piece)o1;
    Piece p2 = (Piece)o2;
    if (freeId != -1 && sonido) sc.playNote((10 + p1.getId())*5, volumen, 0.2);
    //if (p1.getBody().getPosition().y > p2.getBody().getPosition().y  && freeId == p1.getId() && -1 != towerHead(p2.getId()) && p1.getId() > p2.getId() ) {
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
    if (freeId != -1 && sonido) sc.playNote((10 + p.getId())*6, max(volumen-5, 2), 0.2);
    if (freeId == p.getId() && torres[b.getId()].isEmpty()) {
      //if (p.getBody().getPosition().x > b.getBody().getPosition().x && (p.getBody().getPosition().x + p.getWeight()) < (b.getBody().getPosition().x + b.getWeight())) {
        //if(sonido) sc.playNote((10 + p.getId())*5, volumen, 0.2);
        println(p.getId() + " toca un bloque " );

        torres[b.getId()].push(p.getId());
        freeId = -1;
        towerHeadsDynamic();
      //}
    }
  } else if (sonido) {
    sc.playNote((10), max(volumen-10, 1), 0.2);
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

    if (tower != -1 && freeId == -1 && p1.getBodyType() != BodyType.STATIC && (torres[tower].contains(p1.getId()) & torres[tower].contains(p2.getId()))) {
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
    if (tower != -1 && freeId == -1 && p2.getBodyType() != BodyType.STATIC && (torres[tower].contains(p1.getId()) & torres[tower].contains(p2.getId()))) {
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

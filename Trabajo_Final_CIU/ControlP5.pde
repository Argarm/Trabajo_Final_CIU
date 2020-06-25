public void Comenzar() {
  borraMenuPrincipal();
  createBases();
  createGameField();
  initilizePiecesLogic();
  torres = new ArrayDeque[3];
  torres[0] = new ArrayDeque<Integer>();
  torres[1] = new ArrayDeque<Integer>();
  torres[2] = new ArrayDeque<Integer>();
  for (int i = 0; i < numberOfPieces - 1; i++) {
    staticMaker.add(i);
    torres[0].push(i);
  }
  torres[0].push(numberOfPieces - 1);
  estadoFinal = torres[0].clone();
  estado = Estado.juego;
}

public void Opciones() {
  dibujaMenuOpciones();
}

public void Salir() {
  delay(1000);
  exit();
}

public void Sonido() {
  int slidderX = round(posXButton + 1.1*tamXButton);
  int slidderY = height/4;
  int sliderWidth = 30;
  int sliderHeight = 200;
  if (cp5.getController("Volumen") != null)cp5.getController("Volumen").remove();
  else cp5.addSlider("Volumen", 0, 100, volumen, slidderX, slidderY, sliderWidth, sliderHeight).setFont(p5Font);
  victoria.amp(volumen/100);
}

public void Dificultad() {
  dificultad = dificultad == 2 ? 0 : dificultad + 1;
  switch(dificultad) {
  case 0:
    numberOfPieces = 3;
    cp5.getController("Dificultad").setLabel("Dificultad - Facil");
    break;
  case 1:
    numberOfPieces = 4;
    cp5.getController("Dificultad").setLabel("Dificultad - Media");
    break;
  case 2:
    numberOfPieces = 6;
    cp5.getController("Dificultad").setLabel("Dificultad - Dificil");
    break;
  }
}

public void Camara() {
  cam = !cam;
  if (cam) {
    myColor = color(0, 150, 0);
    cp5.getController("Camara")
      .setColorBackground(myColor);
  } else {
    myColor = color(150, 0, 0);
    cp5.getController("Camara")
      .setColorBackground(myColor);
  }
}

public void Atras() {
  dibujaMenuPrincipal();
}

public void Reanudar() {
  borraMenuPausa();
  estado = Estado.juego;
}

public void Inicio(){
  borraMenuPausa();
  estado = Estado.menuPrincipal;
  for (Piece piece : pieceCollection){
    piece.killBody();
  }
  arrayListInitizalizers();
  dibujaMenuPrincipal();
}

void dibujaMenuPrincipal() {
  if (estado == Estado.menuOpciones) {
    borraMenuOpciones();
    estado = Estado.menuPrincipal;
  }
  cp5.addButton("Comenzar")
    .setPosition(posXButton, posYButtonOffset)
    .setSize(tamXButton, tamYButton)
    .setFont(p5Font);

  cp5.addButton("Opciones")
    .setPosition(posXButton, posYButtonOffset+buttonYSeparator+tamYButton)
    .setSize(tamXButton, tamYButton)
    .setFont(p5Font);

  cp5.addButton("Salir")
    .setPosition(posXButton, posYButtonOffset+2*(buttonYSeparator+tamYButton))
    .setSize(tamXButton, tamYButton)
    .setFont(p5Font);
}

void borraMenuOpciones() {
  cp5.getController("Sonido").remove();
  cp5.getController("Dificultad").remove();
  cp5.getController("Camara").remove();
  cp5.getController("Atras").remove();
  if (cp5.getController("Volumen") != null) cp5.getController("Volumen").remove();
}

void dibujaMenuOpciones() {
  if (estado == Estado.menuPrincipal) {
    borraMenuPrincipal();
    estado = Estado.menuOpciones;
  }
  if (estado == Estado.pausa) {
    borraMenuPausa();
  }
  int posYButtonOffsetOpciones = height/4;
  cp5.addButton("Sonido")
    .setPosition(posXButton, posYButtonOffsetOpciones)
    .setSize(tamXButton, tamYButton)
    .setFont(p5Font);
  String message ="";
  switch (numberOfPieces){
    case(3): message = "Dificultad - Facil"; break;
    case(4): message = "Dificultad - Media"; break;
    case(6): message = "Dificultad - Dificil"; break;
  }
  cp5.addButton("Dificultad")
    .setLabel(message)
    .setPosition(posXButton, posYButtonOffsetOpciones+buttonYSeparator+tamYButton)
    .setSize(tamXButton, tamYButton)
    .setFont(p5Font);   
  if(cam){
    myColor = color(0, 150, 0); 
  }else{
    myColor = color(150,0, 0);
  }
  cp5.addButton("Camara").setColorBackground(myColor)
    .setPosition(posXButton, posYButtonOffsetOpciones+2*(buttonYSeparator+tamYButton))
    .setSize(tamXButton, tamYButton)
    .setFont(p5Font);

  cp5.addButton("Atras")
    .setPosition(posXButton, posYButtonOffsetOpciones+3*(buttonYSeparator+tamYButton))
    .setSize(tamXButton, tamYButton)
    .setFont(p5Font);
}

void borraMenuPrincipal() {
  cp5.getController("Comenzar").remove();
  cp5.getController("Opciones").remove();
  cp5.getController("Salir").remove();
}

void dibujaMenuPausa() {
  cp5.addButton("Reanudar")
    .setPosition(posXButton, posYButtonOffset)
    .setSize(tamXButton, tamYButton)
    .setFont(p5Font);
  cp5.addButton("Inicio")
    .setPosition(posXButton, posYButtonOffset+1*(buttonYSeparator+tamYButton))
    .setSize(tamXButton, tamYButton)
    .setFont(p5Font);
  cp5.addButton("Salir")
    .setPosition(posXButton, posYButtonOffset+2*(buttonYSeparator+tamYButton))
    .setSize(tamXButton, tamYButton)
    .setFont(p5Font);
}

void borraMenuPausa() {
  cp5.getController("Reanudar").remove();
  cp5.getController("Inicio").remove();
  cp5.getController("Salir").remove();
}

void buttonParametersInitializers() {
  tamXButton = 300;
  posXButton = width/2-tamXButton/2;
  tamYButton = 50;
  posYButtonOffset = height/3;
  buttonYSeparator = 3*(tamYButton/4);
  myColor = color(0, 150, 0);
  cam = true;
  p5Font = new ControlFont(createFont("Arial",25));
}

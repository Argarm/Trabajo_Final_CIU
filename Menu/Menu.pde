import controlP5.*;
ControlP5 cp5;

Estado estado;
int myColor = color(230);

enum Estado{
  menuPrincipal,
  menuOpciones
}

void setup() {
  size(400,600);
  noStroke();
  cp5 = new ControlP5(this);
  estado = Estado.menuPrincipal;
  dibujaMenuPrincipal();
}

void draw() {
  background(myColor);
}

public void Comenzar() {
  myColor = color(255,0,0);
}


public void Opciones() {
  myColor = color(0,255,0);
  dibujaMenuOpciones();
}


public void Salir() {
  delay(1000);
  exit();
}

public void Sonido(){

}
public void Dificultad(){

}
public void Camara(){

}
public void Atras(){
  dibujaMenuPrincipal();

}

void dibujaMenuPrincipal(){
  if(estado == Estado.menuOpciones){
    borraMenuOpciones();
    estado = Estado.menuPrincipal;
  }
  cp5.addButton("Comenzar")
     .setPosition(100,100)
     .setSize(200,19);
  

  cp5.addButton("Opciones")
     .setPosition(100,120)
     .setSize(200,19);
     
  cp5.addButton("Salir")
     .setPosition(100,140)
     .setSize(200,19);

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
  cp5.addButton("Sonido")
     .setPosition(100,100)
     .setSize(200,19);
  

  cp5.addButton("Dificultad")
     .setPosition(100,120)
     .setSize(200,19);
     
  cp5.addButton("Camara")
     .setPosition(100,140)
     .setSize(200,19);

  cp5.addButton("Atras")
     .setPosition(width/2-100,160)
     .setSize(200,19);
  
}

void borraMenuPrincipal(){
  cp5.getController("Comenzar").remove();
  cp5.getController("Opciones").remove();
  cp5.getController("Salir").remove();
}


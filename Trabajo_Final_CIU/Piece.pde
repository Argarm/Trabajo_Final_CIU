// A rectangular box
class Piece {
  //  Instead of any of the usual variables, we will store a reference to a Box2D Body
  Body body;
  color col;
  float w,h;
  int id;

  Piece(float x, float y,float ancho,float alto, int newId , BodyType b, color paint) {
    id = newId;
    w = ancho;
    h = alto;
    col = paint;
    // Build Body
    BodyDef bd = new BodyDef();
    bd.type = b;
    bd.position.set(box2d.coordPixelsToWorld(x,y));
    body = box2d.createBody(bd);
    body.setUserData(this);

   // Define a polygon (this is what we use for a rectangle)
    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);  // Box2D considers the width and height of a
    sd.setAsBox(box2dW, box2dH);            // rectangle to be the distance from the
                           // center to the edge (so half of what we
                          // normally think of as width or height.) 
    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = sd;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0.3;
    fd.restitution = 0.5;

    // Attach Fixture to Body               
    body.createFixture(fd);
  }
  void makeStatic(){
    if (body.getType()!= BodyType.STATIC){
      try{
        body.setType(BodyType.STATIC);  
        body.setAwake(true);
      }catch (AssertionError e){
        System.out.println(e);
      }
    }
  }
  
  void makeDynamic(){
    if (body.getType()!= BodyType.DYNAMIC){
      try{
        body.setType(BodyType.DYNAMIC);  
        body.setAwake(true);
      }catch (AssertionError e){
        System.out.println(e);
      }
    }
  }
  void display() {
    // We need the Body’s location and angle
    Vec2 pos = box2d.getBodyPixelCoord(body);    
    float a = body.getAngle();
    
    pushMatrix();
    translate(pos.x,pos.y);    // Using the Vec2 position and float angle to
    rotate(-a);              // translate and rotate the rectangle
    //fill(175);
    fill(col);
    stroke(0);
    rectMode(CENTER);
    rect(0,0,w,h);
    popMatrix();
  }
  int getId(){
    return id;
  }
  
  
  boolean pieceIsAbove(Piece up, Piece down){
    
    return false;
  }
  
  BodyType getBodyType(){
    return body.getType();
  }
  
  Body getBody(){
    return body;
  }
  

}
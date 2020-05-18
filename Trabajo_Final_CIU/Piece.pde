class Piece {

  Body body;
  color tone;
  float w,h;
  int id;

  Piece(float x, float y,float w,float h, int newId , BodyType bodyType, color tone) {
    
    this.w = w;
    this.h = h;
    this.tone = tone;
    id = newId;
    
    BodyDef bd = ShapeUtils.createBodyDefinition(x,y,bodyType);
    
    body = box2d.createBody(bd);
    body.setUserData(this);

    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);  // Box2D considers the width and height of a
    sd.setAsBox(box2dW, box2dH);            // rectangle to be the distance from the
                           // center to the edge (so half of what we
                          // normally think of as width or height.) 
    FixtureDef fd = new FixtureDef();
    fd.shape = sd;
    fd.density = 1;
    fd.friction = 0.3;
    fd.restitution = 0.5;

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
    fill(tone);
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

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
    PolygonShape polygonShape = ShapeUtils.definePolygonAsBox(w,h);
    BodyDef bodyDefinition = ShapeUtils.createBodyDefinition(x,y,bodyType);
    FixtureDef fixture = ShapeUtils.fixtureDefinition(polygonShape);
    body = ShapeUtils.createBody(bodyDefinition,fixture,this);
  }
  
  void makeStatic(){
    if (body.getType()!= BodyType.STATIC){
      try{
        body.setType(BodyType.STATIC);  
        body.setAwake(true);
      }catch (AssertionError e){
        System.err.println(e);
      }
    }
  }
  
  void makeDynamic(){
    if (body.getType()!= BodyType.DYNAMIC){
      try{
        body.setType(BodyType.DYNAMIC);  
        body.setAwake(true);
      }catch (AssertionError e){
        System.err.println(e);
      }
    }
  }
  
  void display() {
    Vec2 pos = box2d.getBodyPixelCoord(body);    
    float a = body.getAngle();    
    pushMatrix();
    translate(pos.x,pos.y);    
    rotate(-a);                 
    fill(tone);
    stroke(0);
    rectMode(CENTER);
    rect(0,0,w,h,7);
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

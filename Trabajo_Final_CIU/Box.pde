class Box {
  Body body;      

  float w,h;
  int id;

  Box(float x, float y,float w,float h, BodyType bodyType, int newId) {
    this.w = w;
    this.h = h;
    this.id = newId;
    
    PolygonShape polygonShape = ShapeUtils.definePolygonAsBox(w, h);
    FixtureDef fixture  = ShapeUtils.fixtureDefinition(polygonShape);

    BodyDef bodyDefinition = ShapeUtils.createBodyDefinition(x, y, bodyType);

    body = ShapeUtils.createBody(bodyDefinition, fixture, this);

  }

  int getId(){
    return id;
  }
  
  void display() {
    
    Vec2 pos = box2d.getBodyPixelCoord(body);		
    float a = body.getAngle();

    pushMatrix();
    translate(pos.x,pos.y);		
    rotate(-a);			        
    fill(175);
    stroke(0);
    rectMode(CENTER);
    rect(0,0,w,h);
    popMatrix();
  }
  
  void killBody() {
    box2d.destroyBody(body);
  }

  Body getBody(){
    return body;
  }

  float getWeight(){
    return w;
  }

  
  void teleport(Vec2 nPos){
    body.setTransform(nPos,body.getAngle());
  }
}

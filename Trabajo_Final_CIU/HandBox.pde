class HandBox {

  Body body;      
  float w,h;

  HandBox(float x, float y,float w,float h, BodyType b) {
    this.w = w;
    this.h = h;
    PolygonShape polygonShape = ShapeUtils.definePolygonAsBox(w,h);  
    BodyDef bodyDefinition = ShapeUtils.createBodyDefinition(x,y,b);
    FixtureDef fixture = ShapeUtils.fixtureDefinition(polygonShape);
    body = ShapeUtils.createBody(bodyDefinition,fixture,this);    
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
  
  void updatePosition(int mousex, int mousey){
    Vec2 speed = box2d.coordPixelsToWorld(mousex,mousey).sub(body.getPosition());
    speed = new Vec2(speed.x * 80,speed.y*80);  
    body.setLinearVelocity(speed);
  }
  
  void teleport(Vec2 nPos){
    body.setTransform(nPos,body.getAngle());  
  }
}

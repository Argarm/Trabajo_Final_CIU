// A rectangular box
class HandBox {
  //  Instead of any of the usual variables, we will store a reference to a Box2D Body
  Body body;      

  float w,h;

  HandBox(float x, float y,float ancho,float alto, BodyType b) {
    w = ancho;
    h = alto;

    PolygonShape polygonShape = ShapeUtils.definePolygonAsBox(w,h);
    
    BodyDef bodyDefinition = ShapeUtils.createBodyDefinition(x,y,b);

    FixtureDef fixture = ShapeUtils.defineFixture(polygonShape);

    body = ShapeUtils.createBody(bodyDefinition,fixture,this);
    
  }

  void display() {
    // We need the Body’s location and angle
    Vec2 pos = box2d.getBodyPixelCoord(body);    
    float a = body.getAngle();

    pushMatrix();
    translate(pos.x,pos.y);    // Using the Vec2 position and float angle to
    rotate(-a);              // translate and rotate the rectangle
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
    //System.out.println(body.getPosition());
  }

}

// A rectangular box
class HandBox {
  //  Instead of any of the usual variables, we will store a reference to a Box2D Body
  Body body;      

  float w,h;

  HandBox(float x, float y,float ancho,float alto, BodyType b) {
    w = ancho;
    h = alto;

    // Build Body
    BodyDef bd = new BodyDef();
    bd.type = b;
    bd.position.set(box2d.coordPixelsToWorld(x,y));
    body = box2d.createBody(bd);
  body.setUserData(this);

   // Define a polygon (this is what we use for a rectangle)
   
    PolygonShape polygonShape = ShapeUtils.definePolygonAsBox(w,h);
    
    // Define a fixture
    
    FixtureDef fixture = ShapeUtils.defineFixture(polygonShape);

    // Attach Fixture to Body               
    body.createFixture(fixture);
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

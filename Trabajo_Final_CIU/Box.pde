
class Box {
  Body body;      

  float w,h;
  int id;

  Box(float x, float y,float ancho,float alto, BodyType b, int newId) {
    this.w = ancho;
    this.h = alto;
    this.id = newId;
    
    PolygonShape polygonShape = ShapeUtils.definePolygonAsBox(w, h);
    FixtureDef fixture  = ShapeUtils.fixtureDefinition(polygonShape);

    BodyDef bodyDefinition = ShapeUtils.createBodyDefinition(x, y, b);

    body = ShapeUtils.createBody(bodyDefinition, fixture, this);

  }

  int getId(){
    return id;
  }
  void display() {
    // We need the Body’s location and angle
    Vec2 pos = box2d.getBodyPixelCoord(body);		
    float a = body.getAngle();

    pushMatrix();
    translate(pos.x,pos.y);		// Using the Vec2 position and float angle to
    rotate(-a);			        // translate and rotate the rectangle
    fill(175);
    stroke(0);
    rectMode(CENTER);
    rect(0,0,w,h);
    popMatrix();
  }
  
  void killBody() {
    box2d.destroyBody(body);
  }
  
  void teleport(Vec2 nPos){
    body.setTransform(nPos,body.getAngle());
    System.out.println(body.getPosition());
  }
}

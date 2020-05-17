class Boundary {
  float x, y, w, h;
  Body b;

 Boundary(float x,float y, float w, float h, float angle) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;

    
    PolygonShape polygonShape = definePolygonAsBox();

    BodyDef bodyDefinition = createBodyDefinition(angle);
    createBody(bodyDefinition, polygonShape);
  }
  
  private BodyDef createBodyDefinition(float angle){
    BodyDef bodyDefinition = new BodyDef();

    bodyDefinition.type = BodyType.STATIC;
    bodyDefinition.angle = angle;
    bodyDefinition.position.set(box2d.coordPixelsToWorld(x,y));
    
    return bodyDefinition;
  }

  private void createBody(BodyDef bodyDefinition, PolygonShape polygonShape){
    b = box2d.createBody(bodyDefinition);
    b.createFixture(polygonShape, 1);
    
    b.setUserData(this);
  }

  private PolygonShape definePolygonAsBox(){
    PolygonShape polygonShape = new PolygonShape();

    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);
    polygonShape.setAsBox(box2dW, box2dH);
    return polygonShape;
  }
  // Draw the boundary, if it were at an angle we'd have to do something fancier
  void display() {
    noFill();
    stroke(0);
    strokeWeight(1);
    rectMode(CENTER);

    float a = b.getAngle();

    pushMatrix();
    translate(x,y);
    rotate(-a);
    rect(0,0,w,h);
    popMatrix();
  }

}

class Boundary {
  float x, y, w, h;
  Body body;

  Boundary(float x,float y, float w, float h, float angle) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;

    
    PolygonShape polygonShape = definePolygonAsBox();

    BodyDef bodyDefinition = ShapeUtils.createBodyDefinition(x,y,angle);
    body = ShapeUtils.createBody(bodyDefinition, polygonShape, this);
  }


  private PolygonShape definePolygonAsBox(){
    PolygonShape polygonShape = new PolygonShape();

    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);
    polygonShape.setAsBox(box2dW, box2dH);
    return polygonShape;
  }
  
  void display() {

    setConfiguration();
    float angle = body.getAngle();

    pushMatrix();
    translate(x,y);
    rotate(-angle);
    rect(0,0,w,h);
    popMatrix();
  }

  private void setConfiguration(){
    noFill();
    stroke(0);
    strokeWeight(1);
    rectMode(CENTER);
  }
}

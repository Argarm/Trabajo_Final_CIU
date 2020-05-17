static class ShapeUtils {
    
    public static BodyDef createBodyDefinition (float x, float y, float angle) {
        BodyDef bodyDefinition = new BodyDef();

        bodyDefinition.type = BodyType.STATIC;
        bodyDefinition.angle = angle;
        bodyDefinition.position.set(box2d.coordPixelsToWorld(x,y));
        
        return bodyDefinition;
    }

    private static Body createBody(BodyDef bodyDefinition, PolygonShape polygonShape, Object self){
        Body body = box2d.createBody(bodyDefinition);
        body.createFixture(polygonShape, 1);
        
        body.setUserData(self);

        return body;
    }

    private static PolygonShape definePolygonAsBox(float width, float height){
        PolygonShape polygonShape = new PolygonShape();

        float box2dW = box2d.scalarPixelsToWorld(width/2);
        float box2dH = box2d.scalarPixelsToWorld(height/2);
        polygonShape.setAsBox(box2dW, box2dH);
        return polygonShape;
  }

}

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

}

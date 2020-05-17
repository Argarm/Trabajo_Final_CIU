static class ShapeUtils {
    
    public static BodyDef createBodyDefinition (float x, float y, float angle) {
        BodyDef bodyDefinition = new BodyDef();

        bodyDefinition.type = BodyType.STATIC;
        bodyDefinition.angle = angle;
        bodyDefinition.position.set(box2d.coordPixelsToWorld(x,y));
        
        return bodyDefinition;
    }

}

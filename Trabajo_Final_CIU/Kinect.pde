void drawSkeleton(SkeletonData _s) {
  leftHandPos = DrawBone(_s, 
    Kinect.NUI_SKELETON_POSITION_WRIST_LEFT, 
    Kinect.NUI_SKELETON_POSITION_HAND_LEFT);

  rightHandPos = DrawBone(_s, 
    Kinect.NUI_SKELETON_POSITION_WRIST_RIGHT, 
    Kinect.NUI_SKELETON_POSITION_HAND_RIGHT);
}

Point DrawBone(SkeletonData _s, int _j1, int _j2) {
  Point result = null;

  pushStyle();
  fill(255, 255, 0);
  stroke(255, 255, 0);
  if (_s.skeletonPositionTrackingState[_j1] != Kinect.NUI_SKELETON_POSITION_NOT_TRACKED &&
    _s.skeletonPositionTrackingState[_j2] != Kinect.NUI_SKELETON_POSITION_NOT_TRACKED) {

    result = getRectangle(_s, _j1, _j2);
  }
  popStyle();
  return result;
}

Point getRectangle(SkeletonData _s, int _j1, int _j2) {

  float x, y, w, h;
  float wristX = _s.skeletonPositions[_j1].x*width;
  float wristY = _s.skeletonPositions[_j1].y*height;
  float handX = _s.skeletonPositions[_j2].x*width;
  float handY = _s.skeletonPositions[_j2].y*height;

  if (wristX < handX) {
    x = wristX;
    w = handX - wristX;
  } else {
    x = handX;
    w = wristX - handX;
  }

  if (wristY < handY) {
    y = wristY;
    h = handY - wristY;
  } else {
    y = handY;
    h = wristY - handY;
  }

  return new Point((int)(x + w/2),(int)(y + h/2));
}

void appearEvent(SkeletonData _s) {
  if (_s.trackingState == Kinect.NUI_SKELETON_NOT_TRACKED) return;

  synchronized(bodies) {
    bodies.add(_s);
  }
}

void disappearEvent(SkeletonData _s) {
  synchronized(bodies) {
    for (int i=bodies.size ()-1; i>=0; i--) 
    {
      if (_s.dwTrackingID == bodies.get(i).dwTrackingID) 
        bodies.remove(i);
    }
  }
}

void moveEvent(SkeletonData _b, SkeletonData _a) {
  if (_a.trackingState == Kinect.NUI_SKELETON_NOT_TRACKED) return;

  synchronized(bodies) {
    for (int i=bodies.size ()-1; i>=0; i--) 
    {
      if (_b.dwTrackingID == bodies.get(i).dwTrackingID) 
      {
        bodies.get(i).copy(_a);
        break;
      }
    }
  }
}

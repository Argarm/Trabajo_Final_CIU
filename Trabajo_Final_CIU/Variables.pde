import arb.soundcipher.*;
import controlP5.*;
import java.awt.Color;
import java.awt.Point;
import java.util.ArrayDeque;
import kinect4WinSDK.Kinect;
import kinect4WinSDK.SkeletonData;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;
import org.jbox2d.dynamics.joints.*;
import shiffman.box2d.*;


ArrayDeque<Integer>[] torres;
ArrayList boundaries;
ArrayList<Box> boxes;
ArrayList<Integer> dynamicCola, dynamicMaker, staticCola, staticMaker;
ArrayList<Piece> pieceCollection;
ArrayList <SkeletonData> bodies;

boolean cam, dynamicAccess, sonido, staticAccess;
boolean pressed = false;
Box leftBase, centerBase, rightBase;
static Box2DProcessing box2d;

color myColor;
ControlP5 cp5;

float volumen;

enum Estado {
  menuPrincipal, 
    menuOpciones, 
    juego, 
    pausa
}
Estado estado;

HandBox leftHandBox, rightHandBox;

int accountant, buttonYSeparator, freeId, posXButton, posYButtonOffset, tamXButton, tamYButton;
int dificultad = 0;
int numberOfPieces = 4;
int[] towerLastId;

Kinect kinect;

PImage altavoz, noaltavoz, camara, nocamara;
Point leftHandPos, rightHandPos;
PVector iconPosition, iconSize;

SoundCipher sc;
Spring springRightHand, springLeftHand;

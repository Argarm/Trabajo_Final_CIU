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
import processing.sound.*;


ArrayDeque<Integer>[] torres;
ArrayDeque<Integer> estadoFinal;
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

float volumen, x_progressbar, y_progressbar, d_progressbar; 
float soundprogress = 0,camprogress = 0, pausaprogress = 0, playprogress = 0;

enum Estado {
  menuPrincipal, 
  menuOpciones, 
  juego, 
  pausa,
  ganar
}
Estado estado;

HandBox leftHandBox, rightHandBox;

int accountant, buttonYSeparator, freeId, posXButton, posYButtonOffset, tamXButton, tamYButton;
int dificultad = 1;
int numberOfPieces = 1;
int[] towerLastId;

Kinect kinect;

long tiempo_progressbar;

PImage altavoz, noaltavoz, camara, nocamara, pausa,play;
Point leftHandPos, rightHandPos;
PVector iconPosition, iconSize, leftHandBoxPosition, rightHandBoxPosition;

SoundCipher sc;
SoundFile victoria;
Spring springRightHand, springLeftHand;

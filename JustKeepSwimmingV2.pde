
/*
This program is a game in which you have to drag and shoot a shark to eat fish
 If you hit an obstacle time will be deducted.
 This program incorporates:
 - randomness
 - particles
 - forces/PVectors
 - mass-spring-dampeners
 - flocking
 - a state machine
 
 Made for the end assignment of Algorithms
 by Anna van der Linden and Kai Ferdelman
 */

import javax.swing.*;    //import library from the java domain

PVector screenSize;
float offset = 0;      //initialize the noise offset for the background
int score = 0;
boolean paused = false;

String[] highScore;

StateMachine stateMachine;

void setup() {
  noCursor();
  fullScreen();
  screenSize = new PVector(width, height);
  frameRate(30);
  highScore = loadStrings("file.txt");
  stateMachine = new StateMachine(1);
}

void draw() {
  if (!paused) {
    //create a color changing background
    background(70, 240, 250 - noise(offset) * 70);
    offset += .01;
    stateMachine.run();
  }
}

// Handle keyboard and mouse input
void mousePressed() {
  stateMachine.mousePress();
}

void mouseDragged() {
  stateMachine.mouseDrag();
}

void mouseReleased() {
  stateMachine.mouseRelease();
}

void keyPressed() {
  stateMachine.keyPress();
}
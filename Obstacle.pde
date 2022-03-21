//This class handles any obstacles that are introduced into a level
class Obstacle {
  //initialize variables
  PVector position;
  int number;
  float offset = 0;
  int forceTimer = 0;
  int force = 0;
  float obstacleMultiplier = 1;
  PImage[] images = {loadImage("anchor.gif"), loadImage("rope.png"), loadImage("boot.png"), loadImage("bag.png")};

  Obstacle(PVector position, int i) {
    //set the position and identifier
    this.position = position;
    number = i;
  }

  void run() {

    //select what happens with the obstacle
    switch(number) {
    case 0: 
      anchor();
      break;
    case 1: 
      boot();
      break;
    case 2: 
      bag();
      break;
    }
    offset += .01;
  }

  void anchor() {
    //handle and draw the anchor
    image(images[1], position.x - 10, position.y - screenSize.y - 30, 20, screenSize.y);
    image(images[0], position.x - 50, position.y - 50, 100, 100);
  }

  void boot() {
    //handle and draw the boot
    pushMatrix();
    translate(position.x - 40, position.y - 40);
    rotate(noise(offset) * HALF_PI - QUARTER_PI);
    image(images[2], 0, 0, 80, 80);
    popMatrix();
    position.x -= noise(offset) * 2;
    position.y += noise(offset) * 10 - 5;
    if (forceTimer > 0) {
      position.y += force; 
      forceTimer --;
    }
    if (position.x < -40) position.x = screenSize.x + 40;
    //when stuck at the top or the bottom it gets forced the other way
    if (position.y > screenSize.y - 40) {
      position.y = screenSize.y - 40;
      forceTimer = 50;
      force = -5;
    }
    if (position.y < 40) {
      position.y = 40;
      forceTimer = 50;
      force = 5;
    }
  }

  void bag() {
    //handle and draw the bag
    pushMatrix();
    translate(position.x - 40, position.y - 40);
    rotate(noise(offset) * TWO_PI - PI);
    image(images[3], 0, 0, 80, 80);
    popMatrix();
    position.x -= noise(offset + 1) * 4;
    position.y += noise(offset + 1) * 15 - 7.5;
    if (forceTimer > 0) {
      position.y += force; 
      forceTimer --;
    }
    if (position.x < -40) position.x = screenSize.x + 40;
    //when stuck at the top or the bottom it gets forced the other way
    if (position.y > screenSize.y - 40) {
      position.y = screenSize.y - 40;
      forceTimer = 50;
      force = -5;
    }
    if (position.y < 40) {
      position.y = 40;
      forceTimer = 50;
      force = 5;
    }
  }
}
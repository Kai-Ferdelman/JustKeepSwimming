/*
This Tab contains the class for a bubble and the class for the particles that get created upon destroying the bubble
 */

class Bubble {
  //initialize variables and objects
  PVector position = new PVector(0, 0);
  PVector speed = new PVector(0, random(2, 5));
  float offset = random(5);
  Particle[] particles = new Particle[100];
  boolean popped = false;


  Bubble(PVector _position) {
    position = _position.copy();  //set the position
  }

  void display() {
    //draw the bubble
    fill(#02C9CE, 100);
    stroke(255);
    strokeWeight(4);
    ellipse(position.x, position.y, 30, 30);
  }

  void run(Shark _shark) {
    display();
    //check if the bubble is popped
    pop(_shark);
    if (popped) {
      for (int i = 0; i < particles.length; i++) {
        //if popped then create particles
        particles[i].run();
      }
    }
    position.x += noise(offset) * 5 - 2.5;
    offset += .01;
    position.y -= speed.y;
    if (position.y < 0) position.y = screenSize.y;
    if (position.x < 0) position.x = screenSize.x;
    if (position.x > screenSize.x) position.x = 0;
  }

  void pop(Shark _shark) {
    if (_shark != null) {
      //check if the shark is over the bubble
      float d = PVector.dist(position, _shark.position);
      float maxDistance = 100;

      if (d < maxDistance) {
        popped = true;
        for (int j = 0; j < 100; j++) {
          particles[j] = new Particle(position, new PVector(speed.x + random(-2, 2), speed.y + random(-10, -5)));
        }
        position.y = screenSize.y;
        position.x = random(screenSize.x);
      }
    }
  }
}

class Particle {
  //initialize variables
  int particleColor;
  int lifespan = 90;
  PVector pos;
  PVector speed;

  Particle(PVector initPos, PVector initSpeed) {
    //set the position and the speed
    pos = initPos.copy();
    speed = initSpeed.copy();
  }

  void run() {

    //draw the particles and reduce the lifespan
    lifespan -= 1;

    fill(255, lifespan);
    noStroke();
    ellipse(pos.x, pos.y, 5, 5);
    speed.mult(.95);
    pos.add(speed);
  }
}
/*
This is the class for the drawing and moving the shark
 */

class Shark {

  //initialize variables
  PVector position = new PVector(0, 0);
  PVector lineDirection = new PVector(0, 0);
  boolean isShot = false;
  boolean isDragged = false;
  PVector speed;
  float acceleration = 0.95;
  float angle = 0;
  float obstacleDistance = 50;
  float sharkMultiplier;

  Shark(float _sharkMultiplier) {
    sharkMultiplier = _sharkMultiplier;
  }

  void run(Obstacle[] _obstacles, UI _ui) {
    //if the shark is not dragged or shot it's at the mouse position
    if (!isShot && !isDragged) {
      position.x = mouseX;
      position.y = mouseY;
    } else if (!isDragged) {      //if the shark is shot move it based on its speed
      speed.mult(acceleration);
      position.add(speed);
      //if the shark goes off screen at the top or bottom move it back to the mouse
      if (position.y < -50 || position.y > screenSize.y + 50) isShot = false;
      //the shark bounces on the left and right of the screen
      if (position.x < 0 || position.x > screenSize.x) speed.x *= -1;
      //if the speed is too small bring it back to the mouse
      if (speed.mag() < 1) isShot = false;
    }
    display();
    hitObstacle(_obstacles, _ui);
  }

  void display() {
    //draw the shark
    pushMatrix();
    translate(position.x, position.y);
    //flip the shark based on its angle
    if (lineDirection.x > 0) {
      scale(-1, 1);
    } else {
      scale(-1, -1);
    }
    //rotate the shark based on the mouse position
    rotate(angle);
    fill(180);
    stroke(100);
    strokeWeight(3);
    beginShape();
    vertex(-20, 10);
    bezierVertex(-20, -20, 0, -40, 30, -40);
    bezierVertex(20, -35, 20, -20, 20, 10);
    endShape();
    beginShape();
    vertex(75, 10);
    bezierVertex( 80, 0, 100, -15, 110, -10);
    bezierVertex(110, 0, 100, 10, 100, 10);
    bezierVertex(100, 10, 110, 20, 110, 30);
    bezierVertex(100, 35, 80, 20, 75, 10);
    endShape();
    arc(0, 100, 250, 250, PI+QUARTER_PI, TWO_PI-QUARTER_PI, OPEN);
    arc(0, -60, 250, 200, QUARTER_PI, 3*QUARTER_PI, OPEN);
    noFill();
    strokeWeight(3);
    beginShape();
    vertex(-20, 10);
    bezierVertex(-5, 20, 15, 30, 20, 20);
    endShape();
    fill(0);
    noStroke();
    ellipse(-60, 0, 5, 5);
    fill(255);
    strokeWeight(1);
    stroke(100);
    triangle(-82, 15, -65, 10, -70, 23);
    line(-60, 20, -45, 10);
    line(-55, 22, -40, 12);
    line(-50, 24, -35, 14);
    popMatrix();
  }

  void dragShark() {
    //calculate the angle at which the shark is dragged
    if (!isShot) {
      stroke(0);
      line(position.x, position.y, mouseX, mouseY);
      lineDirection.x = position.x - mouseX;
      lineDirection.y = position.y - mouseY;
      lineDirection.normalize();
      angle = acos(lineDirection.y);
      if (lineDirection.x > 0) {
        angle -= HALF_PI;
      } else {
        angle += HALF_PI;
      }
      isDragged = true;
    }
  }

  void releaseShark() {
    if (!isShot) {
      //set the sharks speed
      isShot = true;
      isDragged = false;
      speed = new PVector(0, 0);
      speed.x = position.x - mouseX;
      speed.y = position.y - mouseY;
      speed.normalize();
      speed.mult(30);
    }
  }

  void hitObstacle(Obstacle[] _obstacles, UI _ui) {
    //check if shark is on an obstacle
    for (int i = 0; i < _obstacles.length; i++) {
      float d = PVector.dist(position, _obstacles[i].position);
      if (d < obstacleDistance && isShot) {
        //reduce time and bring shark back to the mouse position
        _ui.hitObstacle();
        isShot = false;
      }
    }
  }
}
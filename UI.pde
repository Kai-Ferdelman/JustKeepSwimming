/*
This is the class that handles the UI for the levels
 */

class UI {

  //initialize variables
  int timer;
  float hitTimer = 0;

  UI() {
    reset();
  }

  void run() {

    //display UI elements
    fill(0);
    textSize(30);
    text("Your Score is: "+score, 20, 30);
    text("Remaining Time is: "+timer/30, screenSize.x - 350, 30);
    if (timer > 0)
      timer--;
    if (timer <= 0) {
      //when timer runs out reset and change the state to the next level/endscreen
      stateMachine.nextState();
      reset();
    }

    if (hitTimer >= 0) {
      //turn screen red for half a second
      fill(255, 0, 0, 150);
      rect(0, 0, screenSize.x, screenSize.y);
      fill(0);
      text("Time -10!", screenSize.x / 2 - 50, screenSize.y / 2);
      hitTimer--;
    }
  }

  void hitObstacle() {
    timer -= 300;
    hitTimer = 15;
  }

  void reset() {
    //reset all variables and objects
    timer = 1800;
    paused = false;
  }

  void pause() {
    noStroke();
    fill(255);
    rect(3*screenSize.x/7, screenSize.y/3, 100, screenSize.y/3); 
    rect(4*screenSize.x/7, screenSize.y/3, -100, screenSize.y/3);
  }
}
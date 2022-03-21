//This class decides what screen should be run at any point
class StateMachine {
  StartScreen startScreen;
  EndScreen endScreen;
  Level1 level1;
  int state = 0;
  int stateAmount;

  StateMachine(int _stateAmount) {
    startScreen = new StartScreen();
    level1 = new Level1();
    stateAmount = _stateAmount + 2;
    endScreen = new EndScreen(stateAmount-1);
  }

  void run() {
    switch(state) {
    case 0: 
      startScreen.run();
      break;
    case 1: 
      level1.run();
      break;
    case 2: 
      endScreen.run();
      break;
    }
  }

  void nextState() {
    state++;
    if (state > stateAmount) {
      state = 0;
    }
  }

  void previousState() {
    state++;
    if (state < 0) {
      state = stateAmount;
    }
  }

  void startState() {
    state = 0;
  }

  void mousePress() {
    switch(state) {
    case 0:
      state = startScreen.mouseHandler();
      break;
    case 2:
      state = endScreen.mouseHandler();
      break;
    }
  }

  void mouseDrag() {
    switch(state) {
    case 1:
      level1.mouseDrag();
      break;
    }
  }

  void mouseRelease() {
    switch(state) {
    case 1:
      level1.mouseRelease();
      break;
    }
  }

  void keyPress() {
    switch(state) {
    case 1:
      level1.keyPress();
      break;
    }
  }
}
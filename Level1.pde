//This class creates and handles all the elements of the first level
class Level1 extends MainSuper {

  Obstacle[] obstacles; // An Array for all the obstacles
  Shark shark;

  Level1() {
    super(100, 3, true);
    obstacles = new Obstacle[3]; // Initialize the obstacles Array
    for (int i = 0; i < obstacles.length; i++) {
      obstacles[i] = new Obstacle(new PVector(random(100, screenSize.x - 100), random(200, screenSize.y - 100)), i);
    }
    shark = new Shark(2.5);
  }
  void run() {
    if (!paused) {
      for (int i = 0; i < obstacles.length; i++) {
        obstacles[i].run();
      }
      shark.run(obstacles, ui);
      _run(obstacles, shark);
    }
  }

  void mouseDrag() {
    shark.dragShark();
  }

  void mouseRelease() {
    shark.releaseShark();
  }

  void keyPress() {
    if (key == ENTER) {
      paused = !paused;
      ui.pause();
    }
  }
}
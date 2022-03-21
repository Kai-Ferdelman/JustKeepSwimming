//This is the super class extended by all the levels and other screens. It handles all components used by all
class MainSuper {

  Flock flock;
  Bubble[] bubbles;
  GrassField grassField;
  UI ui;

  boolean isLevel;

  MainSuper(int _flockSize, float _maxSpeed, boolean _isLevel) {
    isLevel = _isLevel;
    reset(_flockSize, _maxSpeed);
  }

  void _run(Obstacle[] _obstacles, Shark _shark) {
    flock.run(_obstacles, _shark);
    grassField.run();
    for (int i = 0; i < bubbles.length; i++) {
      bubbles[i].run(_shark);
    }
    if (isLevel) {
      ui.run();
    }
  }

  void reset(int _flockSize, float _maxSpeed) {
    flock = new Flock(_flockSize, _maxSpeed);
    grassField = new GrassField();
    bubbles = new Bubble[10];
    for (int i = 0; i < bubbles.length; i++) {
      bubbles[i] = new Bubble(new PVector(random(screenSize.x), screenSize.y));
    }
    if (isLevel) {
      ui = new UI();
    }
  }
}
//This class creates and handles all the elements of the startscreen
class StartScreen extends MainSuper {

  //load images
  PImage startImage = loadImage("startImage.png");
  PImage logo = loadImage("JustKeepSwimming.png");

  Obstacle[] obstacles; // An Array for all the obstacles

  StartScreen() {
    super(100, 3, false);
    obstacles = new Obstacle[3]; // Initialize the obstacles Array
    for (int i = 0; i < obstacles.length; i++) {
      obstacles[i] = new Obstacle(new PVector(random(100, screenSize.x - 100), random(200, screenSize.y - 100)), i);
    }
  }

  void run() {
    _run(obstacles, null);
    pushMatrix();
    translate(950, screenSize.y/2);
    noStroke();
    fill(100);
    //highlight button if hovering over it
    if (mouseX > 800 && mouseX < 1100 && mouseY > screenSize.y/2-150 && mouseY < screenSize.y/2+150) {
      fill(0);
    }
    ellipse(0, 0, 310, 310);
    image(startImage, -148, -152, 300, 300);
    popMatrix();

    //display the name at the top
    image(logo, screenSize.x/4, screenSize.y/8);
    fill(0);

    //display high score
    text("High score by "+highScore[0]+" is "+highScore[1], screenSize.x / 2 - 200, screenSize.y / 7);

    //display instructions
    textSize(30);
    text("Drag your mouse to shoot the shark at the fish.\n         Eat as may fish before the time is up.\nDo not shoot into an obstacle. And have FUN!!!!!", screenSize.x/3, screenSize.y/4 *3);
    fill(255, 0, 0);
    noStroke();
    ellipse(mouseX, mouseY, 20, 20);
    score = 0;
  }

  int mouseHandler() {
    //check if mouse click occurs on the button if so change the state
    if (mouseX > 800 && mouseX < 1100 && mouseY > screenSize.y/2-150 && mouseY < screenSize.y/2+150) {
      return 1;
    }
    return 0;
  }
}
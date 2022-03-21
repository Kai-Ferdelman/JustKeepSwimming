//This class creates and handles all the elements of the endscreen
class EndScreen extends MainSuper {

  //initialize variables
  PImage endScreenImage = loadImage("endScreenImage.png");
  String name = "";
  int highscoreInt;
  boolean firstFrame = true;
  int endState;

  Obstacle[] obstacles; // An Array for all the obstacles

  EndScreen(int _endState) {
    super(100, 3, false);
    endState = _endState;
    //get the highscore from UI and make it into an integer
    highscoreInt = Integer.parseInt(highScore[1]);

    obstacles = new Obstacle[3]; // Initialize the obstacles Array
    for (int i = 0; i < obstacles.length; i++) {
      obstacles[i] = new Obstacle(new PVector(random(100, screenSize.x - 100), random(200, screenSize.y - 100)), i);
    }
  }

  void run() {
    _run(obstacles, null);
    fill(0);
    textSize(100);
    text("Time's up!", screenSize.x/2 - 250, screenSize.y / 3);
    textSize(50);
    text("Your score is: "+score, screenSize.x/2 - 200, (screenSize.y/5) * 2);
    textSize(30);
    text("The high score by "+highScore[0]+" is: "+highScore[1], screenSize.x/2 - 200, screenSize.y / 7 * 3);

    //create a clickable button
    pushMatrix();
    translate(950, 2 * screenSize.y/3);
    noStroke();
    fill(100);
    if (mouseX > 800 && mouseX < 1100 && mouseY > 2 * screenSize.y / 3 - 150 && mouseY < 2 * screenSize.y / 3 + 150) {
      fill(0);
    }
    ellipse(0, 0, 310, 310);
    image(endScreenImage, -178, -165, 370, 340);
    popMatrix();
    fill(255, 0, 0);
    noStroke();
    ellipse(mouseX, mouseY, 20, 20);

    //if the high score is beaten open an input panel and save the new name in the text file
    if (score > highscoreInt && !firstFrame) {
      name = JOptionPane.showInputDialog("You beat the high score!\nEnter your name.");
      highscoreInt = score;
      String[] newHighscore = {name, str(highscoreInt)};
      highScore = newHighscore;
      saveStrings("file.txt", newHighscore);
    }
    firstFrame = false;
  }

  int mouseHandler() {
    //check if the mouse is over the button when it's clicked
    if (mouseX > 800 && mouseX < 1100 && mouseY > 2 * screenSize.y / 3 - 150 && mouseY < 2 * screenSize.y / 3 + 150) {
      score = 0;
      return 0;
    }
    return endState;
  }
}
//This tab contains the classes for a grassfield and its sub classes i.e. single grass, piece of grass
class GrassField {
  //initialize objects and variables
  Grass[] grass;

  float time = 0;
  float increment = 0.05;

  GrassField() {
    //set the size of the grass array
    grass = new Grass[150];

    //draw the grasses clumped towards the middle
    for (int i = 0; i < grass.length; i++) {
      grass[i] = new Grass(int(randomGaussian()*0.5 * width/3 + width/2), int(random(5, 15)));
    }
  }

  void run() {
    //move the grasses with the current
    for (int i = 0; i < grass.length; i++) {
      grass[i].move(noise(time + i) / 5);
      time += increment;
    }
  }
}

class Grass {
  //initialize variables
  GrassPiece[] sp;
  int xPos, segments;

  Grass(int _xPos, int _segments) {
    // get values from the GrassField class
    segments = _segments;
    xPos = _xPos;
    sp = new GrassPiece[segments];
    //initialize grass segments
    for (int i = 0; i < sp.length; i++) {
      sp[i] = new GrassPiece(3, 0.1, 0.3, new PVector(xPos, screenSize.y));
    }
  }

  void move(float wind) {
    //calculate and draw all segments

    //handle the first segment
    sp[0].calculate(sp[1]);
    sp[0].display(sp[0].origin, segments - 0);

    //handle the middle segments
    for (int i = 1; i < sp.length - 1; i++) {
      sp[i].calculate(sp[i+1]);
      sp[i].display(sp[i-1].position, segments - i);
    }

    //handle the last segment
    sp[sp.length-1].wind(wind);
    sp[sp.length-1].display(sp[sp.length-2].position, segments - sp.length);
  }
}

class GrassPiece {
  //initialize variables
  float m, k, d, angle, v, a, F;
  PVector position, origin;

  GrassPiece( float _m, float _k, float _d, PVector _origin) {
    //get the variables from the Grass class
    m = _m;
    d = _d;
    k = _k;
    origin = _origin;
    position = new PVector();
  }

  void calculate(GrassPiece stem) {
    //calculate its movement
    F = stem.k * (stem.angle - angle) + stem.d * (stem.v - v) - k * angle - d * v;
    a = F/m;
    v += a;
    angle += v;
  }

  void wind(float _F) {
    //add the wind force to the segment
    F = _F - (v * d) + (angle * -1 * k);
    a = F/m;
    v += a;
    angle += v;
  }

  void display(PVector pos, int _i) {
    //draw a segment
    this.position.set(-10 * sin(angle), -10 * cos(angle), 0);
    this.position.add(pos);
    stroke(#138B01);
    strokeWeight(_i + 3);
    line(pos.x, pos.y, position.x, position.y);
  }
}
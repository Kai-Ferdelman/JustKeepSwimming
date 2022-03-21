//This Tab contains the class for an entire flock and the class for a single boid/fish

class Flock {
  ArrayList<Boid> boids; // An ArrayList for all the boids

  Flock(int _fishNumber, float _speed) {
    boids = new ArrayList<Boid>(); // Initialize the Boids ArrayList

    for (int i = 0; i < _fishNumber; i++) {

      Boid b = new Boid(random(screenSize.x), random(screenSize.y), _speed);
      addBoid(b);
    }
  }

  void run(Obstacle[] _obstacles, Shark _shark) {
    for (Boid b : boids) {
      b.run(boids, _obstacles, _shark);  // Passing the entire list of boids to each boid individually
    }
  }

  void addBoid(Boid b) {
    boids.add(b);
  }

  void deleteBoid(int boidNumber) {
    boids.remove(boidNumber);
  }
}

class Boid {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float r;           // Size of the fishy
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed
  color fishColor = color (random(255), random(255), random(255));
  float eatingDistance = 50;

  Boid(float x, float y, float _maxSpeed) {
    acceleration = new PVector(0, 0);
    velocity = new PVector(random(-1, 1), random(-1, 1));
    position = new PVector(x, y);
    r = 5.0;
    maxspeed = _maxSpeed;
    maxforce = 0.1;
  }

  void run(ArrayList<Boid> boids, Obstacle[] _obstacles, Shark _shark) {
    flock(boids, _obstacles, _shark);
    update();
    borders();
    render();
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }

  // We accumulate a new acceleration each time based on three rules
  void flock(ArrayList<Boid> boids, Obstacle[] obstacles, Shark _shark) {
    PVector sep = separate(boids);   // Separation
    PVector ali = align(boids);      // Alignment
    PVector coh = cohesion(boids);   // Cohesion
    PVector avo = avoidance(obstacles, _shark);  // Avoidance
    // Arbitrarily weight these forces
    sep.mult(1.5);
    ali.mult(1.0);
    coh.mult(1.0);
    avo.mult(7);
    // Add the force vectors to acceleration
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
    applyForce(avo);
  }

  // Method to update position
  void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    position.add(velocity);
    // Reset acceleration to 0 each cycle
    acceleration.mult(0);
  }

  // A method that calculates and applies a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, position);  // A vector pointing from the position to the target
    // Normalize desired and scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);
    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    return steer;
  }

  void render() {
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading2D() + radians(90);
    fill(fishColor);
    strokeWeight(1);
    stroke(0);
    pushMatrix();
    translate(position.x, position.y);
    rotate(theta);
    pushMatrix();
    rotate(-HALF_PI);
    beginShape();
    vertex(0, 0);
    bezierVertex(10, -10, 20, -10, 30, 0);
    bezierVertex(20, 10, 10, 10, 0, 0);
    endShape();
    triangle(0, 0, -10, -10, -10, 10);
    popMatrix();
    popMatrix();
  }

  // Wraparound
  void borders() {
    if (position.x < r) velocity.x *= -1;
    if (position.y < r) velocity.y *= -1;
    if (position.x > screenSize.x-r) velocity.x *= -1;
    if (position.y > screenSize.y-r) velocity.y *= -1;
  }

  // Separation
  // Method checks for nearby boids and steers away
  PVector separate (ArrayList<Boid> boids) {
    float desiredseparation = 30.0;
    PVector steer = new PVector(0, 0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(position, other.position);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }

  // Alignment
  // For every nearby boid in the system, calculate the average velocity
  PVector align (ArrayList<Boid> boids) {
    float neighbordist = 50;
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.velocity);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      sum.normalize();
      sum.mult(maxspeed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxforce);
      return steer;
    } else {
      return new PVector(0, 0);
    }
  }

  // Cohesion
  // For the average position (i.e. center) of all nearby boids, calculate steering vector towards that position
  PVector cohesion (ArrayList<Boid> boids) {
    float neighbordist = 50;
    PVector sum = new PVector(0, 0);   // Start with empty vector to accumulate all positions
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.position); // Add position
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      return seek(sum);  // Steer towards the position
    } else {
      return new PVector(0, 0);
    }
  }

  //function for avoiding obstacles
  PVector avoidance (Obstacle[] obstacles, Shark _shark) {
    float maxDistance = 80;
    PVector sum = new PVector(0, 0);
    int count = 0;
    //compare boids position to each obstacle position
    for (int i = 0; i < obstacles.length; i++) {
      float d = PVector.dist(position, obstacles[i].position);
      // if the obstacle is too close then turn away
      if ((d > 0) && (d < maxDistance * obstacles[i].obstacleMultiplier)) {
        PVector diff = PVector.sub(position, obstacles[i].position);
        diff.normalize();
        diff.div(d);
        sum.add(diff);
        count++;
      }
    }
    if (_shark != null) {
      float d = PVector.dist(position, _shark.position);
      if ((d > 0) && (d < maxDistance * _shark.sharkMultiplier)) {
        //if the obstacle is the shark set new position and add to the counter
        if (d < eatingDistance && _shark.isShot) {
          position.set(random(screenSize.x), random(screenSize.y));
          score++;
        }
        PVector diff = PVector.sub(position, _shark.position);
        diff.normalize();
        diff.div(d);
        sum.add(diff);
        count++;
      }
    }

    if (count > 0) {
      sum.div(count);
    }

    if (sum.mag() > 0) {
      sum.normalize();
      sum.mult(maxspeed);
      sum.sub(velocity);
      sum.limit(maxforce);
    }
    return sum;
  }
}
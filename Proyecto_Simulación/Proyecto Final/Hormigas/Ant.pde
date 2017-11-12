class Ant {
  /* At each frame, an ant is in one of the following six states. 
   0: wandering, 1: food found, 2: food reached,
   3: phero found, 4: phero reached, 5: nest reached
   */
  boolean[] states = new boolean[6];
  PVector target;
  PVector location; 
  PVector velocity = new PVector(cos(random(TWO_PI)), sin(random(TWO_PI)));
  PVector acceleration  = new PVector(0, 0);
  PVector desired;
  int size = 4;
  color colorWithoutFood = color(20, 0, 0);
  color colorWithFood = color(240, 160, 100);
  color antColor = colorWithoutFood;
  float maxSpeed = 1.5;
  float maxForce = 0.4;
  float movingDistance; // needed for determining phero dropping interval
  
  int numWandering = 0;
  int maxNumWandering = 0; // an ant randomly changes moving direcions after a certain number of steps
  
  Food foodGathered;
  boolean found; // food or phero found
  boolean reached; // food or phero reached
  boolean gathered; // food gathered
  boolean near; // near the nest

  //drawing ants
  //head, chest, body
  float[] head = {-25, 20, -40, -40, 40, -40, 25, 20, 10, 80, -10, 80, -25, 20};
  float[] chest = {0, 115, 20, 108};
  float[] body = {-35, 200, -20, 155, 20, 155, 35, 200, 80, 335, -80, 335, -35, 200};
  //left side
  float[] antennaL = {-25, -10, -70, -5, -75, -40, -80, -50};
  float[] leg0LU = {-8, 75, -20, 75, -40, 75, -75, 55};
  float[] leg0LD = {-8, 75, -20, 75, -40, 75, -80, 70};
  float[] leg1LU = {-11, 100, -15, 100, -85, 100, -120, 80};
  float[] leg1LD = {-11, 100, -15, 100, -85, 100, -130, 140};
  float[] leg2LU = {-8, 150, -20, 150, -150, 180, -180, 220};
  float[] leg2LD = {-8, 150, -20, 170, -140, 200, -120, 340};
  //right side
  float[] antennaR = {25, -10, 70, -5, 75, -40, 80, -50};
  float[] leg0RU = {8, 75, 20, 75, 40, 75, 75, 55};
  float[] leg0RD = {8, 75, 20, 75, 40, 75, 80, 70};
  float[] leg1RU = {11, 100, 15, 100, 85, 100, 120, 80};
  float[] leg1RD = {11, 100, 15, 100, 85, 100, 130, 140};
  float[] leg2RU = {8, 150, 20, 150, 150, 180, 180, 220};
  float[] leg2RD = {8, 150, 20, 170, 140, 200, 120, 340};

  Ant(float locX, float locY) {
    states[0] = true;
    states[1] = false;
    states[2] = false;
    states[3] = false;
    states[4] = false;
    states[5] = false;
    location = new PVector(locX, locY);
  }

  void run() {
    dropPhero();
    separate(ants); // an ant dodges if it encounters another
    if (states[0]) {// an ant wanders
      wander(); 
      float r = random(1);
      if (r > 0.3) {//keep wandering without seaching for food or pheromon with prob. 0.3
        if (!(inNest(location.x, location.y))) {// if the ant is outside the nest 
          if (!gathered) {// if the ant has no food
            searchForFood(); // the ant searches for food
            if (found) {// if the ant finds food
              setTrue(states, 1); // state changes to 1
            } else { // if the ant does not find food
              searchForPhero(); // the ant searches for pheromones which may have been dropped by other ants   
              // while delivering food to the nest
              if (found) { // if the ant finds a pheromone 
                setTrue(states, 3);  // state changes to 3
              }
            }
          } else {// if the ant carries food 
            searchForPhero(); 
            if (found) { // if the ant finds a pheromone 
              setTrue(states, 3);  // state changes to 3
            }
          }
        }
      }
    } else if (states[1]) {// an ant knows where the food is 
      goToFood(); // the ant goes to the food
      if (reached) { // if the ant reaches the food
        setTrue(states, 2); // state changes to 2
      }
    } else if (states[2]) { // an ant reaches the food
      antColor = colorWithFood; // the color of the ant with the food changes
      checkNearNest();
      if (near) { // if the ant with the food is near the nest
        goToNest(); // the ant goes to the nest
        if (reached) {// if the ant with the food reaches the nest, 
          setTrue(states, 5); // state changes to 5
        }
      } else { // if the ant with the food is far from the nest
        turnAround(); // the ant turns around to where it came from
        searchForPhero(); 
        if (found) { // if the ant find a pheromone
          setTrue(states, 3); // state changes to 3
        } else { // if the ant does not find a pheromone
          setTrue(states, 0); // state changes to 0 (the ant with the food wanders)
        }
      }
    } else if (states[3]) {// an ant knows where a pheromone is 
      goToPhero(); // the ant goes to the pheromone
      if (reached) { // if the ant reaches the pheromone
        setTrue(states, 4); // state changes to 4
      }
    } else if (states[4]) { // an ant reahces the pheromone
      if (gathered) {// if the ant has food
        checkNearNest();
        if (near) {// if the ant is near the nest
          goToNest(); // the ant goes to the nest
          if (reached) { // if the ant reaches the nest,  
            setTrue(states, 5); // state changes to 5
          }
        } else { // if the ant with the food is far from the nest
          searchForPhero(); 
          if (found) { // if the ant find a pheromone
            setTrue(states, 3); // state changes to 3
          } else { 
            setTrue(states, 0); // state changes to 0 (the ant with the food wanders)
          }
        }
      } else { // an ant has no food
        searchForFood(); 
        if (found) {// if the ant finds food
          setTrue(states, 1); // state changes to 1
        } else {// the ant does not find food 
          searchForPhero(); // 
          if (found) { // if the ant finds a pheromone 
            setTrue(states, 3); // state changes to 3
          }
        }
      }
    } else if (states[5]) {// an ant reaches the nest
      deliverFood(foodGathered); // the ant stores food gathered at the nest
      turnAround(); // the chance of finding more food is higher at the food site it visited than anywhere else
      setTrue(states, 0); // state changes to 0
    }
    update(); 
    show();
  }

  void update() {
    velocity.add(acceleration);
    velocity.limit(maxSpeed);
    wiggle();
    location.add(velocity);
    acceleration.mult(0);
    movingDistance += velocity.mag();
    inBoundary(); //make sure ants are within the show
  }

  PVector seek() { // turn to the target
    PVector desired = PVector.sub(target, location);  // desired velocity to the target
    desired.setMag(maxSpeed);
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxForce); 
    return steer;
  }
  


  void wander() {
    maxNumWandering = (int) random(300, 500);
    numWandering++;
    if (numWandering >= maxNumWandering) { 
      target = PVector.random2D(); // new andom target
       println("target de wander: " + target);
      target.mult(1500);
      PVector steer = seek();
      acceleration.add(steer);
      numWandering = 0;
    }
  }

  void searchForFood() {
    setFalse(); // set found, reached and near to false
    Food foodFound = new Food();
    foodFound.x = -1;
    foodFound.y = -1;
    for (Food f : foodSite) {
      if (!f.spotted) {
        PVector fLoc = new PVector(f.x, f.y);
        if (PVector.dist(fLoc, location) < 80 && PVector.angleBetween(velocity, PVector.sub(fLoc, location)) <= PI/2) {
          foodFound = f;
          break;
        }
      }
    }
    if (foodFound.x != -1 && foodFound.y != -1) { // the ant finds food
      foodFound.spotted = true; // other ants are prevented from gathering the food
      foodGathered = foodFound; // 
      target = new PVector(foodFound.x, foodFound.y);
      found = true;
    }
  }

  void searchForPhero() {
    setFalse(); 
    Pheromon pheroFound = new Pheromon();
    pheroFound.x = -1.0;
    pheroFound.y = -1.0;
    for (Pheromon p : pheroDrops) {
      if (p.evaporation < 150) {
        PVector pLoc = new PVector(p.x, p.y);
        if (PVector.dist(pLoc, location)  < 100 && PVector.angleBetween(velocity, PVector.sub(pLoc, location)) <= PI/3) {//
          pheroFound = p;
          break;
        }
      }
    }
    if (pheroFound.x != -1 && pheroFound.y != -1) { // the ant finds food
      target = new PVector(pheroFound.x, pheroFound.y); 
      found = true;
    } else {
      setTrue(states, 0);
    }
  }

  void goToFood() {
    PVector steer = seek();
    acceleration.add(steer);
    checkFoodReached();
  }

  void goToPhero() {
    PVector steer = seek();
    acceleration.add(steer);
    checkPheroReached();
  }

  void goToNest() {
    PVector steer = seek();
    acceleration.add(steer);
    checkNestReached();
  }

  void checkFoodReached() {
    setFalse(); 
    desired = PVector.sub(target, location); 
    float d = desired.mag();
    if (d < 10) {
      antColor = colorWithFood; 
      gathered = true;
      reached = true;
      updateFood(); // food gathered is removed from a food site
    }
  }

  void checkPheroReached() {
    setFalse(); 
    desired = PVector.sub(target, location); 
    float d = desired.mag();
    if (d < 10) {
      reached = true;
    }
  }

  void checkNestReached() {
    setFalse(); 
    desired = PVector.sub(target, location); 
    float d = desired.mag();
    if (d < 10) {
      antColor = colorWithoutFood;  
      reached = true;
      near = false;
    }
  }

  void checkNearNest() {
    setFalse(); 
    if (nearNest(location.x, location.y)) {
      target = new PVector(nestX, nestY);
      near = true;
    }
  }

  void dropPhero() {
    int steps = 60;
    if (gathered)
      steps = 30;
    if ((int) movingDistance%steps == 0 && !inNest(location.x, location.y)) {
      PVector pheroLoc = new PVector(location.x + random(-2, 2), location.y + random(-2, 2));
      Pheromon p = new Pheromon(pheroLoc.x, pheroLoc.y);
      pheroDrops.add(p);
      if (pheroDrops.size() > 1000) {
        pheroDrops.remove(0);
      }
    }
  }

  void deliverFood(Food f) {  
    nest.store(f);
    gathered = false;
  }

  void updateFood() {
    for (Food f : foodSite) {
      if (f.x == target.x && f.y == target.y) {
        foodSite.remove(f); 
        break;
      }
    }
  }

  void wiggle() {
    float angle = velocity.heading(); 
    float wiggleAngle = PI/60;
    if (states[1] || states[2]) {
      wiggleAngle = PI/15;
    }
    float len = velocity.mag();
    float r = random(angle - wiggleAngle, angle + wiggleAngle);
    velocity = new PVector(len*cos(r), len*sin(r));
  }

  void turnAround() {
    velocity.mult(-1);
  }

  void inBoundary() {
    if (location.x <= 20 || location.x >= width-20 ) {
      velocity.x *= -1;
    }
    if (location.y <= 20 || location.y >= height-20 ) {
      velocity.y *= -1;
    }
  }

  void setTrue(boolean[] sts, int idx) {
    for (int i = 0; i < sts.length; i++) {
      sts[i] = i == idx ? true : false;
    }
  }

  void setFalse() {
    found = false; 
    reached = false; 
    near = false;
  }

  void separate (Ant[] as) {// adapted from the flocking example
    float desiredSeparation = 25;
    PVector steer = new PVector(0, 0);
    int count = 0;
    for (Ant a : as) {
      float d = calcDistance(location, a.location);
      if ((d > 0) && (d < desiredSeparation)) {
        PVector diff = PVector.sub(location, a.location);
        diff.normalize();
        diff.div(d);        
        steer.add(diff);
        count++;
      }
    }
    if (count > 0) {
      steer.div((float)count);
    }
    if (steer.mag() > 0) {
      steer.setMag(maxSpeed);
      steer.sub(velocity);
      steer.limit(maxForce);
      acceleration.add(steer);
    }
  }

  void show() {// drawing ants
    float angle = velocity.heading() + PI/2;//the ant initially points to the north
    pushMatrix();
    translate(location.x, location.y);
    rotate(angle);
    if (gathered) {// when the ant carrys food
      fill(foodColors[foodGathered.foodColorNum]);
      stroke(0);
      rectMode(CENTER);
      rect(0, -foodGathered.h, foodGathered.w, foodGathered.h);
    }
    fill(antColor);
    stroke(0);
    //head
    beginShape();
    vertex(head[0], head[1]); // first point, y = -4x + 120 ((40, -40) and (25, 20))
    bezierVertex(head[2], head[3], head[4], head[5], head[6], head[7]);// y = -4x + 120 ((40, -40) and (25, 20))
    bezierVertex(head[8], head[9], head[10], head[11], head[12], head[13]);
    endShape();
    //chest
    ellipse(chest[0], chest[1], chest[2], chest[3]);
    //body
    beginShape();
    vertex(body[0], body[1]); // first point, y = -3x +95 ((-20, 155) and (-35, 200))
    bezierVertex(body[2], body[3], body[4], body[5], body[6], body[7]);// y = -4x + 120 ((40, -40) and (25, 20))
    bezierVertex(body[8], body[9], body[10], body[11], body[12], body[13]);
    endShape();
    //antenna
    strokeWeight(1);
    noFill();
    beginShape();
    vertex(antennaL[0], antennaL[1]);
    bezierVertex(antennaL[2], antennaL[3], antennaL[4], antennaL[5], antennaL[6], antennaL[7]);
    endShape();
    beginShape();
    vertex(antennaR[0], antennaR[1]);
    bezierVertex(antennaR[2], antennaR[3], antennaR[4], antennaR[5], antennaR[6], antennaR[7]);
    endShape();
    //left side
    if (frameCount%30 <= 15) {
      beginShape();
      vertex(leg0LU[0], leg0LU[1]);
      bezierVertex(leg0LU[2], leg0LU[3], leg0LU[4], leg0LU[5], leg0LU[6], leg0LU[7]);
      endShape();

      beginShape();
      vertex(leg0RD[0], leg0RD[1]);
      bezierVertex(leg0RD[2], leg0RD[3], leg0RD[4], leg0RD[5], leg0RD[6], leg0RD[7]);
      endShape();

      beginShape();
      vertex(leg1LD[0], leg1LD[1]);
      bezierVertex(leg1LD[2], leg1LD[3], leg1LD[4], leg1LD[5], leg1LD[6], leg1LD[7]);
      endShape();

      beginShape();
      vertex(leg1RU[0], leg1RU[1]);
      bezierVertex(leg1RU[2], leg1RU[3], leg1RU[4], leg1RU[5], leg1RU[6], leg1RU[7]);
      endShape();

      beginShape();
      vertex(leg2LU[0], leg2LU[1]);
      bezierVertex(leg2LU[2], leg2LU[3], leg2LU[4], leg2LU[5], leg2LU[6], leg2LU[7]);
      endShape();

      beginShape();
      vertex(leg2RD[0], leg2RD[1]);
      bezierVertex(leg2RD[2], leg2RD[3], leg2RD[4], leg2RD[5], leg2RD[6], leg2RD[7]);
      endShape();
    } else {
      beginShape();
      vertex(leg0LD[0], leg0LD[1]);
      bezierVertex(leg0LD[2], leg0LD[3], leg0LD[4], leg0LD[5], leg0LD[6], leg0LD[7]);
      endShape();

      beginShape();
      vertex(leg0RU[0], leg0RU[1]);
      bezierVertex(leg0RU[2], leg0RU[3], leg0RU[4], leg0RU[5], leg0RU[6], leg0RU[7]);
      endShape();

      beginShape();
      vertex(leg1LU[0], leg1LU[1]);
      bezierVertex(leg1LU[2], leg1LU[3], leg1LU[4], leg1LU[5], leg1LU[6], leg1LU[7]);
      endShape();

      beginShape();
      vertex(leg1RD[0], leg1RD[1]);
      bezierVertex(leg1RD[2], leg1RD[3], leg1RD[4], leg1RD[5], leg1RD[6], leg1RD[7]);
      endShape();

      beginShape();
      vertex(leg2LD[0], leg2LD[1]);
      bezierVertex(leg2LD[2], leg2LD[3], leg2LD[4], leg2LD[5], leg2LD[6], leg2LD[7]);
      endShape();

      beginShape();
      vertex(leg2RU[0], leg2RU[1]);
      bezierVertex(leg2RU[2], leg2RU[3], leg2RU[4], leg2RU[5], leg2RU[6], leg2RU[7]);
      endShape();
    }
    popMatrix();
  }

  void changeAntSize() {
    for (int i = 0; i < 14; i++) {
      head[i] *= antSize;
      body[i] *= antSize;
    }
    for (int i = 0; i < 4; i++) {
      chest[i] *= antSize;
    }
    for (int i = 0; i < 8; i++) {
      antennaL[i] *= antSize;
      antennaR[i] *= antSize;
      leg0LU[i] *= antSize;
      leg0LD[i] *= antSize;
      leg0RU[i] *= antSize;
      leg0RD[i] *= antSize;
      leg1LU[i] *= antSize;
      leg1LD[i] *= antSize;
      leg1RU[i] *= antSize;
      leg1RD[i] *= antSize;
      leg2LU[i] *= antSize;
      leg2LD[i] *= antSize;
      leg2RU[i] *= antSize;
      leg2RD[i] *= antSize;
    }
  }
}
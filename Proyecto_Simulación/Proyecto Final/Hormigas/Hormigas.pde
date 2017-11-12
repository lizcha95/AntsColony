Ant [] ants;
int numAnts = 20;
float antSize = 0.09;

ArrayList<Food> foodSite;
int numFood = 20;
int totalNumFood;
int maxFoodSize = 6;
int minFoodSize = 2;
color[] foodColors = new color[10];
int foodColor = 0;

ArrayList<Pheromon> pheroDrops;
float evaporationRate = 0.18;

Nest nest;
float nestX, nestY;
float nestWidth = 500;
float nestHeight = 300;

PImage hormiguero;
PImage background;
PImage hoja;
color nestColor = color(200, 200, 200);

boolean pause = false;
boolean unClicked = true;

void setup() {
  size(800, 600);
  background(0);
  nestX = width/2-150;
  nestY = height/2+150;
  
  
  hormiguero = loadImage("hormiguero2.png");
  background = loadImage("degradado.jpg");
  background.resize(width, height);
  hoja = loadImage("hoja1.png");
 
 
  /*for (int i = 0; i < 10; i++) {
    if (i < 5) {
      color c = color(100 + 35*i, 250 - 60*i, 60*i);
      foodColors[i] = c;
    } else {
      color c = color(100 + 35*i, 250 - 60*ri, 60*i);
      foodColors[i] = c;
    }
  }*/
  create();
}

void draw() {
  background(background);
  if (unClicked) {
    textAlign(CENTER, CENTER);
    textSize(24);
    text("click here to start", width/2, height/2);
    textAlign(LEFT, TOP);
    textSize(14);
    text("click to provide food", 10, 15);
    text("press 'r' or 'R' to restart", 10, 35);
    text("press spacebar to pause and resume", 10, 55);
  } else {
    if (!pause) {
      //fill(250, 190, 120);
      //fill(180, 250, 150);
      //rectMode(CORNER);
      //rect(0, 0, width, height);
      nest.run();
      for (Food f : foodSite) {
        f.show();
      }
      for (Ant a : ants) {
        a.run();
      }
      for (Pheromon p : pheroDrops) {
        p.show();
      }
      updatePhero();
    }
    
  }
}

void create() {
  nest = new Nest();
  foodSite = new ArrayList<Food>(); //Click mouse to create food
  ants = new Ant[numAnts];
  for (int i = 0; i < ants.length; i++) {
    Ant a = new Ant(nestX, nestY);
    a.changeAntSize();
    ants[i]= a;
  }
  pheroDrops = new ArrayList<Pheromon>();
}

void provideFood(float locX, float locY) {
  if (!inNest(locX, locY)) {
    for (int i = 0; i < numFood; i++) {
      float rx = random(locX - 15, locX + 15);
      float ry = random(locY - 15, locY + 15);
      float w = random(minFoodSize, maxFoodSize);
      float h = random(minFoodSize, maxFoodSize);
      Food f = new Food(rx, ry, w, h, foodColor);
      foodSite.add(f);
    }
    foodColor++;
  }
  totalNumFood += numFood;
}

boolean inNest(float locX, float locY) {
  float x0 = nestX - nestWidth/2;
  float x1 = nestX + nestWidth/2;
  float y0 = nestY - nestHeight/2;
  float y1 = nestY + nestHeight/2;

  if (locX >= x0 && locX <= x1 && locY >= y0 && locY <= y1) 
    return true;
  else 
  return false;
}

boolean nearNest(float locX, float locY) {
  PVector l = new PVector(nestX, nestY);
  PVector loc = new PVector(locX, locY);
  float d = calcDistance(loc, l);
  if (d < 200) 
    return true;
  else
    return false;
}

void updatePhero() {
  for (int i = pheroDrops.size() - 1; i >= 0; i--) {
    Pheromon p = pheroDrops.get(i);
    if (p.evaporation >= 255) {
      pheroDrops.remove(p);
    }
  }
}


float calcDistance(PVector a, PVector b) { // for fast calculation of distance
  float d = abs(a.x - b.x) + abs(a.y - b.y);
  return d;
}

void mousePressed() {
  if (!unClicked && totalNumFood  < nest.rows*nest.cols) {
    provideFood(mouseX, mouseY);
  }
}

void mouseClicked() {
  if (inNest(mouseX, mouseY))
    unClicked = false;
}

void keyPressed() {
  if (key=='r' || key == 'R') {//restart
    pause = false;
    foodSite = null;
    ants = null;
    for (int j = 0; j < nest.cols-1; j++) {
      for (int i = 0; i < nest.rows-1; i++) {
        nest.storages[i][j] = null;
      }
    }
    pheroDrops = null;
    create();
  }
  if (key==' ') { // pause/resume
    pause = !pause;
  }
}
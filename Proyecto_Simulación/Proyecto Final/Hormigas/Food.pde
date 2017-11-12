class Food {
  float x, y, w, h;
  boolean spotted;
  int foodColorNum;
  Food() {
  }
  Food(float locX, float locY, float foodW, float foodH, int num) {
    x = locX;
    y = locY;
    w = foodW;
    h = foodH;
    foodColorNum = num;
    spotted = false;
  }

  void show() {
    stroke(0);
    fill(foodColors[foodColorNum]);
    rectMode(CENTER);
    rect(x, y, w, h);
    
    imageMode(CENTER);
    image(hoja,x,y,50,40);
  }
}
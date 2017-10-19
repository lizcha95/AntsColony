class Comida {
  float posx;
  float posy;
  float width_food;
  float height_food;
  //boolean spotted;
  //int foodColorNum;
  
  Comida(float posx, float posy, float width_food, float height_food) {
   this.posx = posx;
   this.posy = posy;
   this.width_food = width_food;
   this. height_food = height_food;
    //foodColorNum = num;
    //spotted = false;
  }

  void display() {
    stroke(3);
    fill(255,0,0);
    //rectMode(CENTER);
    rect(posx, posy, width_food, height_food);
  }
}
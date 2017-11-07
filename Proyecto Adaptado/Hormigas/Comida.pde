class Comida {
  float width_food;
  float height_food;
  PVector pos;
  
  float mass;
  boolean comida_encontrada;
  
  Comida(){
  }
  
  Comida(float x, float y, float width_food, float height_food) {
   pos = new PVector(x,y);
   this.width_food = width_food;
   this. height_food = height_food;
   mass = random(1.5,2.5);
   comida_encontrada = false;
  }

  void display() {
    stroke(3);
    fill(255,0,0);
    imageMode(CENTER);
    image(hoja,pos.x,pos.y,width_food,height_food);
  }
  
}
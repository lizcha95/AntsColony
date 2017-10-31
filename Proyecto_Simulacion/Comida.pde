class Comida {
  float width_food;
  float height_food;
  PVector pos;
  float mass;
  
  Comida(float posx, float posy, float width_food, float height_food) {
   pos = new PVector(posx,posy);
   this.width_food = width_food;
   this. height_food = height_food;
   mass = random(1.5,2.5);
  }

  void display() {
    stroke(3);
    fill(255,0,0);
    imageMode(CENTER);
    image(hoja,pos.x,pos.y,width_food,height_food);
  }
  
  PVector atraer(Hormiga hormiga) {
    float G = 0.04;
    PVector force = PVector.sub(pos, hormiga.pos);
    float distance = force.magSq();
    distance = constrain(distance, 4, 200);
    force.normalize();
    force.mult(G * hormiga.mass * mass);
    force.div(distance);
    hormiga.applyForce(force);

    
    return force;
  }
  
 
}
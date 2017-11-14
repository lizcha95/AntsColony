import java.util.Iterator;

class Feromona {
  PVector pos; 
  float size, evaporacion;
  color col = color(255, 0, 0);
  float lifeSpan = 255;
  
  Feromona(float posX, float posY) {
    pos = new PVector(posX, posY);
    size = 6;
  }

  void mostrar() {
    actualizarEvaporacion();
    noStroke();
    fill(col, lifeSpan);
    ellipse(pos.x, pos.y, size, size);
  }
  
  void actualizarEvaporacion() {
    lifeSpan -= EVAPORATION_RATE;
  }
  
  boolean isDead() {
    return lifeSpan <= 0;
  }
}
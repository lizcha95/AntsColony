class Feromona {
  PVector pos; 
  float size, evaporacion;
  int nacimiento;
  color col = color(255, 0, 0);

  Feromona() {
  }
  
  Feromona(float posX, float posY) {
    pos = new PVector(posX, posY);
    size = 6;
    nacimiento = frameCount;
  }

  void mostrar() {
    actualizarEvaporacion();
    noStroke();
    fill(col, 255 - evaporacion);
    ellipse(pos.x, pos.y, size, size);
  }
  
  void actualizarEvaporacion() {
    evaporacion = constrain(EVAPORATION_RATE * (frameCount - nacimiento), 0, 255);
  }
}
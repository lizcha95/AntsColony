class Feromona {
  PVector pos; 
  float size, evaporacion;
  int nacimiento;
  color col = color(255, 0, 0);

  Feromona() {
  }
  
  Feromona(float posX, float posY) {
    pos = new PVector(posX, posY);
    size = 5;
    nacimiento = frameCount;
  }

  void mostrar() {
    actualizarEvaporacion();
    noStroke();
    fill(col, 255 - evaporacion);
    ellipse(pos.x, pos.y, size, size);
  }
  
  void actualizarEvaporacion() {
    evaporacion = constrain(evaporationRate * (frameCount - nacimiento), 0, 255);
  }
}
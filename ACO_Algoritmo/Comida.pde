class Comida {
  PVector pos;
  PVector tamanno;
  boolean encontrada;
  
  Comida() {
  }
  
  Comida(float posX, float posY) {
    pos = new PVector(posX, posY);
    tamanno = new PVector(random(2,6),random(2,6));
    encontrada = false;
  }

  void mostrar() {
    stroke(0);
    rectMode(CENTER);
    rect(pos.x, pos.y, tamanno.x, tamanno.y);
    
    imageMode(CENTER);
    image(hoja,pos.x,pos.y,50,40);
  }
}
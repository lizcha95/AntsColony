import java.util.Iterator;


class Feromona {
  PVector pos;
  float size;
  float evaporacion;
  int creacion_feromona;
  color color_Feromona = color(300, 0, 0);


 Feromona(){
 }
 
  Feromona(float x, float y) {
    pos = new PVector(x,y);
    creacion_feromona = frameCount; // Cantidad de frames o feromonas que se han dibujado en la pantalla
    
  }
 

  void display() {
    
    evaporacion = constrain(EVAPORATION_RATE * (frameCount - creacion_feromona), 0, 255); // 
    noStroke();
    fill(color_Feromona, 255 - evaporacion);
  
    ellipse(pos.x, pos.y, 6, 6);
  }
}
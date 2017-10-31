import java.util.Iterator;

class Feromona {
  float posx;
  float posy;
  float size;
  float evaporacion;
  int inicio_feromona;
  public float evaporationRate = 0.70;
  color color_Feromona = color(300, 0, 0);

 
  Feromona(float posx, float posy) {
    this.posx = posx;
    this.posy = posy;
    inicio_feromona = frameCount;
  }
  
  /*void updateFeromona(ArrayList<Feromona> feromonas) {
  for (int i = feromonas.size() - 1; i >= 0; i--) {
    Feromona p = feromonas.get(i);
    if (p.evaporacion >= 255) {
      feromonas.remove(p);
    
    }
  }
}*/

  void display() {
    
    evaporacion = constrain(evaporationRate * (frameCount - inicio_feromona), 0, 255);
    noStroke();
    fill(color_Feromona, 255 - evaporacion);
  
    ellipse(posx, posy, 6, 6);
  }
}
class Feromona {
  float posx;
  float posy;
  float size;
  float evaporation;
  int birthDate;
  float evaporationRate = 0.18;
  color pheroColor = color(0, 0, 200);

 
  Feromona(float posx, float posy) {
    this.posx = posx;
    this.posy = posy;
    birthDate = frameCount;
  }
  
  void updateFeromona(ArrayList<Feromona> feromonas) {
  for (int i = feromonas.size() - 1; i >= 0; i--) {
    Feromona p = feromonas.get(i);
    if (p.evaporation >= 255) {
      feromonas.remove(p);
    }
  }
}

  void display() {
    evaporation = constrain(evaporationRate * (frameCount - birthDate), 0, 255);
    noStroke();
    fill(pheroColor, 255 - evaporation);
    ellipse(posx, posy, 6, 6);
  }
}
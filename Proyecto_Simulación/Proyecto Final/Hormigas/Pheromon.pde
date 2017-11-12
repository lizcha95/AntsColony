class Pheromon {
  float x, y, size, evaporation;
  int birthDate;
  color pheroColor = color(255, 0, 0);

  Pheromon() {
  }
  Pheromon(float locX, float locY) {
    x = locX;
    y = locY;
    size = 5;
    birthDate = frameCount;
  }

  void show() {
    evaporation = constrain(evaporationRate * (frameCount - birthDate), 0, 255);
    noStroke();
    fill(pheroColor, 255 - evaporation);
    ellipse(x, y, size, size);
  }
}
class Nido {
  int almacenamiento = 4;
  int filas;
  int columnas;
  float posx;
  float posy;
  float width_nido;
  float height_nido;
  
  Nido(float width_nido, float height_nido, float posx, float posy) {
    this.width_nido = width_nido;
    this.height_nido = height_nido;
    this.posx = posx;
    this.posy = posy;
    
    this.filas = (int) height_nido/almacenamiento; 
    this.columnas = (int) width_nido/almacenamiento;
  }
  void run() {
    display(); 
  
  }

  void display() {
    stroke(0);
    fill(128);
    imageMode(CENTER);
    image(hormiguero,posx,posy);
  }
 
  }
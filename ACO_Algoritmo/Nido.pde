class Nido {
  PVector tamanno, pos;
  int tamannoAlmacenamiento, filas, columnas;
  Comida[][] almacenamiento;
  int[] disponible;

  Nido(float posX, float posY, float nidoW, float nidoH) {
    pos = new PVector(posX, posY);
    tamanno = new PVector(nidoW, nidoH);
    tamannoAlmacenamiento = 4;
    filas = (int) nidoW/tamannoAlmacenamiento; 
    columnas = (int) nidoH/tamannoAlmacenamiento;
    almacenamiento = new Comida[filas][columnas];
    disponible = new int[2];
    disponible[0] = 0;
    disponible[1] = 0;
  }

  void run() {
    mostrarNido(); 
    mostrarAlmacenamiento();
  }

  void mostrarNido() {
    imageMode(CENTER);
    image(hormiguero, pos.x, pos.y, tamanno.x, tamanno.y);
  }

  void mostrarAlmacenamiento() {
    for (int j = 0; j < columnas-1; j++) {
      for (int i = 0; i < filas-1; i++) {
        if (almacenamiento[i][j] != null) {
          Comida f = almacenamiento[i][j];
          fill(0, 255, 0);
          rectMode(CORNER);
          rect(f.pos.x, f.pos.y, f.tamanno.x, f.tamanno.y);
        }
      }
    }
  }

  void almacenar(Comida comida) {
    if (almacenamiento[0][0] == null) {
      comida.pos.x = pos.x - tamanno.x/2 +2;
      comida.pos.y = pos.y + tamanno.y/2 - tamannoAlmacenamiento -2; 
      almacenamiento[0][0] = comida;
      disponible[0] = 0;
      disponible[1] = 1;
    } else {
      comida.pos.x = pos.x - tamanno.x/2 + tamannoAlmacenamiento * disponible[1] +2;
      comida.pos.y = pos.y + tamanno.y/2 - tamannoAlmacenamiento * disponible[0] - tamannoAlmacenamiento -2;
      almacenamiento[disponible[0]][disponible[1]] = comida;
      disponible[1]++;
      if (disponible[1] == columnas-1 ) {
        disponible[0]++;
        disponible[1] = 0;
      }
    }
  }

  boolean dentroNido(float posX, float posY) {
    float x0 = pos.x - tamanno.x/2;
    float x1 = pos.x + tamanno.x/2;
    float y0 = pos.y - tamanno.y/2;
    float y1 = pos.y + tamanno.y/2;

    if (posX >= x0 && posX <= x1 && posY >= y0 && posY <= y1) 
      return true;
    else 
    return false;
  }

  boolean cercaNido(float posX, float posY) {
    float distancia = abs(posX - pos.x) + abs(posY - pos.y);
    if (distancia < 200) 
      return true;
    else
      return false;
  }
}
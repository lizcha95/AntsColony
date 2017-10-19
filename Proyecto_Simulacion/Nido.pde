class Nido {
  int almacenamiento = 4;
  int filas;
  int columnas;
  float posx;
  float posy;
  float width_nido;
  float height_nido;
  
  //Food[][] storages;
  //int[] unoccupied;
  
  
  Nido(float width_nido, float height_nido, float posx, float posy) {
    this.width_nido = width_nido;
    this.height_nido = height_nido;
    this.posx = posx;
    this.posy = posy;
    
    this.filas = (int) height_nido/almacenamiento; 
    this.columnas = (int) width_nido/almacenamiento;
    /*storages = new Food[rows][cols];
    unoccupied = new int[2];
    unoccupied[0] = 0;
    unoccupied[1] = 0;*/
  }
  void run() {
    show(); 
   // showStorages();
  }

  void show() {
    stroke(0);
    fill(128);
    //rectMode(CENTER);
    //rect(posx, posy, width_nido, height_nido);
    imageMode(CENTER);
    image(hormiguero,posx,posy);
  }
  

  /*void showStorages() {
    for (int j = 0; j < cols-1; j++) {
      for (int i = 0; i < rows-1; i++) {
        if (storages[i][j] != null) {
          Food f = storages[i][j];
          fill(foodColors[f.foodColorNum]);
          rectMode(CORNER);
          rect(f.x, f.y, f.w, f.h);
        }
      }
    }
  }*/

  /*void store(Food f) {
    if (storages[0][0] == null) {
      f.x = nestX - nestWidth/2 +2;
      f.y = nestY + nestHeight/2 - storageSize -2; 
      storages[0][0] = f;
      unoccupied[0] = 0;
      unoccupied[1] = 1;
    } else {
      f.x = nestX - nestWidth/2 + storageSize*unoccupied[1] +2;
      f.y = nestY + nestHeight/2 - storageSize*unoccupied[0] - storageSize -2;
      storages[unoccupied[0]][unoccupied[1]] = f;
      unoccupied[1]++;
      if (unoccupied[1] == cols-1 ) {
        unoccupied[0]++;
        unoccupied[1] = 0;
      }
    }
  }*/
  }
class Nest {
  int storageSize, rows, cols;
  Food[][] storages;
  int[] unoccupied;
  Nest() {
    storageSize = 4;
    rows = (int) nestHeight/storageSize; 
    cols = (int) nestWidth/storageSize;
    storages = new Food[rows][cols];
    unoccupied = new int[2];
    unoccupied[0] = 0;
    unoccupied[1] = 0;
  }

  void run() {
    show(); 
    showStorages();
  }

  void show() {
    stroke(0);
    fill(nestColor);
    //rectMode(CENTER);
    //rect(nestX, nestY, nestWidth, nestHeight);
    
    imageMode(CENTER);
    image(hormiguero,nestX,nestY,nestWidth,nestHeight);
  }

  void showStorages() {
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
  }

  void store(Food f) {
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
  }
}
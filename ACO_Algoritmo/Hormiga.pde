class Hormiga {
  boolean[] states = new boolean[6];
  PVector target;
  PVector pos; 
  PVector velocity = new PVector(cos(random(TWO_PI)), sin(random(TWO_PI)));
  PVector acceleration  = new PVector(0, 0);
  PVector desired;

  color colorWithoutFood = color(20, 0, 0);
  color colorWithFood = color(25, 25, 112);
  color antColor = colorWithoutFood;
  float maxSpeed = 2.5;
  float maxForce = 0.4;
  float movingDistance; // needed for determining phero dropping interval

  int numWandering = 0;
  int maxNumWandering = 0; // an ant randomly changes moving direcions after a certain number of steps

  Comida comidaRecolectada;
  boolean encontrada; // food or phero found
  boolean reached; // food or phero reached
  boolean gathered; // food gathered
  boolean cerca; // near the nest

  //Dibujar las hormigas
  //head, chest, body
  float[] head = {-25, 20, -40, -40, 40, -40, 25, 20, 10, 80, -10, 80, -25, 20};
  float[] chest = {0, 115, 20, 108};
  float[] body = {-35, 200, -20, 155, 20, 155, 35, 200, 80, 335, -80, 335, -35, 200};
  //left side
  float[] antennaL = {-25, -10, -70, -5, -75, -40, -80, -50};
  float[] leg0LU = {-8, 75, -20, 75, -40, 75, -75, 55};
  float[] leg0LD = {-8, 75, -20, 75, -40, 75, -80, 70};
  float[] leg1LU = {-11, 100, -15, 100, -85, 100, -120, 80};
  float[] leg1LD = {-11, 100, -15, 100, -85, 100, -130, 140};
  float[] leg2LU = {-8, 150, -20, 150, -150, 180, -180, 220};
  float[] leg2LD = {-8, 150, -20, 170, -140, 200, -120, 340};
  //right side
  float[] antennaR = {25, -10, 70, -5, 75, -40, 80, -50};
  float[] leg0RU = {8, 75, 20, 75, 40, 75, 75, 55};
  float[] leg0RD = {8, 75, 20, 75, 40, 75, 80, 70};
  float[] leg1RU = {11, 100, 15, 100, 85, 100, 120, 80};
  float[] leg1RD = {11, 100, 15, 100, 85, 100, 130, 140};
  float[] leg2RU = {8, 150, 20, 150, 150, 180, 180, 220};
  float[] leg2RD = {8, 150, 20, 170, 140, 200, 120, 340};

  Hormiga(float posX, float posY) {
    states[0] = true;
    states[1] = false;
    states[2] = false;
    states[3] = false;
    states[4] = false;
    states[5] = false;
    pos = new PVector(posX, posY);
  }

  void dibujarHormiga() {// drawing ants
    float angle = velocity.heading() + PI/2;//the ant initially points to the north
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(angle);
    if (gathered) {// when the ant carrys food
      imageMode(CENTER);
      image(hoja,0, -comidaRecolectada.tamanno.y,80,70);
    }
    fill(antColor);
    stroke(0);
    //head
    beginShape();
    vertex(head[0], head[1]); // first point, y = -4x + 120 ((40, -40) and (25, 20))
    bezierVertex(head[2], head[3], head[4], head[5], head[6], head[7]);// y = -4x + 120 ((40, -40) and (25, 20))
    bezierVertex(head[8], head[9], head[10], head[11], head[12], head[13]);
    endShape();
    //chest
    ellipse(chest[0], chest[1], chest[2], chest[3]);
    //body
    beginShape();
    vertex(body[0], body[1]); // first point, y = -3x +95 ((-20, 155) and (-35, 200))
    bezierVertex(body[2], body[3], body[4], body[5], body[6], body[7]);// y = -4x + 120 ((40, -40) and (25, 20))
    bezierVertex(body[8], body[9], body[10], body[11], body[12], body[13]);
    endShape();
    //antenna
    strokeWeight(1);
    noFill();
    beginShape();
    vertex(antennaL[0], antennaL[1]);
    bezierVertex(antennaL[2], antennaL[3], antennaL[4], antennaL[5], antennaL[6], antennaL[7]);
    endShape();
    beginShape();
    vertex(antennaR[0], antennaR[1]);
    bezierVertex(antennaR[2], antennaR[3], antennaR[4], antennaR[5], antennaR[6], antennaR[7]);
    endShape();
    //left side
    if (frameCount%30 <= 15) {
      beginShape();
      vertex(leg0LU[0], leg0LU[1]);
      bezierVertex(leg0LU[2], leg0LU[3], leg0LU[4], leg0LU[5], leg0LU[6], leg0LU[7]);
      endShape();

      beginShape();
      vertex(leg0RD[0], leg0RD[1]);
      bezierVertex(leg0RD[2], leg0RD[3], leg0RD[4], leg0RD[5], leg0RD[6], leg0RD[7]);
      endShape();

      beginShape();
      vertex(leg1LD[0], leg1LD[1]);
      bezierVertex(leg1LD[2], leg1LD[3], leg1LD[4], leg1LD[5], leg1LD[6], leg1LD[7]);
      endShape();

      beginShape();
      vertex(leg1RU[0], leg1RU[1]);
      bezierVertex(leg1RU[2], leg1RU[3], leg1RU[4], leg1RU[5], leg1RU[6], leg1RU[7]);
      endShape();

      beginShape();
      vertex(leg2LU[0], leg2LU[1]);
      bezierVertex(leg2LU[2], leg2LU[3], leg2LU[4], leg2LU[5], leg2LU[6], leg2LU[7]);
      endShape();

      beginShape();
      vertex(leg2RD[0], leg2RD[1]);
      bezierVertex(leg2RD[2], leg2RD[3], leg2RD[4], leg2RD[5], leg2RD[6], leg2RD[7]);
      endShape();
    } else {
      beginShape();
      vertex(leg0LD[0], leg0LD[1]);
      bezierVertex(leg0LD[2], leg0LD[3], leg0LD[4], leg0LD[5], leg0LD[6], leg0LD[7]);
      endShape();

      beginShape();
      vertex(leg0RU[0], leg0RU[1]);
      bezierVertex(leg0RU[2], leg0RU[3], leg0RU[4], leg0RU[5], leg0RU[6], leg0RU[7]);
      endShape();

      beginShape();
      vertex(leg1LU[0], leg1LU[1]);
      bezierVertex(leg1LU[2], leg1LU[3], leg1LU[4], leg1LU[5], leg1LU[6], leg1LU[7]);
      endShape();

      beginShape();
      vertex(leg1RD[0], leg1RD[1]);
      bezierVertex(leg1RD[2], leg1RD[3], leg1RD[4], leg1RD[5], leg1RD[6], leg1RD[7]);
      endShape();

      beginShape();
      vertex(leg2LD[0], leg2LD[1]);
      bezierVertex(leg2LD[2], leg2LD[3], leg2LD[4], leg2LD[5], leg2LD[6], leg2LD[7]);
      endShape();

      beginShape();
      vertex(leg2RU[0], leg2RU[1]);
      bezierVertex(leg2RU[2], leg2RU[3], leg2RU[4], leg2RU[5], leg2RU[6], leg2RU[7]);
      endShape();
    }
    popMatrix();
  }

  void actualizar() {
    velocity.add(acceleration);
    velocity.limit(maxSpeed);

    float angle = velocity.heading(); 
    float wiggleAngle = PI/60;
    if (states[1] || states[2]) {
      wiggleAngle = PI/15;
    }
    float len = velocity.mag();
    float r = random(angle - wiggleAngle, angle + wiggleAngle);
    velocity = new PVector(len*cos(r), len*sin(r));


    pos.add(velocity);
    acceleration.mult(0);
    movingDistance += velocity.mag();

    if (pos.x <= 20 || pos.x >= width-20 ) {
      velocity.x *= -1;
    }
    if (pos.y <= 20 || pos.y >= height-20 ) {
      velocity.y *= -1;
    }
  }

  void cambiarTamanno() {
    for (int i = 0; i < 14; i++) {
      head[i] *= antSize;
      body[i] *= antSize;
    }
    for (int i = 0; i < 4; i++) {
      chest[i] *= antSize;
    }
    for (int i = 0; i < 8; i++) {
      antennaL[i] *= antSize;
      antennaR[i] *= antSize;
      leg0LU[i] *= antSize;
      leg0LD[i] *= antSize;
      leg0RU[i] *= antSize;
      leg0RD[i] *= antSize;
      leg1LU[i] *= antSize;
      leg1LD[i] *= antSize;
      leg1RU[i] *= antSize;
      leg1RD[i] *= antSize;
      leg2LU[i] *= antSize;
      leg2LD[i] *= antSize;
      leg2RU[i] *= antSize;
      leg2RD[i] *= antSize;
    }
  }

  void run() {
    dejarFeromona();
    separar(hormigas); // evita que las hormigas choquen entre ellas
    if (states[0]) {
      deambular(); 
      float r = random(1);
      if (r > 0.3) {
        if (!(nido.dentroNido(pos.x, pos.y))) {// si la hormiga esta fuera del nido
          if (!gathered) {
            buscarComida();
            if (encontrada) {
              setTrue(states, 1);
            } else { 
              buscarFeromona();
              if (encontrada) { 
                setTrue(states, 3);
              }
            }
          } else {
            buscarFeromona(); 
            if (encontrada) { 
              setTrue(states, 3);
            }
          }
        }
      }
    } else if (states[1]) { 
      irComida();
      if (reached) { 
        setTrue(states, 2);
      }
    } else if (states[2]) { 
      antColor = colorWithFood; 
      verificarCercaniaNido();
      if (cerca) {
        irNido();
        if (reached) { 
          setTrue(states, 5);
        }
      } else {
        girar();
        buscarFeromona(); 
        if (encontrada) { 
          setTrue(states, 3);
        } else { 
          setTrue(states, 0);
        }
      }
    } else if (states[3]) { 
      irFeromona(); 
      if (reached) {
        setTrue(states, 4);
      }
    } else if (states[4]) { 
      if (gathered) {// if the ant has food
        verificarCercaniaNido();
        if (cerca) {
          irNido(); 
          if (reached) {
            setTrue(states, 5);
          }
        } else { 
          buscarFeromona(); 
          if (encontrada) { 
            setTrue(states, 3);
          } else { 
            setTrue(states, 0);
          }
        }
      } else {
        buscarComida(); 
        if (encontrada) {
          setTrue(states, 1);
        } else {
          buscarFeromona(); 
          if (encontrada) { 
            setTrue(states, 3);
          }
        }
      }
    } else if (states[5]) {
      entregarComida(comidaRecolectada); 
      girar();
      setTrue(states, 0);
    }
    actualizar(); 
    dibujarHormiga();
  }

  void dejarFeromona() {
    int steps = 70;
    if (gathered)
      steps = 40;
    if ((int) movingDistance%steps == 0 && !nido.dentroNido(pos.x, pos.y)) {
      PVector posFero = new PVector(pos.x + random(-2, 2), pos.y + random(-2, 2));
      Feromona p = new Feromona(posFero.x, posFero.y);
      feromonas.add(p);
      if (feromonas.size() > 1000) {
        feromonas.remove(0);
      }
    }
  }

  void separar (ArrayList<Hormiga> hormigasObt) {// adapted from the flocking example
    float desiredSeparation = 25;
    PVector direccion = new PVector(0, 0);
    int total = 0;
    for (Hormiga a : hormigasObt) {
      float distancia = abs(pos.x - a.pos.x) + abs(pos.y - a.pos.y);
      if ((distancia > 0) && (distancia < desiredSeparation)) {
        PVector diff = PVector.sub(pos, a.pos);
        diff.normalize();
        diff.div(distancia);        
        direccion.add(diff);
        total++;
      }
    }
    if (total > 0) {
      direccion.div((float)total);
    }
    if (direccion.mag() > 0) {
      direccion.setMag(maxSpeed);
      direccion.sub(velocity);
      direccion.limit(maxForce);
      acceleration.add(direccion);
    }
  }

  void deambular() {
    maxNumWandering = (int) random(300, 500);
    numWandering++;
    if (numWandering >= maxNumWandering) { 
      target = PVector.random2D(); 
      target.mult(1500);
      PVector steer = seek();
      acceleration.add(steer);
      numWandering = 0;
    }
  }

  PVector seek() {
    PVector desired = PVector.sub(target, pos);
    desired.setMag(maxSpeed);
    PVector steering = PVector.sub(desired, velocity);
    steering.limit(maxForce);
    return steering;
  }

  void buscarComida() {
    setFalse(); // set found, reached and near to false
    Comida comidaEncontrada = new Comida(-1, -1);
    for (Comida comida : listaComida) {
      if (!comida.encontrada) {
        PVector fLoc = new PVector(comida.pos.x, comida.pos.y);
        if (PVector.dist(fLoc, pos) < 80 && PVector.angleBetween(velocity, PVector.sub(fLoc, pos)) <= PI/2) {
          comidaEncontrada = comida;
          break;
        }
      }
    }
    if (comidaEncontrada.pos.x != -1 && comidaEncontrada.pos.y != -1) { // the ant finds food
      comidaEncontrada.encontrada = true; // other ants are prevented from gathering the food
      comidaRecolectada = comidaEncontrada; // 
      target = new PVector(comidaEncontrada.pos.x, comidaEncontrada.pos.y);
      encontrada = true;
    }
  }

  void setFalse() {
    encontrada = false; 
    reached = false; 
    cerca = false;
  }

  void setTrue(boolean[] sts, int idx) {
    for (int i = 0; i < sts.length; i++) {
      sts[i] = i == idx ? true : false;
    }
  }

  void buscarFeromona() {
    setFalse(); 
    Feromona feromonaEncontrada = new Feromona(-1, -1);
    
    for (Feromona feromona : feromonas) {
      if (feromona.evaporacion < 150) {
        PVector pLoc = new PVector(feromona.pos.x, feromona.pos.y);
        if (PVector.dist(pLoc, pos)  < 100 && PVector.angleBetween(velocity, PVector.sub(pLoc, pos)) <= PI/3) {//
          feromonaEncontrada = feromona;
          break;
        }
      }
    }
    
    if (feromonaEncontrada.pos.x != -1 && feromonaEncontrada.pos.y != -1) { // the ant finds food
      target = new PVector(feromonaEncontrada.pos.x, feromonaEncontrada.pos.y); 
      encontrada = true;
    } else {
      setTrue(states, 0);
    }
  }

  void irComida() {
    PVector steer = seek();
    acceleration.add(steer);
    verificarComidaAlcanzada();
  }

  void irFeromona() {
    PVector steer = seek();
    acceleration.add(steer);
    verificarFeromonaAlcanzada();
  }

  void irNido() {
    PVector steer = seek();
    acceleration.add(steer);
    verificarNidoAlcanzado();
  }

  void verificarComidaAlcanzada() {
    setFalse(); 
    desired = PVector.sub(target, pos); 
    float d = desired.mag();
    if (d < 10) {
      antColor = colorWithFood; 
      gathered = true;
      reached = true;
      actualizarComida(); // food gathered is removed from a food site
    }
  }

  void verificarFeromonaAlcanzada() {
    setFalse(); 
    desired = PVector.sub(target, pos); 
    float d = desired.mag();
    if (d < 10) {
      reached = true;
    }
  }

  void verificarNidoAlcanzado() {
    setFalse(); 
    desired = PVector.sub(target, pos); 
    float d = desired.mag();
    if (d < 10) {
      antColor = colorWithoutFood;  
      reached = true;
      cerca = false;
    }
  }

  void verificarCercaniaNido() {
    setFalse(); 
    if (nido.cercaNido(pos.x, pos.y)) {
      target = new PVector(nido.pos.x, nido.pos.y);
      cerca = true;
    }
  }

  void entregarComida(Comida comida) {  
    nido.almacenar(comida);
    gathered = false;
  }

  void actualizarComida() {
    for (Comida comida : listaComida) {
      if (comida.pos.x == target.x && comida.pos.y == target.y) {
        listaComida.remove(comida); 
        break;
      }
    }
  }

  void girar() {
    velocity.mult(-1);
  }
}
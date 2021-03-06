class Hormiga {
  boolean[] states = new boolean[6];
  PVector target;
  PVector pos; 
  PVector vel;
  PVector acc;
  PVector desired;
  float maxSpeed;
  float maxForce;
  float distanciaMovimiento; 
  float wandertheta;
  float mass;

  Comida comidaRecolectada;
  boolean encontrada; 
  boolean reached; 
  boolean gathered; 
  boolean cerca; 
  
  int numWandering = 0;
  int maxNumWandering = 0; 

  //Dibujar las hormigas
  //Posiciones del cuerpo de la hormiga
  // cabeza, cuerpo, pecho
  float[] head = {-25, 20, -40, -40, 40, -40, 25, 20, 10, 80, -10, 80, -25, 20};
  float[] chest = {0, 115, 20, 108};
  float[] body = {-35, 200, -20, 155, 20, 155, 35, 200, 80, 335, -80, 335, -35, 200};

  //lado izquierdo
  float[] antennaL = {-25, -10, -70, -5, -75, -40, -80, -50};
  float[] leg0LU = {-8, 75, -20, 75, -40, 75, -75, 55};
  float[] leg0LD = {-8, 75, -20, 75, -40, 75, -80, 70};
  float[] leg1LU = {-11, 100, -15, 100, -85, 100, -120, 80};
  float[] leg1LD = {-11, 100, -15, 100, -85, 100, -130, 140};
  float[] leg2LU = {-8, 150, -20, 150, -150, 180, -180, 220};
  float[] leg2LD = {-8, 150, -20, 170, -140, 200, -120, 340};
  //lado derecho
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
    maxSpeed = random(2, 3);
    maxForce = random(0.04, 0.1);
    wandertheta = 0;
    mass = random(1.5, 2.5);
    vel = PVector.random2D();
    acc  = new PVector(0, 0);
  }

  void dibujarHormiga() {
    float angle = vel.heading() + PI/2;
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(angle);
    if (gathered) {
      imageMode(CENTER);
      image(hoja, 0, -comidaRecolectada.tamanno.y, 95, 90);
    }
    fill(0);
    stroke(0);
    //cabeza
    beginShape();
    vertex(head[0], head[1]); 
    bezierVertex(head[2], head[3], head[4], head[5], head[6], head[7]);
    bezierVertex(head[8], head[9], head[10], head[11], head[12], head[13]);
    endShape();
    //pecho
    ellipse(chest[0], chest[1], chest[2], chest[3]);
    //cuerpo
    beginShape();
    vertex(body[0], body[1]); 
    bezierVertex(body[2], body[3], body[4], body[5], body[6], body[7]);
    bezierVertex(body[8], body[9], body[10], body[11], body[12], body[13]);
    endShape();
    //antena
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
    //lado izquierdo
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
    vel.add(acc);
    vel.limit(maxSpeed);
    pos.add(vel);
    acc.mult(0);
    distanciaMovimiento += vel.mag();

    if (pos.x <= 20 || pos.x >= width-20 ) {
      vel.x *= -1;
    }
    if (pos.y <= 20 || pos.y >= height-20 ) {
      vel.y *= -1;
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
    dejarFeromona(); //Cuando la hormiga se mueva va a dejar feromonas
    separar(hormigas); // evita que las hormigas choquen entre ellas
    if (states[0]) {
      deambular();  //Si la hormiga no encuentra comida o no hay comida entonces "deambula" o camina por cualquier lado
      float r = random(1);
      if (r > 0.4) {
        if (!(nido.dentroNido(pos.x, pos.y))) {// si la hormiga esta fuera del nido
          if (!gathered) { // si la hormiga no tiene comida, entonces busca comida si hay, sino solo deambula
            buscarComida();
            if (encontrada) { // Si las hormigas encuentran la comida
              setTrue(states, 1);
            } else { 
              buscarFeromona();
              if (encontrada) { // Si las hormigas encuentran una feromona
                setTrue(states, 3);
              }
            }
          } else { //Cuando la hormiga lleva comida, busca feromonas para volver al nido
            buscarFeromona(); 
            if (encontrada) { 
              setTrue(states, 3);
            }
          }
        }
      }
    } else if (states[1]) { //Cuando la hormiga sabe donde está ubicada la comida, entonces se dirige hacia la fuente de comida
      irComida();
      if (reached) { // Si la hormiga agarra la comida
        setTrue(states, 2);
      }
    } else if (states[2]) { // Cuando una hormiga alcanza la comida
      verificarCercaniaNido();
      if (cerca) { // Si la hormiga está cerca del nido, entonces se mueve hacia él.
        irNido();
        if (reached) { //Verifica si la hormiga ya llegó al nido
          setTrue(states, 5);
        }
      } else { //Si la hormiga está lejos del nido se devuelve y sigue buscando comida o feromonas
        girar();
        buscarFeromona(); 
        if (encontrada) { 
          setTrue(states, 3);
        } else { 
          setTrue(states, 0); // continua deambulando hasta encontrar algo
        }
      }
    } else if (states[3]) { // Cuando una hormiga sabe dónde está una feromona
      irFeromona(); //La hormiga va hacia la feromona
      if (reached) { //Cuando la hormiga alcanza la feromona
        setTrue(states, 4);
      }
    } else if (states[4]) { //Cuando la hormiga alcanza la feromona
      if (gathered) { // Si la hormiga tiene comida
        verificarCercaniaNido();
        if (cerca) { // Si la hormiga está cerca del nido, se mueve hacia él
          irNido(); 
          if (reached) { // Verifica si la hormiga llegó al nido
            setTrue(states, 5);
          }
        } else { // Si la hormiga con comida está lejos del nido
          buscarFeromona(); // Sigue buscando las feromonas del camino más corto hacia el nido
          if (encontrada) { 
            setTrue(states, 3);
          } else { 
            setTrue(states, 0);
          }
        }
      } else { // Si la hormiga aún no tiene comida, sigue buscando comida
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
    } else if (states[5]) { // Cuando una hormiga llega al nido, entrega la comida, y se devuelve a buscar más comida
      entregarComida(comidaRecolectada); //Pone la hoja en el hormiguero
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
    if ((int) distanciaMovimiento%steps == 0 && !nido.dentroNido(pos.x, pos.y)) {
      PVector posFero = new PVector(pos.x + random(-2, 2), pos.y + random(-2, 2));
      Feromona p = new Feromona(posFero.x, posFero.y);
      feromonas.add(p);
      if (feromonas.size() > 1000) {
        feromonas.remove(0);
      }
    }
  }

  void separar (ArrayList<Hormiga> hormigasObt) {// Ejemplo de flocking
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
      direccion.sub(vel);
      direccion.limit(maxForce);
      acc.add(direccion);
    }
  }

  void deambular() {
    float wanderR = 15;         // Radius for our "wander circle"
    float wanderD = 30;         // Distance for our "wander circle"
    float change = 0.3;
    wandertheta += random(-change, change);     // Randomly change wander theta

    // Now we have to calculate the new position to steer towards on the wander circle
    PVector circlepos = vel.get();    // Start with velocity
    circlepos.normalize();            // Normalize to get heading
    circlepos.mult(wanderD);          // Multiply by distance
    circlepos.add(pos);               // Make it relative to boid's position

    float h = vel.heading2D();        // We need to know the heading to offset wandertheta

    PVector circleOffSet = new PVector(wanderR*cos(wandertheta+h), wanderR*sin(wandertheta+h));
    target = PVector.add(circlepos, circleOffSet);
    acc.add( seek() );
  }
  
 
 PVector seek() {
    PVector desired = PVector.sub(target, pos);
    desired.setMag(maxSpeed);
    PVector steering = PVector.sub(desired, vel);
    steering.limit(maxForce);
    PVector f = PVector.div(steering, mass);
    return f;
  }

  void buscarComida() {
    setFalse(); 
    Comida comidaEncontrada = new Comida(-1, -1);
    for (Comida comida : listaComida) {
      if (!comida.encontrada) {
        PVector fLoc = new PVector(comida.pos.x, comida.pos.y);
        if (PVector.dist(fLoc, pos) < 80 && PVector.angleBetween(vel, PVector.sub(fLoc, pos)) <= PI/2) {
          comidaEncontrada = comida;
          break;
        }
      }
    }
    if (comidaEncontrada.pos.x != -1 && comidaEncontrada.pos.y != -1) { 
      comidaEncontrada.encontrada = true; 
      comidaRecolectada = comidaEncontrada; 
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
        if (PVector.dist(pLoc, pos)  < 100 && PVector.angleBetween(vel, PVector.sub(pLoc, pos)) <= PI/3) {
          feromonaEncontrada = feromona;
          break;
        }
      }
    }

    if (feromonaEncontrada.pos.x != -1 && feromonaEncontrada.pos.y != -1) { 
      target = new PVector(feromonaEncontrada.pos.x, feromonaEncontrada.pos.y); 
      encontrada = true;
    } else {
      setTrue(states, 0);
    }
  }

  void irComida() {
    PVector steer = seek();
    acc.add(steer);
    verificarComidaAlcanzada();
  }

  void irFeromona() {
    PVector steer = seek();
    acc.add(steer);
    verificarFeromonaAlcanzada();
  }

  void irNido() {
    PVector steer = seek();
    acc.add(steer);
    verificarNidoAlcanzado();
  }

  void verificarComidaAlcanzada() {
    setFalse(); 
    desired = PVector.sub(target, pos); 
    float distancia = desired.mag();
    if (distancia < 10) {
      gathered = true;
      reached = true;
      actualizarComida();
    }
  }

  void verificarFeromonaAlcanzada() {
    setFalse(); 
    desired = PVector.sub(target, pos); 
    float distancia = desired.mag();
    if (distancia < 10) {
      reached = true;
    }
  }

  void verificarNidoAlcanzado() {
    setFalse(); 
    desired = PVector.sub(target, pos); 
    float distancia = desired.mag();
    if (distancia < 10) {
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
    vel.mult(-1);
  }
}
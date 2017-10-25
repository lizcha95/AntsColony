/*
El Código para dibujar las hormigas fue tomado de la siguiente fuente:
 
 https://www.openprocessing.org/sketch/428938
 
 Autor: Jae Cheol Kim
 
 */

class Hormiga {
  float antSize = 0.09;
  float maxSpeed;
  float maxForce;
  float mass;
  float size;
  float separationDistance;
  float separationRatio;
  PVector vel;
  PVector acc;
  PVector pos;
  float wandertheta;


  //Establece los puntos para dibujar las hormigas
  //cabeza, pecho, cuerpo
  float[] cabeza = {-25, 20, -40, -40, 40, -40, 25, 20, 10, 80, -10, 80, -25, 20};
  float[] pecho = {0, 115, 20, 108};
  float[] cuerpo = {-35, 200, -20, 155, 20, 155, 35, 200, 80, 335, -80, 335, -35, 200};
  //Lado izquierdo
  float[] antena_Izq = {-25, -10, -70, -5, -75, -40, -80, -50};
  float[] leg0LU = {-8, 75, -20, 75, -40, 75, -75, 55};
  float[] leg0LD = {-8, 75, -20, 75, -40, 75, -80, 70};
  float[] leg1LU = {-11, 100, -15, 100, -85, 100, -120, 80};
  float[] leg1LD = {-11, 100, -15, 100, -85, 100, -130, 140};
  float[] leg2LU = {-8, 150, -20, 150, -150, 180, -180, 220};
  float[] leg2LD = {-8, 150, -20, 170, -140, 200, -120, 340};
  //Lado derecho
  float[] antena_Der = {25, -10, 70, -5, 75, -40, 80, -50};
  float[] leg0RU = {8, 75, 20, 75, 40, 75, 75, 55};
  float[] leg0RD = {8, 75, 20, 75, 40, 75, 80, 70};
  float[] leg1RU = {11, 100, 15, 100, 85, 100, 120, 80};
  float[] leg1RD = {11, 100, 15, 100, 85, 100, 130, 140};
  float[] leg2RU = {8, 150, 20, 150, 150, 180, 180, 220};
  float[] leg2RD = {8, 150, 20, 170, 140, 200, 120, 340};

  Hormiga(float posx, float posy, PVector vel) {
    pos = new PVector(posx, posy);
    this.vel = vel;
    acc = new PVector (0, 0);
    mass = random(1.5, 2.5);
    size = 10;
    maxSpeed =random(2, 3);
    maxForce = random(0.04, 0.1);
    separationDistance = 10;
    separationRatio = 1;
    wandertheta = 0;
  }

  void update() {
    vel.add(acc);
    vel.limit(maxSpeed);
    pos.add(vel);
    acc.mult(0);
  }

  void applyForce (PVector force) {
    PVector f = PVector.div(force, mass);
    acc.add(f);
  }

  void seek(PVector target) {
    PVector desired = PVector.sub(target, pos);
    desired.setMag(maxSpeed);
    PVector steering = PVector.sub(desired, vel);
    steering.limit(maxForce);
    applyForce(steering);
  }

  void borders() {
    if (pos.x <= 20 || pos.x >= width-20 ) {
      vel.x *= -1;
    }
    if (pos.y <= 20 || pos.y >= height-20 ) {
      vel.y *= -1;
    }
  }



  void display() { //Dibuja las hormigas
    float angle = vel.heading() + PI/2;
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(angle);
    fill(0);
    stroke(3);
    //cabeza
    beginShape();
    vertex(cabeza[0], cabeza[1]); 
    bezierVertex(cabeza[2], cabeza[3], cabeza[4], cabeza[5], cabeza[6], cabeza[7]);
    bezierVertex(cabeza[8], cabeza[9], cabeza[10], cabeza[11], cabeza[12], cabeza[13]);
    endShape();
    //pecho
    ellipse(pecho[0], pecho[1], pecho[2], pecho[3]);
    //body
    beginShape();
    vertex(cuerpo[0], cuerpo[1]); 
    bezierVertex(cuerpo[2], cuerpo[3], cuerpo[4], cuerpo[5], cuerpo[6], cuerpo[7]);
    bezierVertex(cuerpo[8], cuerpo[9], cuerpo[10], cuerpo[11], cuerpo[12], cuerpo[13]);
    endShape();
    //antena
    strokeWeight(1);
    noFill();
    beginShape();
    vertex(antena_Izq[0], antena_Izq[1]);
    bezierVertex(antena_Izq[2], antena_Izq[3], antena_Izq[4], antena_Izq[5], antena_Izq[6], antena_Izq[7]);
    endShape();
    beginShape();
    vertex(antena_Der[0], antena_Der[1]);
    bezierVertex(antena_Der[2], antena_Der[3], antena_Der[4], antena_Der[5], antena_Der[6], antena_Der[7]);
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

  void separar(ArrayList<Hormiga> hormigas) {
    PVector average = new PVector(0, 0);
    int count = 0;
    for (Hormiga h : hormigas) {
      float d = PVector.dist(pos, h.pos);
      if (this != h && d < separationDistance) {
        PVector difference = PVector.sub(pos, h.pos);
        difference.normalize();
        difference.div(d);
        average.add(difference);
        count++;
      }
    }
    if (count > 0) {
      average.div(count);
      average.setMag(separationRatio);
      average.limit(maxForce);
      applyForce(average);
    }
  }


  PVector atraer(Hormiga hormiga) {
    float G = 0.05;
    PVector force = PVector.sub(pos, hormiga.pos);
    float distance = force.magSq();
    distance = constrain(distance, 5, 300);
    force.normalize();
    force.mult(G * hormiga.mass * mass);
    force.div(distance);
    hormiga.applyForce(force);


    return force;
  }

  void cambiar_Tamanio() {
    for (int i = 0; i < 14; i++) {
      cabeza[i] *= 0.08;
      cuerpo[i] *= antSize;
    }
    for (int i = 0; i < 4; i++) {
      pecho[i] *= antSize;
    }
    for (int i = 0; i < 8; i++) {
      antena_Izq[i] *= 0.08;
      antena_Der[i] *= 0.08;
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

  void Aplicar_atraccion() {
    for (Hormiga p : hormigas) {
      for (int i = 0; i < comida.size(); i++) {
        Comida a = comida.get(i);
        PVector forceHormiga = a.atraer(p);
        p.applyForce(forceHormiga);
      }
    }
  }

  //Add movement to the ant
  void wander() {
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
    PVector target = PVector.add(circlepos, circleOffSet);
    seek(target);
  }
 
}
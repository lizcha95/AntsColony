class Hormiga{
  float antSize = 0.09;
  PVector ubicacion;
  PVector velocidad = new PVector(cos(random(TWO_PI)), sin(random(TWO_PI)));
  
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
  
  Hormiga(float posx, float posy){
    ubicacion = new PVector(posx,posy);
    
  }
  
   void display() { //Dibuja las hormigas
    float angle = velocidad.heading() + PI/2;//the ant initially points to the north
    pushMatrix();
    translate(ubicacion.x, ubicacion.y);
    rotate(angle);
   /* if (gathered) {// when the ant carrys food
      fill(foodColors[foodGathered.foodColorNum]);
      stroke(0);
      rectMode(CENTER);
      rect(0, -foodGathered.h, foodGathered.w, foodGathered.h);
    }*/
    //fill(#B25F1B);
    fill(0);
    stroke(3);
    //cabeza
    beginShape();
    vertex(cabeza[0], cabeza[1]); // first point, y = -4x + 120 ((40, -40) and (25, 20))
    bezierVertex(cabeza[2], cabeza[3], cabeza[4], cabeza[5], cabeza[6], cabeza[7]);// y = -4x + 120 ((40, -40) and (25, 20))
    bezierVertex(cabeza[8], cabeza[9], cabeza[10], cabeza[11], cabeza[12], cabeza[13]);
    endShape();
    //pecho
    ellipse(pecho[0], pecho[1], pecho[2], pecho[3]);
    //body
    beginShape();
    vertex(cuerpo[0], cuerpo[1]); // first point, y = -3x +95 ((-20, 155) and (-35, 200))
    bezierVertex(cuerpo[2], cuerpo[3], cuerpo[4], cuerpo[5], cuerpo[6], cuerpo[7]);// y = -4x + 120 ((40, -40) and (25, 20))
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
    bezierVertex(antena_Der[2],antena_Der[3], antena_Der[4], antena_Der[5],antena_Der[6], antena_Der[7]);
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

}
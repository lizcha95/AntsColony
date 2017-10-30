/*********************************************************
 
 Instituto Tecnológico de Costa Rica
 Simulación de Sistemas Naturales
 II Semestre 2017
 Proyecto: Colonia de Hormigas
 
 Prof. Mauricio Avilés Cisneros
 
 Melissa Molina Corrales
 Yasiell Vallejos Gómez
 Liza Chaves Carranza
 
 *********************************************************/

ArrayList<Hormiga> hormigas;
ArrayList<Comida> comida;
ArrayList<Feromona> feromonas;
Feromona feromona;


Nido nido;
float nido_posx;
float nido_posy;
float width_nido = 680;
float height_nido = 480;
PImage cesped;
PImage hormiguero;
boolean debug = true;

void setup() {
  size(800, 600);
  //fullScreen();
  background(0);

  // Posicion del nido 
  nido_posx = width-200;
  nido_posy = height-130;
  hormigas = new ArrayList();
  comida = new ArrayList();
  feromonas = new ArrayList();
  cesped = loadImage("degradado.jpg");
  cesped.resize(width, height);
  hormiguero = loadImage("hormiguero.png");
  //hormiguero.resize(200,200);

  nido = new Nido(width_nido, height_nido, nido_posx, nido_posy); //Se crea el nido

  //Se agregan las hormigas al arreglo
  for (int i = 0; i<20; i++) {
    Hormiga hormiga = new Hormiga(nido_posx, nido_posy, PVector.random2D());
    hormiga.cambiar_Tamanio();
    hormigas.add(hormiga);
  }
}

void draw() {
  background(cesped);

  nido.display();
  
  for (Comida c : comida) {
    c.display();
  }
  
  for (Hormiga h : hormigas) {
    h.wander();
    h.update();
    h.desaparecerFeromonas(feromonas);
   // h.separar(hormigas);
    h.borders();
    h.display();
  }
  
  for (Feromona f: feromonas){
    f.display();
   
  }
  updateFeromona();
}

void updateFeromona() {
  for (int i = feromonas.size() - 1; i >= 0; i--) {
    Feromona p = feromonas.get(i);
    if (p.evaporation >= 255) {
      feromonas.remove(p);
    }
  }
}
void mousePressed() {
  comida.add(new Comida(mouseX, mouseY, 10, 10));
}
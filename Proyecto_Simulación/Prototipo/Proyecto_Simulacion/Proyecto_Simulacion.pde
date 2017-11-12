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
Hormiga hormiga;


Nido nido;
float nido_posx;
float nido_posy;
float width_nido = 680;
float height_nido = 480;
PImage cesped;
PImage hormiguero;
PImage hoja;
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
  hormiguero = loadImage("hormiguero2.png");
  hoja = loadImage("hoja1.png");
  //hormiguero.resize(200,200);

  nido = new Nido(width_nido, height_nido, nido_posx, nido_posy); //Se crea el nido

  //Se agregan las hormigas al arreglo
  for (int i = 0; i<5; i++) {
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
    h.agregarFeromonas(feromonas);
    h.buscar_comida(h);
    h.bordes();
    h.display();
    
  }
  
  for (Feromona f: feromonas){
    f.display();
  
  }
  updateFeromona();

}

void updateFeromona(){
  
  Iterator<Feromona> iter = feromonas.iterator();

   while (iter.hasNext()) {
    Feromona f = iter.next();

    if (f.evaporacion >= 255){
        iter.remove();
    }
   }
}

void mousePressed() {
  comida.add(new Comida(mouseX, mouseY, 80, 70));}
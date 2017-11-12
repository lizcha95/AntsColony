import controlP5.*;

ControlP5 cp5;

ArrayList<Hormiga> hormigas;
int numAnts = 20;
float antSize = 0.09;

ArrayList<Comida> listaComida;
int numFood = 20;
int totalNumFood;

ArrayList<Feromona> feromonas;
float evaporationRate = 0.18;

Nido nido;
float nidoX, nidoY;

float ancho_almacenamiento = 200;
float altura_almacenamiento = 90;

PImage hormiguero;
PImage background;
PImage hoja;

void setup() {
  size(800, 600);
  background(0);
  //fullScreen();
  
  nidoX = width/2;
  nidoY = height/2;


  hormiguero = loadImage("hormiguero.png");
  background = loadImage("degradado.jpg");
  background.resize(width, height);
  hoja = loadImage("hoja1.png");

  nido = new Nido(nidoX, nidoY, 400, 300);
  listaComida = new ArrayList<Comida>(); //Click mouse to create food
  hormigas = new ArrayList();
  
  for (int i = 0; i < numAnts; i++) {
    Hormiga hormiga = new Hormiga(nidoX, nidoY);
    hormiga.cambiarTamanno();
    hormigas.add(hormiga);
  }
  feromonas = new ArrayList<Feromona>();

  initControls();
}

void draw() {
  background(background);
  nido.run();
  for (Comida comida : listaComida) {
    comida.mostrar();
  }
  for (Hormiga hormiga : hormigas) {
    hormiga.run();
  }
  for (Feromona feromona : feromonas) {
    feromona.mostrar();
  }
  for (int i = feromonas.size() - 1; i >= 0; i--) {
    Feromona p = feromonas.get(i);
    if (p.evaporacion >= 255) {
      feromonas.remove(p);
    }
  }
   
}

void initControls() {
  cp5 = new ControlP5(this);

  cp5.addSlider("setEvaporationRate")
    .setValue(evaporationRate)
    .setRange(0, 1)
    .setPosition(20, 10)
    .setSize(100, 20)
    .setColorActive(color(0,128,128))
    .setCaptionLabel("Evaporacion Feromonas");
}

void setEvaporationRate(float value) {
  evaporationRate = value;
}

void mousePressed() {
  if (mouseButton == RIGHT) {
    agregarComida(mouseX, mouseY);
  } 
}

void agregarComida(float posX, float posY) {
  if (!nido.dentroNido(posX, posY)) {
    for (int i = 0; i < numFood; i++) {
      float x = random(posX - 15, posX + 15);
      float y = random(posY - 15, posY + 15);
      Comida comida = new Comida(x, y);
      listaComida.add(comida);
    }
  }
  totalNumFood += numFood;
}
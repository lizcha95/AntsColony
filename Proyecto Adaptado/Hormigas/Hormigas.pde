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
import controlP5.*;

ArrayList<Hormiga> hormigas;
ArrayList<Comida> comida;
ArrayList<Feromona> feromonas;
ArrayList<Float> valor_feromonas;
ControlP5 cp5;

boolean[] estados_hormigas;

Feromona feromona;
Hormiga hormiga;

float EVAPORATION_RATE = 0.70;
PVector VELOCIDAD = PVector.random2D();

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
  estados_hormigas =new boolean[6]; 

  estados_hormigas[0] = true;
  estados_hormigas[1] = false;
  estados_hormigas[2] = false;
  estados_hormigas[3] = false;
  estados_hormigas[4] = false;
  estados_hormigas[5] = false;

  cesped = loadImage("degradado.jpg");
  cesped.resize(width, height);
  hormiguero = loadImage("hormiguero2.png");
  hoja = loadImage("hoja1.png");
  //hormiguero.resize(200,200);

  nido = new Nido(width_nido, height_nido, nido_posx, nido_posy); //Se crea el nido

  //Se agregan las hormigas al arreglo
  for (int i = 0; i<10; i++) {
    Hormiga hormiga = new Hormiga(nido_posx, nido_posy, VELOCIDAD);
    hormiga.cambiar_Tamanio();
    hormigas.add(hormiga);
  }

  initControls();
}

void draw() {

  background(cesped);

  nido.display();

  for (Hormiga h : hormigas) {
    h.display();
    // h.update();


    h.agregarFeromonas();
    h.separate(); // an ant dodges if it encounters another
    // println("Estoy en wander");
    if (estados_hormigas[0] == true) {// an ant wanders
      h.wander(); 
      println("Estoy en wander");
      float r = random(1);
      if (r > 0.3) {//keep wandering without seaching for food or pheromon with prob. 0.3
        if (!(h.hormigas_fuera_del_nido(h.pos.x, h.pos.y))) {// if the ant is outside the nest 
          if (!h.comidaTomada) {// if the ant has no food
            h.buscar_comida(); // the ant searches for food
            if (h.encontrada == true) {// if the ant finds food
              h.cambiarEstado(estados_hormigas, 1); // state changes to 1
            } else { // if the ant does not find food
              h.buscar_feromonas(); // the ant searches for pheromones which may have been dropped by other ants   
              // while delivering food to the nest
              if (h.encontrada == true) { // if the ant finds a pheromone 
                h.cambiarEstado(estados_hormigas, 3);  // state changes to 3
              }
            }
          } else {// if the ant carries food 
            h.buscar_feromonas(); 
            if (h.encontrada == true) { // if the ant finds a pheromone 
              h.cambiarEstado(estados_hormigas, 3);  // state changes to 3
            }
          }
        }
      }
    } else if (estados_hormigas[1]) {// an ant knows where the food is 
      h.mover_hacia_comida(); // the ant goes to the food
      if (h.alcanzada == true) { // if the ant reaches the food
        h.cambiarEstado(estados_hormigas, 2); // state changes to 2
      }
    } else if (estados_hormigas[2]) { // an ant reaches the food
      //antColor = colorWithFood; // the color of the ant with the food changes
      h.revisar_nido_cerca();
      if (h.nido_cerca == true) { // if the ant with the food is near the nest
        h.mover_hacia_nido(); // the ant goes to the nest
        if (h.alcanzada == true) {// if the ant with the food reaches the nest, 
          h.cambiarEstado(estados_hormigas, 5); // state changes to 5
        }
      } else { // if the ant with the food is far from the nest
        h.devolverHormiga(); // the ant turns around to where it came from
        h. buscar_feromonas();
        if (h.encontrada ==  true) { // if the ant find a pheromone
          h.cambiarEstado(estados_hormigas, 3); // state changes to 3
        } else { // if the ant does not find a pheromone
          h.cambiarEstado(estados_hormigas, 0); // state changes to 0 (the ant with the food wanders)
        }
      }
    } else if (estados_hormigas[3]) {// an ant knows where a pheromone is 
      h.mover_hacia_feromona(); // the ant goes to the pheromone
      if (h.alcanzada == true) { // if the ant reaches the pheromone
        h.cambiarEstado(estados_hormigas, 4); // state changes to 4
      }
    } else if (estados_hormigas[4]) { // an ant reahces the pheromone
      if (h.comidaTomada == true) {// if the ant has food
        h. revisar_nido_cerca();
        if (h.nido_cerca == true) {// if the ant is near the nest
          h.mover_hacia_nido(); // the ant goes to the nest
          if (h.alcanzada == true) { // if the ant reaches the nest,  
            h.cambiarEstado(estados_hormigas, 5); // state changes to 5
          }
        } else { // if the ant with the food is far from the nest
          h.buscar_feromonas();
          if (h.encontrada == true) { // if the ant find a pheromone
            h.cambiarEstado(estados_hormigas, 3); // state changes to 3
          } else { 
            h.cambiarEstado(estados_hormigas, 0); // state changes to 0 (the ant with the food wanders)
          }
        }
      } else { // an ant has no food
        h.buscar_comida();
        if (h.encontrada == true) {// if the ant finds food
          h.cambiarEstado(estados_hormigas, 1); // state changes to 1
        } else {// the ant does not find food 
          h.buscar_feromonas();
          if (h.encontrada == true) { // if the ant finds a pheromone 
            h.cambiarEstado(estados_hormigas, 3); // state changes to 3
          }
        }
      }
    } else if (estados_hormigas[5]) {// an ant reaches the nest
      //deliverFood(foodGathered); // the ant stores food gathered at the nest
      h.devolverHormiga(); // the chance of finding more food is higher at the food site it visited than anywhere else
      h.cambiarEstado(estados_hormigas, 0); // state changes to 0
    }
    h.update(); 
    h.bordes();
  } 

  for (Comida c : comida) {
    c.display();
  }

  for (Feromona f : feromonas) {
    f.display();
  }
  updateFeromona();
}

void updateFeromona() {

  Iterator<Feromona> iter = feromonas.iterator();

  while (iter.hasNext()) {
    Feromona f = iter.next();

    if (f.evaporacion >= 255) {
      iter.remove();
    }
  }
}

void mousePressed() {
  comida.add(new Comida(mouseX, mouseY, 80, 70));
}

void initControls() {
  cp5 = new ControlP5(this);

  cp5.addSlider("MUTATION_RATE")
    .setPosition(50, 50)
    .setRange(0.01, 0.1)
    .setSize(300, 20)
    .setCaptionLabel("Duración Feromonas");

  cp5.addSlider("FLOCK_SIZE")
    .setPosition(50, 40)
    .setRange(0, 1000)
    .setSize(300, 20)
    .setCaptionLabel("Radio de Feromonas");

  cp5.addSlider("FLOCK_SIZE")
    .setPosition(50, 30)
    .setRange(0, 1000)
    .setSize(300, 20)
    .setCaptionLabel("Cantidad de Hormigas");
}
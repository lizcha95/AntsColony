ArrayList<Hormiga> hormigas;

Nido nido;
float nido_posx;
float nido_posy;
float width_nido = 100;
float height_nido = 80;
color color_nido = color(200, 200, 200);
PImage cesped;
PImage hormiguero;

void setup(){
  size(800,600);
  background(0);
  
  // Posicion del nido 
  nido_posx = width-100;
  nido_posy = height-90;
  hormigas = new ArrayList();
  cesped = loadImage("cesped.jpg");
  cesped.resize(width,height);
  hormiguero = loadImage("Hormiguero2.jpg");
  hormiguero.resize(100,80);
  
  nido = new Nido(width_nido,height_nido,nido_posx,nido_posy); //Se crea el nido
  
  //Se agregan las hormigas al arreglo
  for(int i = 0; i<10; i++){
    Hormiga hormiga = new Hormiga(nido_posx,nido_posy);
    hormiga.cambiar_Tamanio();
    hormigas.add(hormiga);
  }
}

void draw(){
  background(cesped);
  
  nido.run();
 for (Hormiga h : hormigas) {
        h.show();
  }
  
}
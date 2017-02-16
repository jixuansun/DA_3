
Table data;
Mover[] movers;
////
Attractor a;

void setup() {

  size(1280, 720, P3D) ;
  
  loadData("simpleData.csv");
  
  int countriesCount = data.getRowCount();
  
  movers = new Mover[countriesCount];
   
  for(int j=0;j<countriesCount;j++){
    
    //println(j);
    
    float[] calcuValue = renderData( data.getRow(j) );
    
    movers[j] = new Mover(random(0.1,2),random(calcuValue[2]),random(calcuValue[2]));
    
  }
  
  //println(movers[1]);
  
  a= new Attractor();
  
}


void draw(){

  
  a.display();
  background(240);
  
  randomSeed(0);
  
    for(int j = 0; j < movers.length; j++){
      //println(j);
      PVector force = a.attract(movers[j]);
      
      float[] calcuValue = renderData( data.getRow(j) );
      
      movers[j].applyForce(force);
      movers[j].update();
      movers[j].display(calcuValue[0], calcuValue[3]);
    }
  

  
}

void loadData(String url) {
  data = loadTable(url);
}

float[] renderData(TableRow row) {

    String country = row.getString(0);
    int estimate = row.getInt(1);
    int error = row.getInt(2);
    float errorFraction = (float) error / estimate;
    
    float a = map(estimate, 5000, 5000000, 0, width);
    float b = map(errorFraction, 0, 0.1, 0, height);
    
    float size = map(sqrt(estimate), sqrt(5000), sqrt(5000000), 10, 300);
    float col = map(estimate, 5000, 5000000, 0, 255);
    
    float[] calcuValue = new float[4];
    calcuValue[0] = a;
    calcuValue[1] = b;
    calcuValue[2] = size;
    calcuValue[3] = col;
    
    //println(calcuValue[0],calcuValue[1],calcuValue[2],calcuValue[3]);
    
    return calcuValue;
}


class Mover{

 PVector position;
 PVector velocity;
 PVector acceleration;
 float mass;
 
 float angle = 0;
 float aVelocity = 0;
 float aAcceleration = 0;
 
 Mover(float m, float x, float y){
   mass=m;
   position = new PVector(x,y);
   velocity = new PVector(random(-1,1),random(-1,1));
   acceleration = new PVector(0,0);
 }
 
  void applyForce(PVector force) {
    PVector f = PVector.div(force,mass);
    acceleration.add(f);
  }

  void update() {

    velocity.add(acceleration);
    position.add(velocity);

    aAcceleration = acceleration.x / 10.0;
    aVelocity += aAcceleration;
    aVelocity = constrain(aVelocity,-0.1,0.1);
    angle += aVelocity;

    acceleration.mult(0);
  }

  void display(float a,float col) {

    stroke(a);
    strokeWeight(random(a/100));
    fill(col,200);
    rectMode(CENTER);
    pushMatrix();
    translate(position.x,position.y);
    rotate(angle);
    rect(0,0,mass*16,mass*16);
    popMatrix();
  }

}
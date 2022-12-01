import processing.serial.*;
ArrayList<Boid> boids = new ArrayList<Boid>();
Serial serial;
boolean go = false;
boolean setlimit = false;
ArrayList<Target> targets = new ArrayList<Target>();
int num = 80;
PVector init = new PVector(0,0);
void setup() {
  size(900,700);
  targets.add(new Target(new PVector(300,300)));
  //targets.add(new Target(new PVector(500,500)));
  //targets.add(new Target(new PVector(700,300)));
  //serial = new Serial(this,serial.list()[0],9600);
  createboids(num,100,600);
}

void draw() {
  background(50);
  
  for(Boid boid:boids){
    boid.run(boids);
  }
  /*if(serial.available()>0){
  String read = serial.readString();
  if(read.length() > 1)
    read = read.substring(1,read.length() - 1);
  println(int(read));
  }*/
  
  if(go){
   
   for(Boid theboid : boids){
         Target mintarget = targets.get(minTargetindex(theboid));
         PVector loc = new PVector(100,100);
         float dist = PVector.dist(mintarget.location,theboid.location);
         if(dist < mintarget.radius + 100 && dist > mintarget.radius + 10)
         {
          if(!theboid.intarget){
            
              PVector distance = PVector.sub(theboid.location,mintarget.location);
              distance.setMag(100); 
              init = distance;
            }
          loc = theboid.moveAround(mintarget.location,init);
          theboid.intarget = true;
          //these//
          theboid.cohesionweight = 1;
          theboid.alignweight = 1.1;
          theboid.separateweight = 1.5;
          theboid.maxspeed = 1;
          //these//
         }
         else{
           if(theboid.intarget)
           {
             theboid.hit();
           }
           else{
             loc = mintarget.location; 
           }
           
         }

          theboid.seek(loc);   
      }
  
   }

  for(Target target : targets){
    target.display();
  }
  
  }


void keyPressed(){

  if(key == 'q'){
   go = false;
   println(go);
   for(Boid boid : boids){
    //boid.seeking = false; 
    boid.maxspeed = 2;
    boid.alignweight = 1.2;
    boid.cohesionweight = 1;
    boid.intarget = false;
    
   }
  }
}

void createboids(int num,int x,int y){
    for (int i = 0; i < num; i++) {
    boids.add(new Boid(new PVector(x,y)));
  }
}
void mousePressed(){
   if(!go)
 {
    go = true;
 }
}
int minTargetindex(Boid theboid){
      float mindistance = 900;
      Target mintarget = new Target(new PVector(width,height));
      int targetindex = 0;
      for(int i = 0;i<targets.size();i++){
        float distance = PVector.dist(theboid.location,targets.get(i).location);
        if(distance < mindistance){
         mintarget = targets.get(i);
         targetindex = i;
         mindistance = distance;
        }
}
        return targetindex;
}

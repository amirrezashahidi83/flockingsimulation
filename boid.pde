class Boid{
  
 PVector location = new PVector(0,0); 
 PVector velocity = new PVector(0,0);
 PVector acc = new PVector(0,0);
 PVector circlelocation = new PVector(0,0);
 float maxspeed = 2;
 float maxforce = 0.03;
 float neighbordist = 50;
 float size = 2;
 boolean intarget = false;
 float angle = 0;
 float separateweight = 1.5;
 float cohesionweight = 1;
 float alignweight = 1;
 Boid(PVector location){ 
   this.location = location;
   float angle = random(180);
   velocity = new PVector(cos(angle),sin(angle));
 }
 void run(ArrayList<Boid> boids){
   flock();
   update();
   render();
   borders();
 }
 void flock(){
   align(boids);
   cohesion(boids);
   separate(boids);
 }
 void update(){
  velocity.add(acc);
  velocity.limit(maxspeed);
  location.add(velocity);
  acc.mult(0);
 }
 
 void render(){
    fill(200, 100);
    stroke(128,100,150);
    strokeWeight(1);
    pushMatrix();
    translate(location.x, location.y);
    rotate(velocity.heading2D() + radians(90));
    beginShape(TRIANGLES);
    vertex(0, -size*2);
    vertex(-size, size*2);
    vertex(size, size*2);
    endShape();
    popMatrix();
 }
 
 void applyForce(PVector force){
    acc.add(force); 
 }
 void align(ArrayList<Boid> boids){
  PVector sum = new PVector(0,0);
  int count = 0;
  for(Boid boid : boids){
    float distance = PVector.dist(location,boid.location);
    if(distance > 0 && distance < neighbordist){
      count++;
      sum.add(boid.velocity); 
    }
  }
  if(count > 0){
   sum.div((float)count);
   sum.normalize();
   sum.mult(maxspeed);
   PVector steer = PVector.sub(sum,velocity);
   steer.limit(maxforce);
   steer.mult(alignweight);
   applyForce(steer);
  }
 }

 void cohesion(ArrayList<Boid> boids){
   PVector sum = new PVector(0,0);
   int count = 0;
   for(Boid boid : boids){
    float distance = PVector.dist(location,boid.location);
    if(distance > 0 && distance < neighbordist){
     count++;
     sum.add(boid.location);
    }

   }
    if(count > 0){
     sum.div((float)count);
     sum.mult(cohesionweight);
     seek(sum);
    }
 }

 
 void separate (ArrayList<Boid> boids) {
    float desiredseparation = 25.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(location, other.location);
      if ((d > 0) && (d < desiredseparation)) {
        PVector diff = PVector.sub(location, other.location);
        diff.normalize();
        diff.div(d);        
        steer.add(diff);
        count++;            
      }
    }
    if (count > 0) {
      steer.div((float)count);
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    applyForce(steer.mult(separateweight));
  }
 
 void seek(PVector target){
   PVector desired = PVector.sub(target,location);
   desired.normalize();
   desired.mult(maxspeed);
   PVector steer = PVector.sub(desired,velocity);
   steer.limit(maxforce);
   applyForce(steer);   
 }
   void borders() {
    if (location.x < -size) location.x = width+size;
    if (location.y < -size) location.y = height+size;
    if (location.x > width+size) location.x = -size;
    if (location.y > height+size) location.y = -size;
  }
 
 PVector moveAround(PVector target,PVector init){
   if(circlelocation.x == 0 && circlelocation.y == 0){
     PVector init2 = new PVector(init.x,init.y);
     init2.normalize();
     angle = -degrees(atan(init.y/init.x));
     if(init2.x < 0)
       angle = 180 + angle;
     
   }
     if(angle >= 360)
       angle = 0;
     if(PVector.dist(circlelocation,location) < 50){
       angle +=1;
     }
     PVector v = new PVector(cos(radians(angle)),sin(radians((angle))));
     float y = target.y - 100 * v.y;
     float x = target.x + 100 * v.x;
     circlelocation = (new PVector(x,y));
     return circlelocation;
 }
 
 void hit(){
   applyForce(new PVector(velocity.x,velocity.y).mult(-15));
 }
 
}

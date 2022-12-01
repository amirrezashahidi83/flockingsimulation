class Target{
  float r = 0;
  float g = 0;
  float b = 0;
  float radius = 50;
  float strokeweight = 0;
  ArrayList<Boid> followers = new ArrayList<Boid>();
  PVector location;
  Target(PVector location){
      this.location = location;
  }
  void display(){
    pushMatrix();
    stroke(r,g,b);
    noFill();
    strokeWeight(strokeweight);
    circle(location.x,location.y,radius * 2);
    popMatrix();
  }
  void addFollower(Boid theboid)
  {
      followers.add(theboid);
  }
  PVector getFollowerdest(Boid theboid)
  {
    int size = 1;
    if(followers.size() > 1)
      size = followers.size();
    int index = followers.indexOf(theboid);
    float angle = 360 / size * index;
    return new PVector(location.x+cos(angle) * radius,location.y+sin(angle) * radius);
  }
  
}

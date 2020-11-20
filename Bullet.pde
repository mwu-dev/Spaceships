class Bullet{

  final float velConstant; //velocities cannot surpass this number
  PVector pos, vel;
  final float angle;      //angle at which the bullet was fired
  boolean isAlive;
  int numPlayer;
  
  Bullet(float x, float y, float ang, int playerNum){
    isAlive = true;
    velConstant = 15;
    angle = ang;
    numPlayer = playerNum;
    pos = new PVector(x,y);
    vel = new PVector(cos(radians(angle)) * velConstant, sin(radians(angle)) * velConstant);
  }
  
  
  boolean collideWithEnd(){    //once collided, isAlive = false
    if(pos.x <= -displayWidth/2 || pos.x >= displayWidth/2 || pos.y <= -displayHeight/2 || pos.y >= displayHeight/2){
      isAlive = false;
      return true;
    }
    return false;
  }
  
  void show(){
    if(isAlive){
      //show
      if(numPlayer == 1){
        fill(255,0,0);
      }
      else{
        fill(0,0,255);
      }
      circle(pos.x, pos.y, 10);
    }
  }
  
  void move(){
    pos.add(vel);
  }
}

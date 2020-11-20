class Wall{
  PVector pos;
  float radiusX;
  float radiusY;
  
  
  
  
  Wall(float posX, float posY, float radX, float radY){
    pos = new PVector(posX, posY);
    radiusX = radX;
    radiusY = radY;
  }
  
  void show(){
    fill(255);
    stroke(255,0,255);
    rect(pos.x, pos.y, radiusX*2, radiusY*2);
    noStroke();
  }
}

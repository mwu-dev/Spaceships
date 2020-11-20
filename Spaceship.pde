class Spaceship{
  
  //ALL GLOBAL VARIABLES
      PVector pos, vel, acc;
      ArrayList<Wall> walls;
      ArrayList<Bullet> bullets;
      final float accConstant;
      float degreesFacing;
      float[] tip = new float[2];
      float[] left = new float[2];
      float[] right = new float[2];
      final int deltaDegrees = 3;                          //how fast/slow the ship turns left/right
      final int epsilon = 15;                              //how many pixels before ship is considered to collide with a wall
      final int triSize = (int) (width/(2560.0/30));       //how big the ship hitbox is (change the divisor number)
      int playerNum;                                       //player 1 is red, player 2 is blue, different starting positions
      int mapChoice;                                       //used for initial position on the map
      int lifeCount;
  //END ALL GLOBAL VARIABLES
  
  //CONSTRUCTOR
        Spaceship(int numPlayer, int lifeNum){
          playerNum = numPlayer;
          walls = new ArrayList<Wall>();
          bullets = new ArrayList<Bullet>();
          lifeCount = lifeNum;
          vel = new PVector(0,0);
          accConstant = (width * 2)/196.0/60.0;
          acc = new PVector(accConstant * cos(radians(degreesFacing)), accConstant * sin(radians(degreesFacing)));
        }
  //END CONSTRUCTOR
  
  
  /*
  ALL MOVEMENT METHODS
  */
        void changeDegrees(int dir){
          switch(dir){
            case 1: //left
              degreesFacing += deltaDegrees;
              break;
            case 2: //right
              degreesFacing += -deltaDegrees;
              break;
          }
          degreesFacing += 360;
          degreesFacing %= 360;
        }
        
        void moveForward(){
          acc.x = accConstant * cos(radians(degreesFacing));
          acc.y = -accConstant * sin(radians(degreesFacing));
          vel.add(acc);
          if(!willHitWall()){
            changePos();
          }
        }
        
        void moveBackward(){
          acc.x = -accConstant * cos(radians(degreesFacing));
          acc.y = (accConstant * sin(radians(degreesFacing)));
          vel.x = constrain(vel.x + acc.x, -7.65, 7.65);
          vel.y = constrain(vel.y + acc.y, -7.65, 7.65);
          if(!willHitWall()){
            changePos();
          }
        }
        
        void changePos(){    //actually change the position
          pos.x = constrain(pos.x + vel.x, -width/2 + epsilon, width/2 - epsilon);
          pos.y = constrain(pos.y - vel.y, -height/2 + epsilon, height/2 - epsilon);
        }
        
        boolean willHitWall(){
          for(int i = 0; i < walls.size(); i++){
            Wall currWall = walls.get(i);
            if(inRangeX(currWall, pos.x + vel.x) && inRangeY(currWall, pos.y - vel.y)){
              return true;
            }
          }
          return false;
        }
        
        boolean inRangeX(Wall wall, float x){
          float wallLeft = wall.pos.x - wall.radiusX;
          float wallRight = wall.pos.x + wall.radiusX;
          return wallLeft <= x+epsilon && wallRight >= x-epsilon;
        }
        
        boolean inRangeY(Wall wall, float y){
          float wallUp = wall.pos.y - wall.radiusY;
          float wallDown = wall.pos.y + wall.radiusY;
          return wallUp <= y+epsilon && wallDown >= y-epsilon;
        }
  /*
  END ALL MOVEMENT METHODS
  */
  
  /*
  ALL FIRING METHODS
  */
        void shoot(){
          if(bullets.size() < 10){
            bullets.add(new Bullet(pos.x, pos.y, degreesFacing, playerNum));
          }
        }
  /*
  END ALL FIRING METHODS
  */
  
  /*
  ALL DISPLAYING METHODS
  */
          void show(){
            if(playerNum == 1){
              fill(255,0,0);
            }
            else if(playerNum == 2){
              fill(0,0,255);
            }
            drawTri(triSize);
          }
          
          boolean alive(){
            return lifeCount != 0;
          }
          
          
          void drawTri(float len){  //draw equi triangle of given length around center of tri
        
            tip[0] =   pos.x + cos(radians(degreesFacing))*len;
            tip[1] =   pos.y + (sin(radians(degreesFacing)))*len;
            left[0] =  pos.x + cos(radians(degreesFacing+140))*len;
            left[1] =  pos.y + (sin(radians(degreesFacing+140)))*len;
            right[0] = pos.x + cos(radians(degreesFacing-140))*len;
            right[1] = pos.y + (sin(radians(degreesFacing-140)))*len;
            
            triangle(tip[0],tip[1],
                     left[0],left[1],
                     right[0],right[1]);
                      
             //test point locations
                  //text("point 1", tip[0],tip[1]);
                  //text("point 2", left[0],left[1]);
                  //text("point 3", right[0],right[1]);
                  //if(playerNum == 1){
                  //  text("point 1: (" + tip[0] + ", " + tip[1] + ")", -1100, -220);
                  //  text("point 2: (" + left[0] + ", " + left[1] + ")", -1100, -200);
                  //  text("point 3: (" + right[0] + ", " + right[1] + ")", -1100, -180);
                  //}
          }
          
          void drawWalls(){
            for(Wall w : walls){
              w.show();
            }
          }
          
          boolean bulletCollideWithWalls(Bullet b){
              for(Wall w : walls){
                if(inRangeX(w, b.pos.x) && inRangeY(w, b.pos.y)){
                  return true;
                }
              }
            return false;
          }
  /*
  END ALL DISPLAYING METHODS
  */
  
  /*
  SETTING MAPCHOICE
  */
          void setMap(int map){
            mapChoice = map; 
            switch(mapChoice){
              case 1:
                if(playerNum == 1){
                  pos = new PVector(-width/(2560.0/1200), 0);          //left side of the screen
                  degreesFacing = 0;                    //facing right
                }
                else if(playerNum == 2){
                  pos = new PVector(width/(2560.0/1200), 0);           //right side of the screen
                  degreesFacing = 180;                  //facing left
                }
                walls.add(new Wall(-width/(2560.0/1050), 0, width/(2560.0/50), height/(1440.0/400)));    //left vertical wall
                walls.add(new Wall(width/(2560.0/1050), 0, width/(2560.0/50), height/(1440.0/400)));     //right vertical wall
                walls.add(new Wall(-width/(2560.0/650), 0, width/(2560.0/350), height/(1440.0/50)));  //left horizontal wall
                walls.add(new Wall(width/(2560.0/650), 0, width/(2560.0/350), height/(1440.0/50)));   //right horizontal wall
                walls.add(new Wall(0, -height/(1440.0/450), width/(2560.0/25), height/(1440.0/150)));     //top vertical wall
                walls.add(new Wall(0, height/(1440.0/450), width/(2560.0/25), height/(1440.0/150)));      //bottom vertical wall
                break;
              case 2:
                if(playerNum == 1){
                  pos = new PVector(-width/(2560.0/1200), -height/(1440.0/600));       //top-left side of the screen
                  degreesFacing = 25;                   //facing bottom-right
                }
                else if(playerNum == 2){
                  pos = new PVector(width/(2560.0/1200), height/(1440.0/600));         //bottom-right side of the screen
                  degreesFacing = 210;                  //facing top-left
                }
                walls.add(new Wall(-width/(2560.0/950), -height/(1440.0/200), width/(2560.0/50), height/(1440.0/700)));  //left vertical wall
                walls.add(new Wall(width/(2560.0/950), height/(1440.0/200), width/(2560.0/50), height/(1440.0/700)));    //right vertical wall
                walls.add(new Wall(-width/(2560.0/500), height/(1440.0/250), width/(2560.0/200), height/(1440.0/50)));   //left horizontal wall
                walls.add(new Wall(width/(2560.0/500), -height/(1440.0/250), width/(2560.0/200), height/(1440.0/50)));   //right horizontal wall
                walls.add(new Wall(0,0,width/(2560.0/100),height/(1440.0/100)));       //middle box wall
                break;
              case 3:
                if(playerNum == 1){
                  pos = new PVector(0, -height/(1440.0/650));           //top of the screen
                  degreesFacing = 90;                   //facing down
                }
                else if(playerNum == 2){
                  pos = new PVector(0, height/(1440.0/650));            //bottom of the screen
                  degreesFacing = 270;                  //facing up
                }
                walls.add(new Wall(width/(2560.0/1200), 0, width/(2560.0/125), height/(1440.0/25)));     //all walls right to left
                walls.add(new Wall(width/(2560.0/900), 0, width/(2560.0/125), height/(1440.0/25)));
                walls.add(new Wall(width/(2560.0/600), 0, width/(2560.0/125), height/(1440.0/25)));
                walls.add(new Wall(width/(2560.0/300), 0, width/(2560.0/125), height/(1440.0/25)));
                walls.add(new Wall(0, 0, width/(2560.0/125), height/(1440.0/25)));
                walls.add(new Wall(-width/(2560.0/300), 0, width/(2560.0/125), height/(1440.0/25)));
                walls.add(new Wall(-width/(2560.0/600), 0, width/(2560.0/125), height/(1440.0/25)));
                walls.add(new Wall(-width/(2560.0/900), 0, width/(2560.0/125), height/(1440.0/25)));
                walls.add(new Wall(-width/(2560.0/1200), 0, width/(2560.0/125), height/(1440.0/25)));
                break;
              case 4:
                if(playerNum == 1){
                  pos = new PVector(-width/(2560.0/200), height/(1440.0/600));         //bottom of the screen
                  degreesFacing = 180;                  //facing left
                }
                else if(playerNum == 2){
                  pos = new PVector(width/(2560.0/200), height/(1440.0/600));          //bottom of the screen
                  degreesFacing = 0;                    //facing right
                }
                walls.add(new Wall(0, height/(1440.0/400), width/(2560.0/50), height/(1440.0/400)));      //middle vertical wall
                walls.add(new Wall(0, height/(1440.0/450), width/(2560.0/900), height/(1440.0/50)));      //middle horizontal wall
                walls.add(new Wall(-width/(2560.0/750), height/(1440.0/250), width/(2560.0/50), height/(1440.0/150)));   //left vertical wall
                walls.add(new Wall(width/(2560.0/750), height/(1440.0/250), width/(2560.0/50), height/(1440.0/150)));    //right vertical wall
                walls.add(new Wall(-width/(2560.0/550), 0, width/(2560.0/25), height/(1440.0/100)));     //bridge wall left to right
                walls.add(new Wall(-width/(2560.0/500), -height/(1440.0/50), width/(2560.0/25), height/(1440.0/100)));
                walls.add(new Wall(-width/(2560.0/450), -height/(1440.0/100), width/(2560.0/25), height/(1440.0/100)));
                walls.add(new Wall(-width/(2560.0/400), -height/(1440.0/150), width/(2560.0/25), height/(1440.0/100)));
                walls.add(new Wall(-width/(2560.0/350), -height/(1440.0/175), width/(2560.0/25), height/(1440.0/100)));
                walls.add(new Wall(-width/(2560.0/300), -height/(1440.0/200), width/(2560.0/25), height/(1440.0/100)));
                walls.add(new Wall(-width/(2560.0/250), -height/(1440.0/225), width/(2560.0/25), height/(1440.0/100)));
                walls.add(new Wall(-width/(2560.0/200), -height/(1440.0/250), width/(2560.0/25), height/(1440.0/100)));
                walls.add(new Wall(-width/(2560.0/150), -height/(1440.0/275), width/(2560.0/25), height/(1440.0/100)));
                walls.add(new Wall(-width/(2560.0/100), -height/(1440.0/300), width/(2560.0/25), height/(1440.0/100)));
                walls.add(new Wall(-width/(2560.0/50), -height/(1440.0/325), width/(2560.0/25), height/(1440.0/100)));
                walls.add(new Wall(0, -height/(1440.0/350), width/(2560.0/25), height/(1440.0/100)));
                walls.add(new Wall(width/(2560.0/50), -height/(1440.0/325), width/(2560.0/25), height/(1440.0/100)));
                walls.add(new Wall(width/(2560.0/100), -height/(1440.0/300), width/(2560.0/25), height/(1440.0/100)));
                walls.add(new Wall(width/(2560.0/150), -height/(1440.0/275), width/(2560.0/25), height/(1440.0/100)));
                walls.add(new Wall(width/(2560.0/200), -height/(1440.0/250), width/(2560.0/25), height/(1440.0/100)));
                walls.add(new Wall(width/(2560.0/250), -height/(1440.0/225), width/(2560.0/25), height/(1440.0/100)));
                walls.add(new Wall(width/(2560.0/300), -height/(1440.0/200), width/(2560.0/25), height/(1440.0/100)));
                walls.add(new Wall(width/(2560.0/350), -height/(1440.0/175), width/(2560.0/25), height/(1440.0/100)));
                walls.add(new Wall(width/(2560.0/400), -height/(1440.0/150), width/(2560.0/25), height/(1440.0/100)));
                walls.add(new Wall(width/(2560.0/450), -height/(1440.0/100), width/(2560.0/25), height/(1440.0/100)));
                walls.add(new Wall(width/(2560.0/500), -height/(1440.0/50), width/(2560.0/25), height/(1440.0/100)));
                walls.add(new Wall(width/(2560.0/550), 0, width/(2560.0/25), height/(1440.0/100)));
                break;
            }
          }
  /*
  END SETTING MAPCHOICE
  */
  
}

//BEGIN ALL GLOBALS
      //ArrayList<Boolean> called = new ArrayList<Boolean>();
      boolean[] keys = new boolean[8];
      boolean stopped1;                  //if ship1 is stopped
      boolean stopped2;                  //if ship2 is stopped
      boolean paused;                    //if the game is paused
      boolean existsWinner;              //if there is a winner i.e. a game ended
      int mapChoice;
      int modeChoice;
      int savedTime1;
      int savedTime2;
      int allottedTime;                  //time spent out of games, subtracted from total time
      int ship1Shots;
      int ship2Shots;
      final int totalLife = 5;           //number of hits a ship can take
      final int reloadTimer = 250;       //how long before one can fire after firing
      final float friction = 0.9;        //friction multiplier for when forward/backward is released
      Spaceship ship1, ship2;
      Human human1, human2;
//END ALL GLOBALS

//BEGIN SETUP/RESET
        void setup(){
          frameRate(60);
          fullScreen();
          //size(1920,1080);
          shapeMode(CENTER);
          rectMode(CENTER);
          textAlign(CENTER);
          stopped1 = false;
          stopped2 = false;
          paused = false;
          existsWinner = false;
          mapChoice = -1;
          modeChoice = -1;
          savedTime1 = millis();
          savedTime2 = millis();
          ship1Shots = 0;
          ship2Shots = 0;
        }
        
        void reset(){
          stopped1 = false;
          stopped2 = false;
          paused = false;
          existsWinner = false;
          mapChoice = -1;
          modeChoice = -1;
          savedTime1 = millis();
          savedTime2 = millis();
          allottedTime = millis();
          ship1Shots = 0;
          ship2Shots = 0;
          ship1 = null;
          ship2 = null;
          
          loop();
        }
//END SETUP/RESET

//BEGIN DRAW METHOD
        void draw(){
          background(0);
          translate(width/2, height/2);

          
          //insert screen to choose mode:
          if(modeChoice == -1){
              textSize(86);
              fill(255);
              text("CHOOSE A MODE", 0, ((-height/2) + (100 - height/2.88))/2);
              stroke(0,255,0);
              strokeWeight(5);
              rect(-(width/4), 100, (width/3.2), (height/1.44));  //rectangles encompassing the modes
              rect((width/4), 100, (width/3.2), (height/1.44));   //
              noStroke();
              fill(0);
              text("SPACESHIPS", -(width/4), 100);
              text("HUMANS", (width/4), 100);
          }
          
          
          //insert screen to choose map:
          if(mapChoice == -1 && modeChoice != -1){
              textSize(86);
              fill(255);
              text("CHOOSE A MAP", 0, ((-height/2) + (-200 - height/7.2))/2);
              stroke(0,255,0);
              strokeWeight(5);
              rect(-(width/4), -200, (width/3.2), (height/3.6));  //rectangles encompassing the maps
              rect(-(width/4), 300, (width/3.2), (height/3.6));   //
              rect((width/4), -200, (width/3.2), (height/3.6));   //
              rect((width/4), 300, (width/3.2), (height/3.6));    //
              noStroke();
              fill(0);
              textSize(128);
              text("1", -(width/4), -150);
              text("2", -(width/4), 350);
              text("3", (width/4), -150);
              text("4", (width/4), 350);
              textSize(16);
          }
          
          //debugging
                  //fill(0,255,0);
                  //stroke(0,255,0);
                  //strokeWeight(1);
                  //textSize(16);
                  //for(int i = -1300; i <= 1300; i += 100){
                  //  line(i, -720, i, 720);
                  //  text("x: " + i ,i, 0);
                  //}
                  //for(int j = -800; j <= 800; j += 100){
                  //  line(-1280, j, 1280, j);
                  //  text("y: " + j, 0, j);
                  //}
                  //noStroke();
                  //textSize(16);
                  //text("mouseX: " + (mouseX-1280), 0, 50);
                  //text("mouseY: " + (mouseY-720), 0, 25);
                  
          //end debugging
          
          
          switch(mapChoice){
            case 1: //map 1
              if(modeChoice == 1){ //spaceships
                spaceModeChoice();
              }
              else if(modeChoice == 2){
                
              }
              break;
            case 2: //map 2
              if(modeChoice == 1){
                spaceModeChoice();
              }
              else if(modeChoice == 2){
              
              }
              break;
            case 3: //map 3
              if(modeChoice == 1){
                spaceModeChoice();
              }
              else if(modeChoice == 2){
              
              }
              break;
            case 4: //map 4
              if(modeChoice == 1){
                spaceModeChoice();
              }
              else if(modeChoice == 2){
              
              }
              break;
          }
        }
        
        void spaceModeChoice(){
             //movement of ships, bullets
             if(ship1.alive() && ship2.alive()){
               showPlayers();
               moveShips();
               showBullets();
               if(bulletCollideWithPlayer2()){
                 ship2.lifeCount--;
               }
               if(bulletCollideWithPlayer1()){
                 ship1.lifeCount--;
               }
             }
             else{
               //show victory/defeat screen
               existsWinner = true;
               textSize(128);
               if(!ship1.alive()){
                 fill(0,0,255);
                 text("Player 2 (BLUE) WINS!", 0, 0);
               }
               else if(!ship2.alive()){
                 fill(255,0,0);
                 text("Player 1 (RED) WINS!", 0, 0);
               }
               textSize(16);
               fill(255);
               text("Press 'R' to restart", 0, 200);
               text("Time taken: " + timeStamp(millis() - allottedTime), 0, 230);
               text("Red ship shots: " + ship1Shots, -200, 330);
               text("Blue ship shots: " + ship2Shots, 200, 330);
               noLoop();
             }
          //end movement of ships, bullets
        }
        
        void humanModeChoice(){
        
        }
//END DRAW METHOD

/*
ALL KEY/MOUSE METHODS
*/
        void keyPressed(){
          if((key == 'P' || key == 'p') && modeChoice != -1){
            if(!paused){  //paused, show pause screen
              noLoop();
              textSize(64);
              fill(255);
              text("PAUSED", 0, 0);
              paused = true;
            }
            else{
              loop();
              paused = false;
            }
          }
          
          if((key == 'R' || key == 'r') && existsWinner){
            reset();
          }
          
          /*
          BEGIN CONTROLS
          */
                if(keyPressed && modeChoice == 1 && mapChoice != -1){ //spaceship mode
                  if(key == 'W' || key == 'w'){
                    keys[0] = true;
                  }
                  if(key == 'A' || key == 'a'){
                    keys[1] = true;
                  }
                  if(key == 'S' || key == 's'){
                    keys[2] = true;
                  }
                  if(key == 'D' || key == 'd'){
                    keys[3] = true;
                  }
                  if(keyCode == UP){
                    keys[4] = true;
                  }
                  if(keyCode == LEFT){
                    keys[5] = true;
                  }
                  if(keyCode == DOWN){
                    keys[6] = true;
                  }
                  if(keyCode == RIGHT){
                    keys[7] = true;
                  }   
                  if(key == ' '){
                    if(millis() - savedTime1 >= reloadTimer){
                      ship1.shoot();
                      ship1Shots++;
                      savedTime1 = millis();
                    }
                  }
                  if(keyCode == ENTER){
                    if(millis() - savedTime2 >= reloadTimer){
                      ship2.shoot();
                      ship2Shots++;
                      savedTime2 = millis();
                    }
                  }
                }
                else if(keyPressed && modeChoice == 2 && mapChoice != -1){ //human mode
                  if(key == 'W' || key == 'w'){
                    
                  }
                  if(key == 'S' || key == 's'){
                  
                  }
                  if(key == 'A' || key == 'a'){
                  
                  }
                  if(key == 'D' || key == 'd'){
                  
                  }
                  if(keyCode == UP){
                  
                  }
                  if(keyCode == DOWN){
                  
                  }
                  if(keyCode == LEFT){
                  
                  }
                  if(keyCode == RIGHT){
                  
                  }
                }
          /*
          END CONTROLS
          */
        }
        
        void keyReleased(){
          if(key == 'W' || key == 'w'){
            keys[0] = false;
          }
          if(key == 'A' || key == 'a'){
            keys[1] = false;
          }
          if(key == 'S' || key == 's'){
            keys[2] = false;
          }
          if(key == 'D' || key == 'd'){
            keys[3] = false;
          }
          if(keyCode == UP){
            keys[4] = false;
          }
          if(keyCode == LEFT){
            keys[5] = false;
          }
          if(keyCode == DOWN){
            keys[6] = false;
          }
          if(keyCode == RIGHT){
            keys[7] = false;
          }
        }
        
        
        
        void mouseClicked(){
          int myMouseX = mouseX - width/2;
          int myMouseY = mouseY - height/2;
          if(modeChoice == -1){
            if(myMouseX >= (-width/4) - width/6.4 && myMouseX <= (-width/4) + width/6.4 && myMouseY >= 100 - height/2.88 && myMouseY <= 100 + height/2.88){
              modeChoice = 1;
              ship1 = new Spaceship(1,totalLife);
              ship2 = new Spaceship(2,totalLife);
            }
            else if(myMouseX >= width/4 - width/6.4 && myMouseX <= width/4 + width/6.4 && myMouseY >= 100 - height/2.88 && myMouseY <= 100 + height/2.88){
              modeChoice = 2;
              human1 = new Human();
              human2 = new Human();
            }
          }
          else if(mapChoice == -1){
            if(myMouseX >= (-width/4) - width/6.4 && myMouseX <= (-width/4) + width/6.4 && myMouseY >= -200 - (height/7.2) && myMouseY <= -200 + (height/7.2)){  //map 1
              mapChoice = 1;
              setMapForPlayers(mapChoice);
              allottedTime = millis();
            }
            else if(myMouseX >= (-width/4) - width/6.4 && myMouseX <= (-width/4) + width/6.4 && myMouseY >= 300 - (height/7.2) && myMouseY <= 300 + (height/7.2)){  //map 2
              mapChoice = 2;
              setMapForPlayers(mapChoice);
              allottedTime = millis();
            }
            else if(myMouseX >= (width/4) - (width/6.4) && myMouseX <= (width/4) + width/6.4 && myMouseY >= -200 - (height/7.2) && myMouseY <= -200 + (height/7.2)){  //map 3
              mapChoice = 3;
              setMapForPlayers(mapChoice);
              allottedTime = millis();
            }
            else if(myMouseX >= (width/4) - (width/6.4) && myMouseX <= (width/4) + width/6.4 && myMouseY >= 300 - (height/7.2) && myMouseY <= 300 + (height/7.2)){  //map 4
              mapChoice = 4;
              setMapForPlayers(mapChoice);
              allottedTime = millis();
            }
          }
        }
        
        void setMapForPlayers(int map){
          if(modeChoice == 1){
            ship1.setMap(map);
            ship2.setMap(map);
          }
          else if(modeChoice == 2){
            human1.setMap(map);
            human2.setMap(map);
          }
        }
/*
END ALL KEY/MOUSE METHODS
*/


/*
ALL MOVEMENT METHODS
*/
        void moveShips(){
          //move ship1
              if(keys[0] && !keys[2]){
                stopped1 = false;
                ship1.moveForward();
                
              }
              else{
                stopped1 = true;
              }
              if(keys[1]){
                ship1.changeDegrees(1);
              }
              if(keys[2] && !keys[0]){
                stopped1 = false;
                ship1.moveBackward();
              }
              else{
                stopped1 = true;
              }
              if(keys[3]){
                ship1.changeDegrees(2);
              }
              
              if(stopped1){
                  if(!ship1.willHitWall()){
                    ship1.changePos();
                  }
                  ship1.vel.x *= friction;
                  ship1.vel.y *= friction;
                  if(abs(ship1.vel.x) < 0.05){
                    ship1.vel.x = 0;
                  }
                  if(abs(ship1.vel.y) < 0.05){
                    ship1.vel.y = 0;
                  }
              }
          //end move ship1
              
          //move ship2
              if(keys[4] && !keys[6]){
                stopped2 = false;
                ship2.moveForward();
              }
              else{
                stopped2 = true;
              }
              if(keys[5]){
                ship2.changeDegrees(1);
                //test
              }
              if(keys[6] && !keys[4]){
                stopped2 = false;
                ship2.moveBackward();
              }
              else{
                stopped2 = true;
              }
              if(keys[7]){
                ship2.changeDegrees(2);
                //test
              }
              
              if(stopped2){
                  if(!ship2.willHitWall()){
                    ship2.changePos();
                  }
                  ship2.vel.x *= friction;
                  ship2.vel.y *= friction;
                  if(abs(ship2.vel.x) < 0.05){
                    ship2.vel.x = 0;
                  }
                  if(abs(ship2.vel.y) < 0.05){
                    ship2.vel.y = 0;
                  }
              }
           //end move ship2
        }
/*
END ALL MOVEMENT METHODS
*/


/*
ALL DISPLAYING METHODS
*/
        void showPlayers(){
          if(modeChoice == 1){
            ship1.show();
            ship2.show();
            ship1.drawWalls();
            showShipHP();
          }
          else if(modeChoice == 2){ //todo
            //human1.show();
            //human2.show();
          }
        }
        
        void showBullets(){
          if(modeChoice == 1){
            for(int i = 0; i < ship1.bullets.size(); i++){
              Bullet b = ship1.bullets.get(i);
              b.move();
              b.show();
              if(b.collideWithEnd() || ship1.bulletCollideWithWalls(b))
                ship1.bullets.remove(i);
            }
            for(int i = 0; i < ship2.bullets.size(); i++){
              Bullet b = ship2.bullets.get(i);
              b.move();
              b.show();
              if(b.collideWithEnd() || ship2.bulletCollideWithWalls(b))
                ship2.bullets.remove(i);
            }
          }
        }
        
        void showShipHP(){
          rectMode(CORNERS);
          noFill();
          stroke(255);
          strokeWeight(5);
          
          
          
          rect(-width/(2560.0/1100) - 2, -height/(1440.0/625), -width/(2560.0/1100) + 302, -height/(1440.0/575));  //left white bar
          rect(width/(2560.0/1100) + 2, -height/(1440.0/625), width/(2560.0/1100) - 302, -height/(1440.0/575));   //right white bar
          
          noStroke();
          textSize(64);
          fill(255,0,0);
          text("LIFE", -width/(2560.0/950), -height/(1440.0/650));
          rect(-width/(2560.0/1100), -height/(1440.0/625) + 3, -width/(2560.0/1100)+(300.0/totalLife)*ship1.lifeCount, -height/(1440.0/575) - 2);
          fill(0,0,255);
          text("LIFE", width/(2560.0/950), -height/(1440.0/650));
          rect(width/(2560.0/1100), -height/(1440.0/625) + 3, width/(2560.0/1100)-(300.0/totalLife)*ship2.lifeCount, -height/(1440.0/575) - 2);
          textSize(16);
          rectMode(CENTER);
        }
/*
END ALL DISPLAYING METHODS
*/

/*
ALL LIFECHECK METHODS
*/
        boolean bulletCollideWithPlayer2(){
          for(int i = 0; i < ship1.bullets.size(); i++){
            Bullet b = ship1.bullets.get(i);
            if(hitShip2Vertex(b.pos.x, b.pos.y) || hitShip2Middle(b.pos.x, b.pos.y)){
              ship1.bullets.remove(i);
              return true;
            }
          }
          return false;
        }
        
        boolean bulletCollideWithPlayer1(){
          for(int i = 0; i < ship2.bullets.size(); i++){
            Bullet b = ship2.bullets.get(i);
            if(hitShip1Vertex(b.pos.x, b.pos.y) || hitShip1Middle(b.pos.x, b.pos.y)){
              ship2.bullets.remove(i);
              return true;
            }
          }
          return false;
        }
        
        boolean hitShip1Vertex(float bulletX, float bulletY){
          return dist(ship1.tip[0], ship1.tip[1], bulletX, bulletY) < 10 || dist(ship1.left[0], ship1.left[1], bulletX, bulletY) < 10 || dist(ship1.right[0], ship1.right[1], bulletX, bulletY) < 10;
        }
        
        boolean hitShip1Middle(float bulletX, float bulletY){
          float[] middle12 = {(ship1.tip[0] + ship1.left[0])/2, (ship1.tip[1] + ship1.left[1])/2};
          float[] middle13 = {(ship1.tip[0] + ship1.right[0])/2, (ship1.tip[1] + ship1.right[1])/2};
          float[] middle23 = {(ship1.left[0] + ship1.right[0])/2, (ship1.left[1] + ship1.right[1])/2};
          return dist(middle12[0], middle12[1], bulletX, bulletY) < 10 || dist(middle13[0], middle13[1], bulletX, bulletY) < 10 || dist(middle23[0], middle23[1], bulletX, bulletY) < 10;
        }
        
        boolean hitShip2Vertex(float bulletX, float bulletY){
          return dist(ship2.tip[0], ship2.tip[1], bulletX, bulletY) < 10 || dist(ship2.left[0], ship2.left[1], bulletX, bulletY) < 10 || dist(ship2.right[0], ship2.right[1], bulletX, bulletY) < 10;
        }
        
        boolean hitShip2Middle(float bulletX, float bulletY){
          float[] middle12 = {(ship2.tip[0] + ship2.left[0])/2, (ship2.tip[1] + ship2.left[1])/2};
          float[] middle13 = {(ship2.tip[0] + ship2.right[0])/2, (ship2.tip[1] + ship2.right[1])/2};
          float[] middle23 = {(ship2.left[0] + ship2.right[0])/2, (ship2.left[1] + ship2.right[1])/2};
          return dist(middle12[0], middle12[1], bulletX, bulletY) < 10 || dist(middle13[0], middle13[1], bulletX, bulletY) < 10 || dist(middle23[0], middle23[1], bulletX, bulletY) < 10;
        }
        
        
/*
END ALL LIFECHECK METHODS
*/

        String timeStamp(int time){    //time in ms
          int seconds = time/1000;
          if(seconds >= 60){
            return seconds%60 + "m " + seconds/60 + "s";
          }
          else{
            return seconds + "s";
          }
        }

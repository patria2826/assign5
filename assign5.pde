PImage start2,  start1, gift, player, enemy, end2, end1, bullet, bg1, bg2, hp;
float bgX, giftX, giftY, playerX, playerY, enemyY, playerSpeed, enemySpeed, bulletSpeed;
int life;
PFont board;
int scoreNum = 0;

int gameState;
final int GAME_START = 0;
final int GAME_PLAY = 1;
final int GAME_LOSE = 2;

//enemy//
PImage [] enemyPosition = new PImage [5];
float enemy_straight [][] = new float [5][2];       
float enemy_slope [][] = new float [5][2];
float enemy_daimond [][] = new float [8][2];  
float spacingX;
float spacingY;

int enemyState;
final int enemyStraight = 0;
final int enemySlope = 1;
final int enemyDaimond = 2;

//flame//
int flameCount;
int flameCurrent;
PImage [] boom = new PImage [5];
float hitPosition [][] = new float [5][2]; 

//shoot//
float [] bulletX = new float [5];
float [] bulletY = new float [5];

boolean upPressed = false;
boolean downPressed = false;
boolean leftPressed = false;
boolean rightPressed = false;

//bullet number//
int bulletNum = 0;
boolean [] bulletLimit = new boolean[5];

void setup () {    
  size (640,480) ;
  for (int i = 0; i < 5; i++){
    boom[i] = loadImage ("img/flame" + (i+1) + ".png" );
  }
  start2 = loadImage ("img/start2.png");
  start1 = loadImage ("img/start1.png");  
  bg1 = loadImage ("img/bg1.png");
  bg2 = loadImage ("img/bg2.png");
  hp = loadImage ("img/hp.png");
  gift = loadImage ("img/treasure.png");
  player = loadImage ("img/fighter.png");
  enemy = loadImage ("img/enemy.png");  
  end2 = loadImage ("img/end2.png");
  end1 = loadImage ("img/end1.png");
  bullet = loadImage ("img/shoot.png");
  
  gameState = 0;
  enemyState = 0;
  life = 70; 
  giftX = floor(random(50, width-40));
  giftY = floor(random(50, height-60));
  playerX = width-60 ;
  playerY = height/2 ; 

  //speed//
  playerSpeed = 5;
  enemySpeed = 5;
  bulletSpeed = 6;
  
  //flame//
  flameCount = 0;
  flameCurrent = 0;
  for (int i = 0; i < hitPosition.length; i++){
    hitPosition[i][0] = 2000;
    hitPosition[i][1] = 2000;
  }

  //no bullet//
  for (int i = 0; i < bulletLimit.length; i++){
    bulletLimit[i] = false;
  }

  //enemy line//  
  spacingY = -60; 
  enemyY = floor(random(1, 415));    
  for (int i = 0; i < 5; i++){
   enemyPosition[i] = loadImage ("img/enemy.png");  
   enemy_straight[i][0] = spacingX;
   enemy_straight[i][1] = enemyY; 
   spacingX -= 65;
  }
  frameRate(60); 
  board = createFont("Times New Roman", 24);
  textFont(board, 24);
  textAlign(LEFT);
}


void draw() {  
  switch (gameState) {
    case GAME_START:
      image(start2,0,0);
    if(mousePressed) {
      gameState = GAME_PLAY;}else {
        if(mouseX >= width/3 && mouseX <= 2*width/3 && mouseY >=380 && mouseY <=415) {
          image(start1,0,0);
        }
  }
  break;
    case GAME_PLAY:
      //bg
      image (bg2, bgX, 0);
      image (bg1, bgX-640, 0);
      image (bg2, bgX-1280, 0); 
      bgX += 1;
      bgX %= 1280;
      
      //gift//
      image (gift, giftX, giftY);    
      
      //player//
      image(player, playerX, playerY);
      
      if (upPressed && playerY > 0) {
        playerY -= playerSpeed ;
      }
      if (downPressed && playerY < 480 - 50) {
        playerY += playerSpeed ;
      }
      if (leftPressed && playerX > 0) {
        playerX -= playerSpeed ;
      }
      if (rightPressed && playerX < 640 - 50) {
        playerX += playerSpeed ;
      }  
        
      //flame//
      image(boom[flameCurrent], hitPosition[flameCurrent][0], hitPosition[flameCurrent][1]);      
      flameCount ++;
      if (flameCount % 6 == 0){
        flameCurrent++;
      } 
      if (flameCurrent > 4){
        flameCurrent = 0;
      }
      //flameCountboom
      if(flameCount > 30){
        for (int i = 0; i < 5; i ++){
          hitPosition[i][0] = 1000;
          hitPosition[i][1] = 1000;
        }
      }   
      
     //bullet//
      for (int i = 0; i < 5; i ++){
        if (bulletLimit[i] == true){
          image (bullet, bulletX[i], bulletY[i]);
          bulletX[i] -= bulletSpeed;
        }
        if (bulletX[i] < -bullet.width){
          bulletLimit[i] = false;
        }
      }
    
      //enemy//
      switch (enemyState) { 
        case 0 :               
          for (int i = 0; i < 5; i++){
            image(enemyPosition[i], enemy_straight[i][0], enemy_straight[i][1]);
            //bullet hit//
            for (int j = 0; j < 5; j++){
              closestEnemy1(bulletX[j],bulletY[j]);
              if(closestEnemy1(bulletX[j],bulletY[j])<500){
                if(enemy_straight[i][1]<bulletY[j]){bulletY[j]--;}
                if(enemy_straight[i][1]>bulletY[j]){bulletY[j]++;}
              }
              if(getHit(bulletX[j], bulletY[j], bullet.width, bullet.height, enemy_straight[i][0], enemy_straight[i][1], enemy.width, enemy.height) == true && bulletLimit[j] == true){
                for (int k = 0;  k < 5; k++){
                  hitPosition[k][0] = enemy_straight[i][0];
                  hitPosition[k][1] = enemy_straight[i][1];
                }    
                enemy_straight[i][1] = -200;
                enemyY = floor(random(30,240));
                bulletLimit[j] = false;
                flameCount = 0; 
                scoreChange(20);
              }
            }  
            //player got hit//
            if(getHit(playerX, playerY ,player.width, player.height,  enemy_straight[i][0], enemy_straight[i][1], enemy.width, enemy.height) == true){
              for (int j = 0;  j < 5; j++){
                hitPosition [j][0] = enemy_straight[i][0];
                hitPosition [j][1] = enemy_straight[i][1];
              }
              life -= 40;          
              enemy_straight [i][1] = -200;
              enemyY = floor(random(30,240));
              flameCount = 0; 
            }
            else if(life <= 30){
              life=30;
              gameState = GAME_LOSE;
              life = 70;
              playerX = (width-65);
              playerY = height/2 ;
            } 
            else{
              enemy_straight[i][0] += enemySpeed;
              enemy_straight[i][0] %= 1280;
            }      
          }
          //NEXT//
          if (enemy_straight[enemy_straight.length-1][0] > width+100) {        
            enemyY = floor(random(30,240));            
            spacingX = 0;  
            for (int i = 0; i < 5; i++){
              enemy_slope[i][0] = spacingX;
              enemy_slope[i][1] = enemyY - spacingX / 2;
              spacingX -= 65;                 
            }
            enemyState = 1;
          }
        break ; 
        
        case 1 :
          for (int i = 0; i < 5; i++){
            image(enemyPosition[i], enemy_slope [i][0] , enemy_slope [i][1]);
            //bullet hit//
            for(int j = 0; j < 5; j++){
              closestEnemy2(bulletX[j],bulletY[j]);
              if(closestEnemy2(bulletX[j],bulletY[j])<600){
                if(enemy_slope[i][1]<bulletY[j]){bulletY[j]--;}
                if(enemy_slope[i][1]>bulletY[j]){bulletY[j]++;}
              }
              if (getHit(bulletX[j], bulletY[j], bullet.width, bullet.height, enemy_slope [i][0], enemy_slope [i][1], enemy.width, enemy.height) == true && bulletLimit[j] == true){
                for(int k = 0; k < 5; k++){
                  hitPosition [k][0] = enemy_slope [i][0];
                  hitPosition [k][1] = enemy_slope [i][1];
                }     
                enemy_slope [i][1] = -1000;
                enemyY = floor(random(30,240));
                bulletLimit[j] = false;
                flameCount = 0;
                scoreChange(20);
              }
            }   
            //player got hit//
            if(getHit(playerX, playerY ,player.width, player.height,  enemy_slope[i][0], enemy_slope[i][1], enemy.width, enemy.height) == true){
              for(int j = 0; j < 5; j++){
                 hitPosition [j][0] = enemy_slope [i][0];
                 hitPosition [j][1] = enemy_slope [i][1];
               }
              enemy_slope [i][1] = -1000;
              enemyY = floor(random(200,280));
              flameCount = 0; 
              life -= 40;
            }
            else if(life<=30){
              life=30;
              gameState = GAME_LOSE;
              life = 70;
              playerX = (width-65);
              playerY = height/2;
            } 
            else{
              enemy_slope[i][0] += enemySpeed;
              enemy_slope[i][0] %= 1280;
            }         
          }
          
          //NEXT//
          if(enemy_slope[4][0] > width + 100){
            enemyY = floor(random(200,280));
            enemyState = 2;            
            spacingX = 0;  
            spacingY = -60; 
            for(int i = 0; i < 8; i ++){
              if(i < 3) {
                enemy_daimond [i][0] = spacingX;
                enemy_daimond [i][1] = enemyY - spacingX;
                spacingX -= 60;
              } 
              else if(i == 3){
                enemy_daimond[i][0] = spacingX;
                enemy_daimond[i][1] = enemyY - spacingY;
                spacingX -= 60;
                spacingY += 60;
              } 
              else if(i > 3 && i <= 5){
                  enemy_daimond[i][0] = spacingX;
                  enemy_daimond[i][1] = enemyY + spacingY;
                  spacingX += 60;
                  spacingY -= 60;
              } 
              else{
                  enemy_daimond[i][0] = spacingX;
                  enemy_daimond[i][1] = enemyY + spacingY;
                  spacingX += 60;
                  spacingY += 60;
              }            
            }     
          }
        break ;        
        
        case 2 :  
          for(int i = 0; i < 8; i++){
            image(enemy, enemy_daimond[i][0], enemy_daimond[i][1]);     
            //bullet hit     
            for(int j = 0; j < 5; j++ ){
              closestEnemy3(bulletX[j],bulletY[j]);
              if(closestEnemy3(bulletX[j],bulletY[j])<600){
                if(enemy_daimond[i][1]<bulletY[j]){bulletY[j]--;}
                if(enemy_daimond[i][1]>bulletY[j]){bulletY[j]++;}
              }
              if (getHit(bulletX[j], bulletY[j], bullet.width, bullet.height, enemy_daimond[i][0], enemy_daimond[i][1], enemy.width, enemy.height) == true && bulletLimit[j] == true){
                for (int s = 0;  s < 5; s++){
                  hitPosition[s][0] = enemy_daimond [i][0];
                  hitPosition[s][1] = enemy_daimond [i][1];
                }
                enemy_daimond[i][1] = -1000;
                enemyY = floor( random(30,240));
                bulletLimit[j] = false;
                flameCount = 0; 
                scoreChange(20);
              }
            }       
            //player get hit//
            if ( getHit(playerX, playerY ,player.width, player.height,  enemy_daimond[i][0], enemy_daimond[i][1], enemy.width, enemy.height) == true){ 
              for ( int j = 0;  j < 5; j++ ){
                hitPosition[j][0] = enemy_daimond [i][0];
                hitPosition[j][1] = enemy_daimond [i][1];
              }
              life -= 40;
              enemy_daimond[i][1] = -1000;
              enemyY = floor(random(50,420));
              flameCount = 0; 
            } else if ( life <=30 ) {
              life=30;
              gameState = GAME_LOSE;
              life = 70;
              playerX = 575 ;
              playerY = height/2 ;
            } else {
              enemy_daimond[i][0] += enemySpeed;
              enemy_daimond[i][0] %= 1920;
            }     
          }
          
          //AGAIN//
          if(enemy_daimond[4][0] > width + 300){
            enemyY = floor(random(1,415));
            spacingX = 0;       
            for (int i = 0; i < 5; i++){
              enemy_straight [i][1] = enemyY; 
              enemy_straight [i][0] = spacingX;
              spacingX -= 65;
            } 
            enemyState = 0;            
          }  
        break ;
      }

     //hp
      strokeWeight(20);
      stroke(#FF0000);
      line(30, 32, life, 32);
      image(hp, 20, 20);   
      //get gift
      if(getHit(giftX, giftY, gift.width, gift.height, playerX, playerY, player.width, player.height) == true){    
              life += 20;
              giftX = floor(random(50,600));         
              giftY = floor(random(50,420));
      }
      if(life >= 220){
        life = 220;
      }
      
      fill(255);
      text("Score:" + scoreNum, 10, 470);
    break ;  
    
    
    case GAME_LOSE :
      image(end2, 0, 0);     
      if(mouseX > 200 && mouseX < 470 && mouseY > 300 && mouseY < 350){
            image(end1, 0, 0);
            if(mousePressed){
              giftX = floor(random(50,600));
              giftY = floor(random(50,420));      
              enemyState = 0;      
              spacingX = 0;       
              for (int i = 0; i < 5; i++){
                hitPosition[i][0] = 1000;
                hitPosition[i][1] = 1000;
                bulletLimit[i] = false;
                enemy_straight[i][0] = spacingX;
                enemy_straight[i][1] = enemyY; 
                spacingX -= 65;
                scoreNum = 0;
              }
              gameState = GAME_PLAY;
            }
      }
    break ;
  }  
}


void keyPressed (){
  if (key == CODED) {
    switch (keyCode) {
      case UP :
        upPressed = true ;
        break ;
      case DOWN :
        downPressed = true ;
        break ;
      case LEFT :
        leftPressed = true ;
        break ;
      case RIGHT :
        rightPressed = true ;
        break ;
    }
  }
}
  
  
void keyReleased () {
  if (key == CODED) {
    switch (keyCode) {
      case UP : 
        upPressed = false ;
        break ;
      case DOWN :
        downPressed = false ;
        break ;
      case LEFT :
        leftPressed = false ;
        break ;
      case RIGHT :
        rightPressed = false ;
        break ;
    }  
  }  
  //shoot bullet
  if (keyCode == ' '){
    if (gameState == GAME_PLAY){
      if (bulletLimit[bulletNum] == false){
        bulletLimit[bulletNum] = true;
        bulletX[bulletNum] = playerX - 10;
        bulletY[bulletNum] = playerY + player.height/2;
        bulletNum ++;
      }   
      if (bulletNum > 4) {
        bulletNum = 0;
      }
    }
  }
}
void scoreChange(int value){
  scoreNum += value;
}

boolean getHit(float ax, float ay, float aw, float ah, float bx, float by, float bw, float bh){
  if (ax >= bx - aw && ax <= bx + bw && ay >= by - ah && ay <= by + bh){
  return true;
  }
  return false;
}
float closestEnemy1(float x, float y){
  for(int i = 0; i < 5; i++){
    if(dist(enemy_straight[i][0], enemy_straight[i][1], x, y)<895){
      float a = dist(enemy_straight[i][0], enemy_straight[i][1], x, y);
      println(a);
      return a;
    }
  }
  println("-1");
  return -1;
}
float closestEnemy2(float x, float y){
  for(int i = 0; i < 5; i++){
    if(dist(enemy_slope[i][0], enemy_slope[i][1], x, y)<895){
      float a = dist(enemy_slope[i][0], enemy_slope[i][1], x, y);
      println(a);
      return a;
    }
  }
  println(-1);
  return -1;
}
float closestEnemy3(float x, float y){
  for(int i = 0; i < 8; i++){
    if(dist(enemy_daimond[i][0], enemy_daimond[i][1], x, y)<895){
      float a = dist(enemy_daimond[i][0], enemy_daimond[i][1], x, y);
      println(a);
      return a;
    }
  }
  println(-1);
  return -1;
}

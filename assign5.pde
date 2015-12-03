PImage start2,  start1, treasure, fighter, enemy, end2, end1, bullet, bg1, bg2, hp;
float bgMoving;
PFont board;
int scoreNum = 0;

int gameState;
final int GAME_START = 0;
final int GAME_PLAY = 1;
final int GAME_LOSE = 2;

int enemyState;
final int enemyStraight = 0;
final int enemySlope = 1;
final int enemyDaimond = 2;

int life;

//enemy
PImage [] enemyPosition = new PImage [5];
float enemyC [][] = new float [5][2];       
float enemyB [][] = new float [5][2];
float enemyA [][] = new float [8][2];  
float spacingX;
float spacingY;

//flame
int flameNum;
int flameCurrent;
PImage [] hit = new PImage [5];
float hitPosition [][] = new float [5][2]; 

float treasureX, treasureY, fighterX, fighterY, enemyY;
float [] bulletX = new float [5];
float [] bulletY = new float [5];

float fighterSpeed;
float enemySpeed;
int bulletSpeed;

boolean upPressed = false;
boolean downPressed = false;
boolean leftPressed = false;
boolean rightPressed = false;

//bullet number
int bulletNum = 0;
boolean [] bulletLimit = new boolean[5];

void setup () {    
  size (640,480) ;
  frameRate(60); 
  for ( int i = 0; i < 5; i++ ){
    hit[i] = loadImage ("img/flame" + (i+1) + ".png" );
  }
  start2 = loadImage ("img/start2.png");
  start1 = loadImage ("img/start1.png");  
  bg1 = loadImage ("img/bg1.png");
  bg2 = loadImage ("img/bg2.png");
  hp = loadImage ("img/hp.png");
  treasure = loadImage ("img/treasure.png");
  fighter = loadImage ("img/fighter.png");
  enemy = loadImage ("img/enemy.png");  
  end2 = loadImage ("img/end2.png");
  end1 = loadImage ("img/end1.png");
  bullet = loadImage ("img/shoot.png");
  
  gameState = GAME_START;
  enemyState = 0;
  life = 70; 
  treasureX = floor( random(50, width - 40) );
  treasureY = floor( random(50, height - 60) );
  fighterX = width - 65 ;
  fighterY = height / 2 ; 

  //speed
  fighterSpeed = 5;
  enemySpeed = 5;
  bulletSpeed = 6;
  
  //flame
  flameNum = 0;
  flameCurrent = 0;
  for ( int i = 0; i < hitPosition.length; i ++){
    hitPosition[i][0] = 2000;
    hitPosition[i][1] = 2000;
  }

  //no bullet
  for (int i =0; i < bulletLimit.length ; i ++){
    bulletLimit[i] = false;
  }

  //enemy line
  spacingX = 0;  
  spacingY = -60; 
  enemyY = floor(random(80, 400));    
  for (int i = 0; i < 5; i++){
   enemyPosition [i] = loadImage ("img/enemy.png");  
   enemyC [i][0] = spacingX;
   enemyC [i][1] = enemyY; 
   spacingX -= 80;
  }
  
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
      image (bg2, bgMoving, 0);
      image (bg1, bgMoving-640, 0);
      image (bg2, bgMoving-1280, 0); 
      
      bgMoving += 1;
      bgMoving %= 1280;
      
      //treasure
      image (treasure, treasureX, treasureY);    
      
      //fighter
      image(fighter, fighterX, fighterY);
      
      if (upPressed && fighterY > 0) {
        fighterY -= fighterSpeed ;
      }
      if (downPressed && fighterY < 480 - 50) {
        fighterY += fighterSpeed ;
      }
      if (leftPressed && fighterX > 0) {
        fighterX -= fighterSpeed ;
      }
      if (rightPressed && fighterX < 640 - 50) {
        fighterX += fighterSpeed ;
      }  
        
      //flame
      image(hit[flameCurrent], hitPosition[flameCurrent][0], hitPosition[flameCurrent][1]);      
      flameNum ++;
      if ( flameNum % 6 == 0){
        flameCurrent ++;
      } 
      if ( flameCurrent > 4){
        flameCurrent = 0;
      }
      //flame buring
      if(flameNum > 31){
        for (int i = 0; i < 5; i ++){
          hitPosition[i][0] = 1000;
          hitPosition[i][1] = 1000;
        }
      }   
      
     //bullet
      for (int i = 0; i < 5; i ++){
        if (bulletLimit[i] == true){
          image (bullet, bulletX[i], bulletY[i]);
          bulletX[i] -= bulletSpeed;
        }
        if (bulletX[i] < - bullet.width){
          bulletLimit[i] = false;
        }
      }
    
      //enemy
      switch (enemyState) { 
        case 0 :               
          for ( int i = 0; i < 5; i++ ){
            image(enemyPosition[i], enemyC [i][0], enemyC [i][1]);
            //bullet hit
            for (int j = 0; j < 5; j++ ){
              if(getHit(bulletX[j], bulletY[j], bullet.width, bullet.height, enemyC[i][0], enemyC[i][1], enemy.width, enemy.height) == true && bulletLimit[j] == true){
                for (int k = 0;  k < 5; k++ ){
                  hitPosition [k][0] = enemyC [i][0];
                  hitPosition [k][1] = enemyC [i][1];
                }    
                enemyC [i][1] = -1000;
                enemyY = floor(random(30,240));
                bulletLimit[j] = false;
                flameNum = 0; 
                scoreChange(20);
              }
            }  
            //fighter get hit
            if(getHit(fighterX, fighterY ,fighter.width, fighter.height,  enemyC[i][0], enemyC[i][1], enemy.width, enemy.height) == true){
              for (int j = 0;  j < 5; j++){
                hitPosition [j][0] = enemyC [i][0];
                hitPosition [j][1] = enemyC [i][1];
              }
              life -= 40;          
              enemyC [i][1] = -1000;
              enemyY = floor( random(30,240) );
              flameNum = 0; 
            }else if(life <= 30){
              life=30;
              gameState = GAME_LOSE;
              life = 70;
              fighterX = (width - 65);
              fighterY = height / 2 ;
            } else {
              enemyC [i][0] += enemySpeed;
              enemyC [i][0] %= 1280;
            }      
          }
          //NEXT
          if (enemyC [enemyC.length-1][0] > 640+100 ) {        
            enemyY = floor(random(30,240));            
            spacingX = 0;  
            for (int i = 0; i < 5; i++){
              enemyB [i][0] = spacingX;
              enemyB[i][1] = enemyY - spacingX / 2;
              spacingX -= 80;                 
            }
            enemyState = 1;
          }
        break ; 
        
        case 1 :
          for (int i = 0; i < 5; i++ ){
            image(enemyPosition[i], enemyB [i][0] , enemyB [i][1]);
            //bullet hit
            for(int j = 0; j < 5; j++){
              if (getHit(bulletX[j], bulletY[j], bullet.width, bullet.height, enemyB [i][0], enemyB [i][1], enemy.width, enemy.height) == true && bulletLimit[j] == true){
                for(int k = 0;  k < 5; k++ ){
                  hitPosition [k][0] = enemyB [i][0];
                  hitPosition [k][1] = enemyB [i][1];
                }     
                enemyB [i][1] = -1000;
                enemyY = floor(random(30,240));
                bulletLimit[j] = false;
                flameNum = 0;
                scoreChange(20);
              }
            }   
            //fighter get hit
            if ( getHit(fighterX, fighterY ,fighter.width, fighter.height,  enemyB[i][0], enemyB[i][1], enemy.width, enemy.height) == true){
              for (int j = 0;  j < 5; j++ ){
                 hitPosition [j][0] = enemyB [i][0];
                 hitPosition [j][1] = enemyB [i][1];
               }
              enemyB [i][1] = -1000;
              enemyY = floor(random(200,280));
              flameNum = 0; 
              life -= 40;
            }else if(life<=30){
              life=30;
              gameState = GAME_LOSE;
              life = 70;
              fighterX = (width - 65);
              fighterY = height / 2 ;
            } else {
              enemyB [i][0] += enemySpeed;
              enemyB [i][0] %= 1280;
            }         
          }
          
          //NEXT
          if (enemyB [4][0] > 640 + 100){
            enemyY = floor( random(200,280) );
            enemyState = 2;            
            spacingX = 0;  
            spacingY = -60; 
            for ( int i = 0; i < 8; i ++ ) {
              if ( i < 3 ) {
                enemyA [i][0] = spacingX;
                enemyA [i][1] = enemyY - spacingX;
                spacingX -= 60;
              } else if ( i == 3 ){
                enemyA [i][0] = spacingX;
                enemyA [i][1] = enemyY - spacingY;
                spacingX -= 60;
                spacingY += 60;
              } else if ( i > 3 && i <= 5 ){
                  enemyA [i][0] = spacingX;
                  enemyA [i][1] = enemyY + spacingY;
                  spacingX += 60;
                  spacingY -= 60;
              } else {
                  enemyA [i][0] = spacingX;
                  enemyA [i][1] = enemyY + spacingY;
                  spacingX += 60;
                  spacingY += 60;
              }            
            }     
          }
        break ;        
        
        case 2 :  
          for( int i = 0; i < 8; i++ ){
            image(enemy, enemyA [i][0], enemyA [i][1]);     
            //bullet hit     
            for( int j = 0; j < 5; j++ ){
              if ( getHit(bulletX[j], bulletY[j], bullet.width, bullet.height, enemyA[i][0], enemyA[i][1], enemy.width, enemy.height) == true && bulletLimit[j] == true){
                for (int s = 0;  s < 5; s++){
                  hitPosition [s][0] = enemyA [i][0];
                  hitPosition [s][1] = enemyA [i][1];
                }
                enemyA [i][1] = -1000;
                enemyY = floor( random(30,240));
                bulletLimit[j] = false;
                flameNum = 0; 
                scoreChange(20);
              }
            }       
            //fighter get hit
            if ( getHit(fighterX, fighterY ,fighter.width, fighter.height,  enemyA[i][0], enemyA[i][1], enemy.width, enemy.height) == true){ 
              for ( int j = 0;  j < 5; j++ ){
                hitPosition [j][0] = enemyA [i][0];
                hitPosition [j][1] = enemyA [i][1];
              }
              life -= 40;
              enemyA [i][1] = -1000;
              enemyY = floor(random(50,420));
              flameNum = 0; 
            } else if ( life <=30 ) {
              life=30;
              gameState = GAME_LOSE;
              life = 70;
              fighterX = 575 ;
              fighterY = height/2 ;
            } else {
              enemyA [i][0] += enemySpeed;
              enemyA [i][0] %= 1920;
            }     
          }
          
          //AGAIN
          if(enemyA [4][0] > 640 + 300 ){
            enemyY = floor(random(80,400));
            spacingX = 0;       
            for (int i = 0; i < 5; i++ ){
              enemyC [i][1] = enemyY; 
              enemyC [i][0] = spacingX;
              spacingX -= 80;
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
      //get treasure
      if(getHit(treasureX, treasureY, treasure.width, treasure.height, fighterX, fighterY, fighter.width, fighter.height) == true){    
              life += 20;
              treasureX = floor(random(50,600));         
              treasureY = floor(random(50,420));
      }
      if(life >= 220){
        life = 220;
      }
      
      fill(255);
      text("Score:" + scoreNum, 10, 470);
    break ;  
    
    
    case GAME_LOSE :
      image(end2, 0, 0);     
      if ( mouseX > 200 && mouseX < 470 
        && mouseY > 300 && mouseY < 350){
            image(end1, 0, 0);
            if(mousePressed){
              treasureX = floor( random(50,600) );
              treasureY = floor( random(50,420) );      
              enemyState = 0;      
              spacingX = 0;       
              for (int i = 0; i < 5; i++ ){
                hitPosition [i][0] = 1000;
                hitPosition [i][1] = 1000;
                bulletLimit[i] = false;
                enemyC [i][0] = spacingX;
                enemyC [i][1] = enemyY; 
                spacingX -= 80;
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
    switch ( keyCode ) {
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
    switch ( keyCode ) {
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
  if ( keyCode == ' '){
    if (gameState == GAME_PLAY){
      if (bulletLimit[bulletNum] == false){
        bulletLimit[bulletNum] = true;
        bulletX[bulletNum] = fighterX - 10;
        bulletY[bulletNum] = fighterY + fighter.height/2;
        bulletNum ++;
      }   
      if ( bulletNum > 4 ) {
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

import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

Minim minim;
AudioPlayer bounceSound;
AudioPlayer scoreSound;
AudioPlayer victoryMusic;

//Paddles
int paddleX1 = 60;
int paddleX2 = displayWidth - 100;
int p1Score = 0;
int p2Score = 0;
int paddleHeight = 300;
int paddleY1 = (displayHeight/2)+paddleHeight/2;
int paddleY2 = (displayHeight/2)+paddleHeight/2;

//Ball
float ballXPos = 100;
float ballYPos = (displayHeight/2)+150;
float xSpeed = 0;
float ySpeed = 0;
int xDirection = 1;
int yDirection = 1;
int radius = 20;

boolean pressedKeys[] = new boolean[4];
boolean ballLaunched = false;
boolean p1HasBall = true;
boolean p2HasBall = false;
boolean winState = false;

//Konami
boolean firstMove = true;
boolean konami = false;
char konamiKeys[] = new char[11];
int konamiKeyCounter = 0;


boolean sketchFullScreen(){
  return true;
}


void setup(){
  size(displayWidth, displayHeight);
  background(0);
  frameRate(60);
  noStroke();
  ellipseMode(RADIUS);
  textSize(32);
  colorMode(RGB, 20);
  minim = new Minim(this);
  bounceSound = minim.loadFile("pong_bounce.mp3");
  scoreSound = minim.loadFile("pong_score.mp3");
  victoryMusic = minim.loadFile("pong_victory.mp3");
}

void draw(){
  if(winState){
    if(p1Score == 7){
      if(!konami){
        victoryMusic.play();
      }
      text("Player 1 wins!", (displayWidth/2)-150, displayHeight/2);
      text("Press escape to quit", (displayWidth/2)-150, displayHeight/2 + 50);
    }
    else if(p2Score == 7){
      if(!konami){
        victoryMusic.play();
      }
      text("Player 2 wins!", (displayWidth/2)-150, displayHeight/2);
      text("Press escape to quit", (displayWidth/2)-150, displayHeight/2 + 50);
    }
  }
  else{
    if(!ballLaunched){
      clear();
      goToStart();
    }
    if(ballLaunched){
      clear();
      processKeys();
      processBall();
    }
  }
  rect(paddleX1, paddleY1, 40 , paddleHeight);
  if(!konami){
    fill(20);
  }
  if(konami){
    fill(randomColor(), randomColor(), randomColor());
  }
  rect(paddleX2, paddleY2, 40, paddleHeight);
  if(!konami){
    fill(20);
  }
  if(konami){
    fill(randomColor(), randomColor(), randomColor());
  }
  ellipse(ballXPos, ballYPos, radius, radius);
  if(!konami){
    fill(20);
  }
  if(konami){
    fill(randomColor(), randomColor(), randomColor());
  }
  text(p1Score, (displayWidth/2) - 100, 40);
  text(p2Score, (displayWidth/2) + 100, 40);
}

void processBall(){
  if((ballYPos < radius) || (ballYPos > displayHeight - radius)){
    yDirection*=-1;
  }
  ballYPos += (ySpeed * yDirection);
  if(((ballXPos <= 100 + radius )&&(ballYPos>=paddleY1+radius && ballYPos<=paddleY1+300+radius))||
  ((ballXPos >= displayWidth-100-radius)&&(ballYPos>=paddleY2+radius && ballYPos<=paddleY2+300+radius))){
    xDirection*=-1;
    xSpeed++;
    if(!konami){
      bounceSound.play();
      bounceSound.rewind();
    }
    if((ballYPos == paddleY1 + paddleHeight/2) || (ballYPos == paddleY2 + paddleHeight/2)){
      ySpeed += 0;
    }
    else if((ballYPos < paddleY1 + paddleHeight/2) || (ballYPos < paddleY2 + paddleHeight/2)){
      if(ballXPos <= 100 +radius){
        ySpeed += ((paddleY1 + paddleHeight/2)-ballYPos)/10;
      }
      else{
        ySpeed += ((paddleY2 + paddleHeight/2)-ballYPos)/10;
      }
    }
    else if((ballYPos < paddleY1 + paddleHeight) || (ballYPos < paddleY2 + paddleHeight)){
      if(ballXPos <= 100 +radius){
        ySpeed += ((paddleY1 + paddleHeight)-ballYPos)/10;
      }
      else{
        ySpeed += ((paddleY2 + paddleHeight)-ballYPos)/10;
      }
    }
  }
  if(ballXPos <= radius){
    if(!konami){
      scoreSound.play();
      scoreSound.rewind();
    }
    p2Score++;
    p2HasBall = false;
    p1HasBall = true;
    ballLaunched = false;
    xDirection*=-1;
  }
  if(ballXPos >= displayWidth - radius){
    if(!konami){
      scoreSound.play();
      scoreSound.rewind();
    }
    p1Score++;
    p2HasBall = true;
    p1HasBall = false;
    ballLaunched = false;
    xDirection*=-1;
  }
  ballXPos += (xSpeed * xDirection);
}

void processKeys(){
  if (pressedKeys[0]){
    if(paddleY1 > 20){
        paddleY1-=20;
    }
  }
  if(pressedKeys[1]){
    if(paddleY1 + 300 < displayHeight - 20){
      paddleY1+=20;
    }
  }
  if(pressedKeys[2]){
    if(paddleY2 > 20){
      paddleY2-=20;
    }
  } 
  if(pressedKeys[3]){
    if(paddleY2 + 300 < displayHeight - 20){
      paddleY2+=20;
    }
  }
}

void goToStart(){
  /*
  *Reset the ball and paddles to the start position
  */
  xSpeed = 0;
  ySpeed = 0;
  
  paddleX1 = 60;
  paddleX2 = displayWidth - 100;
  paddleY1 = (displayHeight/2)-150;
  paddleY2 = (displayHeight/2)-150;
  if (p1HasBall){
    ballXPos = (100+radius);
    ballYPos = (displayHeight/2);
  }
  else{
    ballXPos = displayWidth - 100 - radius;
    ballYPos = (displayHeight/2);
  }
  if(p1Score == 7 || p2Score == 7){
    winState = true;
  }
  if(!winState){
    if(p1HasBall){
      text("Press 'One Player' to start", (displayWidth/2)-150, displayHeight/2);
    }
    else{
      text("Press 'Two Player' to start", (displayWidth/2)-150, displayHeight/2); 
    }
    text("Press 'Red: 2' to quit", (displayWidth/2)-150, displayHeight/2 + 50);
  }
}


void keyPressed() {
  if (key == Buttons.PLAYER_1_JOYSTICK_UP)  pressedKeys[0] = true;
  if (key == Buttons.PLAYER_1_JOYSTICK_DOWN)  pressedKeys[1] = true;
  if (key == Buttons.PLAYER_2_JOYSTICK_UP)  pressedKeys[2] = true;
  if (key == Buttons.PLAYER_2_JOYSTICK_DOWN)  pressedKeys[3] = true;

  //exiting
  if (key == Buttons.PLAYER_1_BUTTON_2 || key == Buttons.PLAYER_2_BUTTON_2){
     exit(); 
  }
  
  //Konami Code
  if(firstMove){
    if(konamiKeyCounter<11){
      konamiKeys[konamiKeyCounter] = key;
      konamiKeyCounter++;
      if(checkKonamiKeys()){
        konami = true;
      }
    }
    else{
      firstMove = false;
    }
  }
  
  if (!ballLaunched && ((p1HasBall && key == Buttons.PLAYER_1_START) || (p2HasBall && key == Buttons.PLAYER_2_START))){
    firstMove = false;
    ballLaunched = true;
    xSpeed = 10;
    ySpeed = 0;
  }
}
 
void keyReleased() {
  if (key == Buttons.PLAYER_1_JOYSTICK_UP)  pressedKeys[0] = false;
  if (key == Buttons.PLAYER_1_JOYSTICK_DOWN)  pressedKeys[1] = false;
  if (key == Buttons.PLAYER_2_JOYSTICK_UP)  pressedKeys[2] = false;
  if (key == Buttons.PLAYER_2_JOYSTICK_DOWN)  pressedKeys[3] = false;
}

float randomColor(){
  return random(21); 
}

boolean checkKonamiKeys(){
   if(konamiKeys[0] == Buttons.PLAYER_1_JOYSTICK_UP){
     if(konamiKeys[1] == Buttons.PLAYER_1_JOYSTICK_UP){
       if(konamiKeys[2] == Buttons.PLAYER_1_JOYSTICK_DOWN){
         if(konamiKeys[3] == Buttons.PLAYER_1_JOYSTICK_DOWN){
           if(konamiKeys[4] == Buttons.PLAYER_1_JOYSTICK_LEFT){
             if(konamiKeys[5] == Buttons.PLAYER_1_JOYSTICK_RIGHT){
               if(konamiKeys[6] == Buttons.PLAYER_1_JOYSTICK_LEFT){
                 if(konamiKeys[7] == Buttons.PLAYER_1_JOYSTICK_RIGHT){
                   if(konamiKeys[8] == Buttons.PLAYER_1_BUTTON_1){
                     if(konamiKeys[9] == Buttons.PLAYER_1_BUTTON_4){
                       if(konamiKeys[10] == Buttons.PLAYER_1_START){
                         return true;
                       }
                       else{return false;}//////AAHHHHHH It's so beautiful
                     }
                     else{return false;}
                   }
                   else{return false;}
                 }
                 else{return false;}
               }
               else{return false;}
             }
             else{return false;}
           }
           else{return false;}
         }
         else{return false;}
       }
       else{return false;}
     }
     else{return false;}
   }
   else{return false;}
}



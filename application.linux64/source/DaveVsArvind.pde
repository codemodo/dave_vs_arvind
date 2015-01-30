// "Dave vs. Arvind"
// by Alex Fiuk & James Park
// Game in which player controls Dr. Dave in an interstellar adventure in which he must dodge incoming Arvinds


// INITIALIZE VARIABLES
PImage imgDave;
PImage imgArvind;
int time;
int endTime;
boolean safe; 
int score;
int highScore;
int scoreIncrement;
boolean moveUp;
float meY;
float myDir;
ArrayList<Arvind> arvinds = new ArrayList();
ArrayList<Circle> circles = new ArrayList();
ArrayList<Star> stars = new ArrayList();

// SET UP
void setup(){
  size(1000, 500);
  frameRate(240);
  safe = true; 
  time = 0;
  endTime = 0;
  score = 0;
  scoreIncrement = 0;
  meY = 50;
  myDir = 0;
  arvinds = new ArrayList();
  circles = new ArrayList();
  stars = new ArrayList();
  imgDave = loadImage("matuszek.png");
  imgArvind = loadImage("arvind.png"); 
}

// DRAW FRAMES
void draw(){
 
  // end game if collision occurs
  if (!safe){
    drawEnding();
    return;
  }
  
  if (collision()) safe = false;
  
  // draw game components
  background(0);
  drawStars();
  drawArvinds();
  drawCircles(); // intentionally drawn in front of Arvinds for added difficulty
  drawDave();
  drawScore();
  drawHighScore();
  time +=1;
  
  // periodically remove objects from lists to prevent game slowdown
  if (time % 60 == 0){
    if (arvinds.size() > 20)
      arvinds.remove(0);
    arvinds.add(new Arvind());
  }
  if (time % 600 == 0){
    if (circles.size() > 4)
      circles.remove(0);
    circles.add(new Circle());
  }
  if (time % 5 == 0){
    if (stars.size() > 40)
      stars.remove(0);
    stars.add(new Star());
  }
}

// CONTROLS
// player will move up as long as mouse button is pressed; moves down otherwise
void mousePressed(){
  moveUp = true; 
}

void mouseReleased(){
  moveUp = false;
}

// CLASSES
class Star{
  
  color c;
  float xpos;
  float ypos;
  float count;
  
  Star(){
    c = color(255);
    xpos = width;
    ypos = random(0, height);
    count = 0;
  }
  
  void drawStar(){
    fill(c);
    xpos = xpos - count;
    ellipse(xpos, ypos, 5, 5);
    count += 0.1;
  }
}

class Arvind{
  
  float xpos;
  float ypos;
  float count;
  
  Arvind(){
    xpos = width;
    ypos = random(0, height);
    count = 0;
  }
  
  void drawArvind(){
    xpos = xpos - count;
    image(imgArvind, xpos, ypos);
    count += random(0, 0.02);
    if (score > 15){
      count += random(0, 0.07);
    }
    if (score > 25){
      count += random(0, 0.1);
    }
    if (score > 40){
      count += random(0, 0.14);
    }
    if (score > 55){
      count += random(0, 0.3);
    }  
  }
}

class Circle{
  
  color c;
  float xpos;
  float ypos;
  float xsize;
  float ysize;
  float count;
  
  Circle(){
    c = color(255);
    xpos = width + 50;
    ypos = random(0, height);
    xsize = random(10, 250);
    ysize = xsize; 
    count = 0;
  }
  
  void drawCircle(){
    fill(c);
    ellipse(xpos - count, ypos, xsize, ysize);
    count += 1;
  }
}

// FUNCTIONS
// score increments each second
void drawScore(){
  fill(255, 255, 255);
  textSize(24);
  text("Score:  " + score, 20, 30);
  if (time % 240 == 0 ){
    score += 1;
  }
}

// draws high score across rounds
void drawHighScore(){
  fill(255, 255, 255);
  textSize(24);
  text("High Score:  " + highScore, 20, 60); 
}

// draws end of round; called when collision detected
void drawEnding(){
  background(255, 0, 0);
  fill(255, 255, 255);
  textSize(100);
  text("YOU LOSE!", 250, 265);
  endTime += 1;
  drawScore();
  drawHighScore();
  if (endTime > 300){
  restart();
  }
}

// frames used in between rounds
void restart(){
  background(255, 255, 255);
  
  // saves high score across rounds
  if (score > highScore){
    highScore = score;
  } 
  
  fill(0, 0, 0);
  
  // text displayed changes as game prepares to restart
  textSize(45);
  if (300 < endTime && endTime < 500){
  text("Restarting game", 290, 240);
  }
  else if (500 < endTime  && endTime < 800){
    text("Restarting game.", 290, 240);
  }
  else if (800 < endTime && endTime < 1100){
    text("Restarting game..", 290, 240);
  }
  else if (1100 < endTime && endTime < 1400){
    text("Restarting game...", 290, 240);
  }
  else if (endTime > 1400){
  setup();
  }
}

// draw player's character
void drawDave(){
  if (moveUp) {
    myDir = -2;
  } else {
    myDir = 0.8;
  }
  image(imgDave, 120, meY);
  meY = meY + 1 * myDir;
}

// draw incoming enemies
void drawArvinds(){
  for (Arvind arvind : arvinds){
    arvind.drawArvind();
  }
}

// draw planets in background
void drawCircles(){
  for (Circle circle : circles){
    circle.drawCircle();
  }
}  

// draw stars in background
void drawStars(){
  for (Star star : stars){
    star.drawStar();
  }
}  

// detect collision
boolean collision(){
 
  // collision between player and incoming enemies
  for (Arvind arvind : arvinds){
    if ((arvind.xpos < 160) && (arvind.xpos > 120) && (abs(meY - arvind.ypos) < 50)) return true;
  }
 
  // collision between player and upper/lower bounds of frame
  if ((meY < 5) || (meY > height - 50)) return true;
  
  return false;
}

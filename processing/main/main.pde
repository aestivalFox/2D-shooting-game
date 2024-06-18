import  ddf.minim.*;
import processing.serial.*;
Minim minim;  //新增minim變數
AudioPlayer play_shoot;
AudioPlayer play_enemy_dead;
AudioPlayer play_respawn;
AudioPlayer play_game;
AudioPlayer play_win;
AudioPlayer play_lose;
Serial myPort;  // Create object from Serial class
int val;      // Data received from the serial port
int movement=0;
int ifshoot=0;
int singleshot=0;
int num_enemy=1000;
int rows, cols;
int cellWidth, cellHeight;

Player p;
Enemy[] enemies;
boolean left, up, right, down;

PImage playerArt, enemyArt, largeP, largeE;
PFont eightBitFont;

String gameState;
Enemy currentEnemy;
int score;

int facing=0;
ArrayList<bullet> bulletList;
ArrayList<Enemy> enemyList;
//tilemap
////1 is wall
////0 is floor
int [][] tilemap = {
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
  {1, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1},
  {1, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 1, 0, 1},
  {1, 0, 0, 1, 1, 0, 1, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 1, 0, 1, 1, 0, 1},
  {1, 1, 1, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1},
  {1, 0, 0, 0, 0, 1, 1, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1},
  {1, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 1, 1, 0, 0, 0, 1, 0, 1},
  {1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 1, 0, 1, 1, 0, 1},
  {1, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 0, 1},
  {1, 0, 0, 0, 0, 1, 0, 1, 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 1, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1},
  {1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
};


void setup() {
  String portName ="COM3";
  myPort = new Serial(this, portName, 115200);
  
  size(1200, 675);
  rows = tilemap.length;
  cols = tilemap[0].length;
  cellWidth = 60;
  cellHeight = 45;

  p = new Player();
  enemies = new Enemy[num_enemy];
  bulletList=new ArrayList<bullet>();
  enemyList=new ArrayList<Enemy>();
  for (int i = 0; i < enemies.length; i++) {
    enemies[i] = new Enemy(createRandomEnemyStart());
    enemyList.add(enemies[i]);
  }

  left = false;
  up = false;
  right = false;
  down = false;

  playerArt = loadImage("data/RunSheet.png");
  enemyArt = loadImage("data/characters2x.png");
  largeP = loadImage("data/uniBig.png");
  largeE = loadImage("data/enemyBig.png");
  eightBitFont = createFont("data/8-Bit-Madness.ttf", 64);
  textFont(eightBitFont);
  
  minim = new Minim(this); 
  play_shoot = minim.loadFile("data/shoot_lower.mp3");
  play_enemy_dead = minim.loadFile("data/pixel_enemy_death.mp3");
  play_respawn = minim.loadFile("data/respawn.mp3");
  play_game = minim.loadFile("data/pixel_loop.mp3");
  play_win = minim.loadFile("data/pixel_win.mp3");
  play_lose = minim.loadFile("data/pixel_lose.mp3");

  gameState = "GAME";
  score = 0;
  noStroke();
  
  
}//end setup

void draw() {
  if(gameState=="GAME"){
    playGame();
    play_win.pause();
    play_lose.pause();
    if(!play_game.isPlaying())play_game.rewind();
    play_game.play();  
  }
  else if (gameState == "WIN"){
    playWin();
    play_game.pause();
    play_lose.pause();
    if(!play_win.isPlaying())play_win.rewind();
    play_win.play();
  }
  else if (gameState == "LOSE"){
    playLose();
    play_game.pause();
    play_win.pause();
    if(!play_lose.isPlaying())play_lose.rewind();
    play_lose.play();
  }
  
  if(enemyList.size()==0)gameState = "WIN";
  if(p.life==0)gameState = "LOSE";
  
/*
  text(mouseX, mouseX - 30, mouseY - 10);
  text(mouseY, mouseX, mouseY - 10);
*/
}//end draw

void serialEvent(final Serial s) {
  val = s.read();
  //println(val);
  movement=val&0b01111;
  switch(movement){
    case 0b00001:
      up = true;
      right = false;
      down = false;
      left = false;
      facing=1;
      break;
    case 0b00011:
      up = true;
      right = true;
      down = false;
      left = false;
      facing=2;
      break;
    case 0b00010:
      up = false;
      right = true;
      down = false;
      left = false;
      facing=3;
      break;
    case 0b00110:
      up = false;
      right = true;
      down = true;
      left = false;
      facing=4;
      break;
    case 0b00100:
      up = false;
      right = false;
      down = true;
      left = false;
      facing=5;
      break;
    case 0b01100:
      up = false;
      right = false;
      down = true;
      left = true;
      facing=6;
      break;
    case 0b01000:
      up = false;
      right = false;
      down = false;
      left = true;
      facing=7;
      break;
    case 0b01001:
      up = true;
      right = false;
      down = false;
      left = true;
      facing=8;
      break;
    case 0b00000:
      up = false;
      right = false;
      down = false;
      left = false;
      break;
  }
  
  ifshoot=val&0b10000;
  if(ifshoot==0b10000 && singleshot==0 && gameState=="GAME"){
    bulletList.add(new bullet(p.x+15,p.y+15,p.characterFacing()));
    play_shoot.rewind();
    play_shoot.play();  
    singleshot=1;
  }
  if(ifshoot==0b00000 && singleshot==1){
    singleshot=0;
  }
  
  redraw = true;
}

int[] createRandomEnemyStart() {
  //random row
  int ty = floor(random(tilemap.length));
  int tx = floor(random(tilemap[0].length));

  while (tilemap[ty][tx] != 0 || (tx>14 && ty>12)) {
    ty = floor(random(tilemap.length));
    tx = floor(random(tilemap[0].length));
  }

  int[]pixelPosition = {ty*cellHeight, tx*cellWidth};
  return pixelPosition;
}//end function

void renderMap() {
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      switch (tilemap[i][j]) {
      case 0:
        fill(80);
        rect(j*cellWidth, i*cellHeight, cellWidth, cellHeight);
        break;
      case 1:
        fill(114, 188, 128);
        rect(j*cellWidth, i*cellHeight, cellWidth, cellHeight);
        break;
      default:
        println("something is wrong with the map.");
      }//end switch
    }//end for cols
  }//end for rows
}//end renderMap

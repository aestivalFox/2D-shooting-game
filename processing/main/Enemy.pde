class Enemy {
  //props
  int x, y, w, h;
  int top,bottom,left,right;
  int currentFrame, offsetX, offsetY, totalFrames, row, sx, sy;
  int hold, delay;

  boolean moveLeft, moveUp, moveRight, moveDown;

  int speed, vx, vy;

  boolean dead,shouldRemove,not_chasing=true,collidePlayer=false;

  //constructor
  Enemy(int[]pos) {
    w = 32;
    h = 32;
    x = pos[1]+w/2;//width/2;
    y = pos[0]+h/2;//height/2;

    top=y;
    bottom=y+32;
    left=x;
    right=x+32;
    
    currentFrame = 0;
    offsetX = 6 * w;
    offsetY = 4 * h;
    totalFrames = 3;
    row = 0;
    sx = 0;
    sy = 0;

    hold = 0;
    delay = 4;

    moveLeft = false;
    moveUp = false;
    moveRight = false;
    moveDown = false;

    speed = 1;
    vx = 0;
    vy = 0;
    
    shouldRemove= false;
    dead = false;
  }
  //methods
  void reset(){
    int[] newPos = createRandomEnemyStart();
    x = newPos[1]+w/2;
    top=y;
    bottom=y+32;
    left=x;
    right=x+32;
    
    currentFrame = 0;
    offsetX = 6 * w;
    offsetY = 4 * h;
    totalFrames = 3;
    row = 0;
    sx = 0;
    sy = 0;

    hold = 0;
    delay = 4;

    moveLeft = false;
    moveUp = false;
    moveRight = false;
    moveDown = false;

    speed = 1;
    vx = 0;
    vy = 0;
    
    shouldRemove= false;
    dead = false;
  }
  void die(){
    shouldRemove=true;
    score++;
  }
  
  void update() {
    ////////chase behavior
    float distanceApart = dist(p.x+p.w/2, p.y+p.h/2, x+w/2, y+h/2);
    if (distanceApart < 200) {
      not_chasing=false;
      //close largest gap
      if (abs(p.x-x) < abs(p.y-y)) {
        if (y < p.y) {
          moveUp = false;
          moveDown = true;
        } else {
          moveUp = true;
          moveDown = false;
        }//end y
      } else {
        if (x < p.x) {
          moveLeft = false;
          moveRight = true;
        } else {
          moveLeft = true;
          moveRight = false;
        }//end x
      }//end gap closing
    } else {
      moveLeft = false;
      moveUp = false;
      moveRight = false;
      moveDown = false;
      not_chasing=true;
    }//end distanceApart
    
    if(not_chasing){
      int r = (int)(Math.random()*127)+1;
      //println(r);
      switch(r){
        case 1:
          y += -6*speed;
          break;
        case 2:
          x += 6*speed;
          break;
        case 3:
          y += 6*speed;
          break;
        case 4:
          x += -6*speed;
          break;
        default:
          moveLeft = false;
          moveUp = false;
          moveRight = false;
          moveDown = false;
      }
    }
    
    ///////update position
    if (moveLeft && !moveRight) {
      vx = -speed;
      row = 1;
    }
    if (moveRight && !moveLeft) {
      vx = speed;
      row = 2;
    }
    if (!moveLeft && !moveRight) {
      vx = 0;
    }
    if (moveUp && !moveDown) {
      vy = -speed;
      row = 3;
    }
    if (moveDown && !moveUp) {
      vy = speed;
      row = 0;
    }
    if (!moveUp && !moveDown) {
      vy = 0;
    }
    if (!moveLeft && !moveUp && !moveRight && !moveDown) {
      vx = 0;
      vy = 0;
      currentFrame = 1;
    }

    x += vx;
    y += vy;

    ///////animation stuff
    sx = currentFrame * w;
    sy = row * h;
    hold = (hold+1)%delay;
    if (hold == 0) {
      currentFrame = (currentFrame+1)%totalFrames;
    }//end hold
  }//end update
  
  void collidePlayer(Player p){
    if(top<=p.y+32 && bottom>=p.y && left<=p.x+32 && right>=p.x){
        collidePlayer=true;
        println(p.x,p.y,x,y);
        play_respawn.rewind();
        play_respawn.play();
        p.reset();
        reset();
    }
  }
  
  void display() {
    copy(enemyArt, sx+offsetX, sy+offsetY, w, h, x, y, w, h);
    top=y;
    bottom=y+32;
    left=x;
    right=x+32;
    /*
    rect(left,top,32,32);
    fill(255);
    */
    //println(enemyArt, sx+offsetX, sy+offsetY, w, h, x, y, w, h);
  }
  
  void checkWallCollisions() {
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        if (tilemap[i][j] == 1) {//checking if it is a wall
          int distX = floor((x + w/2)-(j*cellWidth+cellWidth/2));//distance on x-axis
          int distY = floor((y + h/2)-(i*cellHeight+cellHeight/2));//distance on y-axis
          //combined halfs
          int combinedHalfW = floor(w/2+cellWidth/2);
          int combinedHalfH = floor(h/2+cellHeight/2);
          if (abs(distX) < combinedHalfW && abs(distY) < combinedHalfH) {//check for overlap
            //calculate actual overlaps
            int overlapX = combinedHalfW - abs(distX);
            int overlapY = combinedHalfH - abs(distY);
            //look for smallest overlap
            if (overlapX >= overlapY) {
              //correct y position
              if (distY > 0) {y += overlapY;} 
              else {y -= overlapY;}
            } 
            else {
              //correct x position
              if (distX > 0) {x += overlapX;} 
              else {x -= overlapX;}
            }//end overlap adjustments
          }//end overlap
        }//end tilemap
      }//end cols
    }//end rows
  }//end function
}

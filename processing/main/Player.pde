class Player {
  //props
  int x, y, w, h;
  int vx, vy;
  
  int currentFrame, offsetX, offsetY, totalFrames, row, sx, sy;
  int hold, delay;
  
  int life;

  Player() {
    x = 1111;
    y = 590;
    w = 32;
    h = 32;
    
    currentFrame = 0;
    offsetX = 0 * w;
    offsetY = 0 * h;
    totalFrames = 4;
    row = 0;
    sx = 0;
    sy = 0;
    
    hold = 0;
    delay = 4;
    
    life = 3;
  }
  //methods
  void reset(){
    x = 1111;
    y = 590;
    w = 32;
    h = 32;
    
    currentFrame = 0;
    offsetX = 0 * w;
    offsetY = 0 * h;
    totalFrames = 4;
    row = 0;
    sx = 0;
    sy = 0;
    
    hold = 0;
    delay = 4;
    
    if(gameState!="GAME")life = 3;
  }
  
  void update() {
    if (up && !right && !down && !left) {
      vy = -2;
      row = 0;
    }
    if (up && right && !down && !left) {
      vy = -1;
      vx = 1;
      row = 1;
    }
    if (!up && right && !down && !left) {
      vx = 2;
      row = 2;
    }
    if (!up && right && down && !left) {
      vy = 1;
      vx = 1;
      row = 3;
    }
    if (!up && !right && down && !left) {
      vy = 2;
      row = 4;
    }
    if (!up && !right && down && left) {
      vy = 1;
      vx = -1;
      row = 5;
    }
    if (!up && !right && !down && left) {
      vx = -2;
      row = 6;
    }
    if (up && !right && !down && left) {
      vy = -1;
      vx = -1;
      row = 7;
    }
    
    
    if(!left&&!up&&!right&&!down){
       currentFrame = 0;
       vx = 0;
       vy = 0;
    }
    
    x += vx;
    y += vy;
    
    //animate stuff
    sx = currentFrame * w;
    sy = row * h;
    
    hold = (hold+1)%delay;
    if(hold == 0){
      currentFrame = (currentFrame+1)%totalFrames;
    }
  }
  
  void display() {
    copy( playerArt,sx+offsetX, sy+offsetY, w, h,x, y, w, h);
    /*
    rect(x,y,32,32);
    fill(255);
    */
    //println(row);
  }
  
  int characterFacing(){
    switch(row){
      case 0:
        return 1;
      case 1:
        return 2;
      case 2:
        return 3;
      case 3:
        return 4;
      case 4:
        return 5;
      case 5:
        return 6;
      case 6:
        return 7;
      case 7:
        return 8;  
      default:
        return 1;
    }
    
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

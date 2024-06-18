class bullet{
  int x,y,z,d,top,bottom,left,right,speed,angle;
  boolean shouldRemove;
  
  bullet(int starting_x,int starting_y,int facing){
    x=starting_x;
    y=starting_y;
    d=10;
    top=y-d/2;
    bottom=y+d/2;
    left=x-d/2;
    right=x+d/2;
    speed=15;
    angle=facing;
  }
  
  void display(){
    circle(x,y,d);
  }
  
  void move(){
    switch(angle){
      case 1:
        y-=speed;
        break;
      case 2:
        y-=speed;
        x+=speed;
        break;
      case 3:
        x+=speed;
        break;
      case 4:
        y+=speed;
        x+=speed;
        break;
      case 5:
        y+=speed;
        break;
      case 6:
        y+=speed;
        x-=speed;
        break;
      case 7:
        x-=speed;
        break;
      case 8:
        y-=speed;
        x-=speed;
        break;
      default:
        y-=speed;
        break; 
    }
    top=y-d/2;
    bottom=y+d/2;
    left=x-d/2;
    right=x+d/2;
    //println(x,y);
  }
  
  void shootEnemy(Enemy anEnemy){
    if(top<=anEnemy.bottom && bottom>=anEnemy.top && left<=anEnemy.right && right>=anEnemy.left){
        anEnemy.shouldRemove=true;
        shouldRemove=true;
        play_enemy_dead.rewind();
        play_enemy_dead.play();
        score++;
    }
  }
  
  void chechRemove(){
    if(y<0||x<0||x>1200||y>675)shouldRemove=true;
  }

  boolean checkWallCollisions() {
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        if (tilemap[i][j] == 1) {//checking if it is a wall
          int distX = floor((x + d/2)-(j*cellWidth+cellWidth/2));//distance on x-axis
          int distY = floor((y + d/2)-(i*cellHeight+cellHeight/2));//distance on y-axis
          //combined halfs
          int combinedHalfW = floor(d/2+cellWidth/2);
          int combinedHalfH = floor(d/2+cellHeight/2);
          if (abs(distX) < combinedHalfW && abs(distY) < combinedHalfH) {//check for overlap
              return true;
          }//end overlap
        }//end tilemap
      }//end cols
    }//end rows
    return false;
  }//end function
  
}

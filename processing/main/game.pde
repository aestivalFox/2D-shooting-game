void playGame() {
  noStroke();
  background(120);
  renderMap();
  fill(255);
  textSize(36);
  textAlign(LEFT);
  text("Score: "+score, 30, 30);
  
  
  
  //player health
  fill(255);
  textSize(36);
  textAlign(LEFT);
  text("Life count: "+p.life, 1000, 30);
  
  p.update();
  p.checkWallCollisions();
  p.display();
  
  for(Enemy anEnemy : enemyList){
    if (anEnemy.shouldRemove == false) {
        anEnemy.update();
        anEnemy.checkWallCollisions();
        anEnemy.display();
    }//not dead
  }
  
  for(bullet aBullet : bulletList){
    aBullet.display();
    aBullet.move();
    aBullet.chechRemove();
    for(Enemy anEnemy : enemyList)aBullet.shootEnemy(anEnemy);
  }
  
  for(int i=bulletList.size()-1;i>=0;i--){
    bullet aBullet=bulletList.get(i);
    if(aBullet.shouldRemove==true || aBullet.checkWallCollisions())bulletList.remove(aBullet);

  }
  
  for(int i=enemyList.size()-1;i>=0;i--){
    Enemy targetEnemy=enemyList.get(i);
    if(targetEnemy.shouldRemove==true)enemyList.remove(targetEnemy);
    targetEnemy.collidePlayer(p);
    if(targetEnemy.collidePlayer){
      p.life--;
      targetEnemy.collidePlayer=false;
      println(p.x,p.y,targetEnemy.x,targetEnemy.y);
    }
  }
  

}

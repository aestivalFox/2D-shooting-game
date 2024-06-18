void playWin() {
  background(62, 26, 149);
  fill(255);
  textAlign(CENTER);
  textSize(128);
  text("Winner", width/2, height/2);

  //button
  fill(250, 91, 184);
  rect(510, 360, 180, 70);
  fill(171, 123, 203);
  rect(520, 370, 160, 50);
  //button text
  fill(255);
  textSize(48);
  text("Again?", 600, 400);
  if (ifshoot==0b10000 && singleshot==0 && gameState!="GAME") {
    reset();
  }
}

void playLose() {
  background(91, 250, 211);
  fill(255);
  textAlign(CENTER);
  textSize(128);
  text("GAME OVER", width/2, height/2);

  //button
  fill(250, 91, 184);
  rect(510, 360, 180, 70);
  fill(171, 123, 203);
  rect(520, 370, 160, 50);
  //button text
  fill(255);
  textSize(48);
  text("Again?", 600, 400);
  
  for(int i=bulletList.size()-1;i>=0;i--){
    bullet aBullet=bulletList.get(i);
    bulletList.remove(aBullet);
  }
  
  for(int i=enemyList.size()-1;i>=0;i--){
    Enemy targetEnemy=enemyList.get(i);
    enemyList.remove(targetEnemy);
    targetEnemy.collidePlayer(p);
  }
  
  if (ifshoot==0b10000 && singleshot==0 && gameState!="GAME") {
    reset();
  }
}

void reset() {
  p.reset();
  score = 0;
  for(int i=enemyList.size()-1;i>=0;i--){
    Enemy targetEnemy=enemyList.get(i);
    if(targetEnemy.shouldRemove==true){
      enemyList.remove(targetEnemy);
    }
  }
  enemies = new Enemy[num_enemy];
  for (int i = 0; i < enemies.length; i++) {
    enemies[i] = new Enemy(createRandomEnemyStart());
  }
  for (int i = 0; i < enemies.length; i++) {
    enemyList.add(enemies[i]);
  }
  gameState = "GAME";
}

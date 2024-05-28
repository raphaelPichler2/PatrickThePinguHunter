float spawnRate;
float nextSpawn;


int score;
int enemiesKilled;
int moneyInGame;

void startGame(){
  gameMode=1;
  enemies.clear();
  bullets.clear();
  items.clear();
  bubbles.clear();
  spawnRate=20;
  score=0;
  enemiesKilled=0;
  moneyInGame=0;
  gamesPlayed++;
  patrick.reset();
}

void ingame(){
  image(backgroundI,500,400);
  
  patrick.paint();
  patrick.run();
  patrick.dash();
  patrick.jump();
  patrick.fall();
  patrick.shield();
  patrick.weapon.checkAttack();
  
  for(int i=0;i<bullets.size();i++){
    bullets.get(i).fly();
    bullets.get(i).paint();
    if(bullets.get(i).checkHit())i--;
  }
  
  for(int i=0;i<bubbles.size();i++){
    bubbles.get(i).fly();
    bubbles.get(i).paint();
    if(bubbles.get(i).checkHit())i--;
  }
  
  for(int i=0;i<items.size();i++){
    items.get(i).fly();
    items.get(i).paint();
    if(items.get(i).checkTriggered())i--;
  }
  
  for(int i=0;i<enemies.size();i++){
    enemies.get(i).paint();
    enemies.get(i).move();
    enemies.get(i).attack();
  }
  
  textC("score: "+score,500,20,16,0);
  if(highscore<score)highscore=score;
  textC("money: "+moneyInGame,500,40,16,0);
  
  enemySpawn();
  spawnRate=spawnRate+0.3/120;
  
}

void enemySpawn(){
  
  if(nextSpawn<=0){
    nextSpawn=120/spawnRate*60;
    int r=(int)random(12);
    switch(r){
    case 0:
      Slider s1=new Slider(true);
    break;
    case 1:
      Slider s2=new Slider(false);
    break;
    case 2:
      Walker w1=new Walker(true);
    break;
    case 3:
      Walker w2=new Walker(false);
    break;
    case 4:
      Jetpacker j1=new Jetpacker(true);
    break;
    case 5:
      Jetpacker j2=new Jetpacker(false);
    break;
    case 6:
      Shooter sh1=new Shooter(false);
    break;
    case 7:
      Shooter sh2=new Shooter(true);
    break;
    case 8:
      JetShooter j4=new JetShooter(true);
    break;
    case 9:
      JetShooter j5=new JetShooter(false);
    break;
    case 10:
      Glider g6=new Glider(true);
    break;
    case 11:
      Glider g7=new Glider(false);
    break;
    
    }  
  }else{
    nextSpawn--;
  }
}

void dropItem(float posX,float posY){
  if(random(100)<20){
    Coin c=new Coin(posX,posY);
  }else{
    
    if(random(100)<20/spawnRate*25){
      
      float r=random(100);
    
      if(r>0 && r<=35){
        AttackspeedUP as=new AttackspeedUP(posX,posY);
      }
      if(r>35 && r<=45){
        JumpUP as=new JumpUP(posX,posY);
      }
      if(r>45 && r<=60){
        DashReset as=new DashReset(posX,posY);
      }
      if(r>60 && r<=80){
        Pringles as=new Pringles(posX,posY);
      }
      if(r>80 && r<=100){
        ShieldUP as=new ShieldUP(posX,posY);
      }
    }
  }
}

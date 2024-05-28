class Enemy{
  float posX;
  float posY;
  float speedX;
  float speedY;
  float speed;
  float size;
  float hp;
  float nextAttack;
  float attackspeed;
  int worth;
  
  Enemy(){
    enemies.add(this);
  }
  
  void paint(){
    fill(255);
    ellipse(posX,posY,size,size);
  }
  
  void move(){
    posX+=speedX;
    posY+=speedY;
  }
  
  void targetWalk(){
    if(posX>patrick.posX && speedX>0)speedX=-speedX;
    if(posX<patrick.posX && speedX<0)speedX=-speedX;
    if(Math.abs(patrick.posX-posX) <= Math.abs(speedX))posX=patrick.posX;
    else posX+=speedX;
  }
  
  void targetFly(){
    speedX=speed*(patrick.posX-posX)/distance(posX,posY,patrick.posX,patrick.posY);
    speedY=speed*(patrick.posY-posY)/distance(posX,posY,patrick.posX,patrick.posY);
    
    posX+=speedX;
    posY+=speedY;
  }
  
  boolean nextAttack(){
    boolean attackReady=false;
    if(nextAttack<=0){
      attackReady=true;
      nextAttack=120/attackspeed;
    }else{
      nextAttack--;
    }
    return attackReady;
  }
  void attack(){
  }
  
  boolean getDmg(float dmg){
    hp=hp-dmg;
    if(hp<=0){
      die();
      return true;
    }
    return false;
  }
  
  void die(){
    score=score+worth;
    enemiesKilled+=1;
    dropItem(posX,posY);
    enemies.remove(this);
  }
}

class Slider extends Enemy{
  
  Slider(boolean side){
    super();
    hp=10;
    size=50;
    posY=700-size/2;
    speedY=0;
    worth=5;
    if(side){
      posX=-size;
      speedX=2.5;
    }else{
      posX=1000+size;
      speedX=-2.5;
    }
  }
  
  void attack(){
    if(distance(posX,posY,patrick.posX,patrick.posY) <= size/2+patrick.size/2){
      patrick.getDmg();
      enemies.remove(this);
    }
  }
  
  void paint(){
    pushMatrix();
    translate(posX,posY);
    if(speedX<0)scale(-1.0,1.0);
    image(sliderI,0,0,size*1.5,size*1.5);
    popMatrix();
  }
}

class Walker extends Enemy{
  int animationTimer;
  
  Walker(boolean side){
    super();
    hp=10;
    size=60;
    posY=700-size/2;
    speedY=0;
    worth=5;
    if(side){
      posX=-size;
      speedX=1;
    }else{
      posX=1000+size;
      speedX=-1;
    }
  }
  
  void move(){
    targetWalk();
  }
  
  void attack(){
    if(distance(posX,posY,patrick.posX,patrick.posY) <= size/2+patrick.size/2){
      patrick.getDmg();
      enemies.remove(this);
    }
  }
  
  void paint(){
    if(animationTimer<=0)animationTimer=60;
    else animationTimer--;
    pushMatrix();
    translate(posX,posY);
    if(speedX<0)scale(-1.0,1.0);
    if(animationTimer>=45)image(walker1I,0,0,size*1.5,size*1.5);
    if(animationTimer>=15 && animationTimer<30)image(walker1I,0,0,size*1.5,size*1.5);
    if(animationTimer>=30 && animationTimer<45)image(walker2I,0,0,size*1.5,size*1.5);
    if(animationTimer<15)image(walker3I,0,0,size*1.5,size*1.5);
    popMatrix();
  }
}

class Jetpacker extends Enemy{
  
  Jetpacker(boolean side){
    super();
    hp=10;
    size=60;
    posY=random(500-size/2);
    worth=5;
    if(side){
      posX=-size;
    }else{
      posX=1000+size;
    }
    speed=1;
  }
  
  void move(){
    targetFly();
  }
  
  void attack(){
    if(distance(posX,posY,patrick.posX,patrick.posY) <= size/2+patrick.size/2){
      patrick.getDmg();
      enemies.remove(this);
    }
  }
  
  void paint(){
    pushMatrix();
    translate(posX,posY);
    if(speedX<0)scale(-1.0,1.0);
    image(jetPackerI,0,0,size*1.5,size*1.5);
    popMatrix();
  }
}

class Shooter extends Enemy{
  int animationTimer;
  
  Shooter(boolean side){
    super();
    attackspeed=0.5;
    nextAttack=60/attackspeed;
    hp=10;
    size=60;
    posY=700-size/2;
    speedY=0;
    worth=10;
    if(side){
      posX=-size;
      speedX=1;
    }else{
      posX=1000+size;
      speedX=-1;
    }
  }
  
  void move(){
    targetWalk();
  }
  
  void attack(){
    if(distance(posX,posY,patrick.posX,patrick.posY) <= size/2+patrick.size/2){
      patrick.getDmg();
      enemies.remove(this);
    }
    
    if(nextAttack()){
      float distance=distance(posX,posY,patrick.posX,patrick.posY);
      Bubble b=new Bubble(posX, posY, 25, (patrick.posX-posX)/distance*4, (patrick.posY-posY)/distance*4);
    }
  }
  
  void paint(){
    if(animationTimer<=0)animationTimer=60;
    else animationTimer--;
    
    pushMatrix();
    translate(posX,posY);
    if(speedX<0)scale(-1.0,1.0);
    
    if(animationTimer>=45)image(shooter1I,0,0,size*1.5,size*1.5);
    if(animationTimer>=15 && animationTimer<30)image(shooter1I,0,0,size*1.5,size*1.5);
    if(animationTimer>=30 && animationTimer<45)image(shooter2I,0,0,size*1.5,size*1.5);
    if(animationTimer<15)image(shooter3I,0,0,size*1.5,size*1.5);

    //if(angle(posX,posY,patrick.posX,patrick.posY)%360>PI)scale(-1.0,1.0);
    turnImg(shooterGunI,0,0,size*1.5,size*1.5,angle(posX,posY,patrick.posX,patrick.posY));
    popMatrix();
  }
}

class JetShooter extends Enemy{
  int animationTimer;
  
  JetShooter(boolean side){
    super();
    attackspeed=0.5;
    nextAttack=60/attackspeed;
    hp=10;
    size=60;
    posY=random(500-size/2);
    worth=10;
    if(side){
      posX=-size;
    }else{
      posX=1000+size;
    }
    speed=1;
  }
  
  void move(){
    targetFly();
  }
  
  void attack(){
    if(distance(posX,posY,patrick.posX,patrick.posY) <= size/2+patrick.size/2){
      patrick.getDmg();
      enemies.remove(this);
    }
    
    if(nextAttack()){
      float distance=distance(posX,posY,patrick.posX,patrick.posY);
      Bubble b=new Bubble(posX, posY, 25, (patrick.posX-posX)/distance*4, (patrick.posY-posY)/distance*4);
    }
  }
  
  void paint(){
    pushMatrix();
    translate(posX,posY);
    if(speedX<0)scale(-1.0,1.0);
    image(jetPShooterI,0,0,size*1.5,size*1.5);
    turnImg(shooterGunI,0,0,size*1.5,size*1.5,angle(posX,posY,patrick.posX,patrick.posY));
    popMatrix();
  }
}

class Bubble{
   float posX;
  float posY;
  float speedX;
  float speedY;
  float size;
  
  Bubble(float posX, float posY, float size, float speedX, float speedY){
   this.posX=posX;
   this.posY=posY;
   this.speedX=speedX;
   this.speedY=speedY;
   this.size=size;
   bubbles.add(this);
  }
  
  void paint(){
    pushMatrix();
    translate(posX,posY);
    image(bubbleI,0,0,size*2,size*2);
    popMatrix();
  }
  
  void fly(){
    posX=posX+speedX;
    posY=posY+speedY;
  }
  
  boolean checkHit(){
    boolean destroyed=false;
    
    if(distance(posX,posY,patrick.posX,patrick.posY) <= size/2+patrick.size/2){
      patrick.getDmg();
      bubbles.remove(this);
      destroyed=true;
    }
    
    if(distance(posX,posY, 500,400)>1000){
      bubbles.remove(this);
      destroyed = true;
    }
    
    return destroyed;
  }
}

class Glider extends Enemy{
  
  Glider(boolean side){
    super();
    hp=10;
    size=50;
    posY=random(500-size/2);
    speedY=0.5;
    worth=10;
    if(side){
      posX=-size;
      speedX=2.5;
    }else{
      posX=1000+size;
      speedX=-2.5;
    }
  }
  
  void attack(){
    if(distance(posX,posY,patrick.posX,patrick.posY) <= size/2+patrick.size/2){
      patrick.getDmg();
      enemies.remove(this);
    }
  }
  
  void paint(){
    pushMatrix();
    translate(posX,posY);
    if(speedX<0)scale(-1.0,1.0);
    image(gliderI,0,0,size*1.5,size*1.5);
    popMatrix();
  }
}

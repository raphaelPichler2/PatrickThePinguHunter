class Weapon{
  
  float baseDmg;
  float dmg;
  float baseAttackspeed;
  float attackspeed;
  float nextAttack;
  
  Weapon(float dmg, float attackspeed){
    this.baseDmg = dmg;
    this.dmg = dmg;
    this.attackspeed = attackspeed;
    this.baseAttackspeed = attackspeed;
    this.nextAttack = attackspeed;
  }
  
  void checkAttack(){
    if(nextAttack<=0 && keys[12]){
      attack();
      nextAttack=nextAttack+120/attackspeed;
    }
    if(nextAttack>0) nextAttack--;
  }
  void attack(){}
  
  void paint(){}
  
}

class Pistol extends Weapon{
  
  
  Pistol(){
    super(10,2);
  }
  
  void attack(){
    float distance=distance(patrick.posX,patrick.posY,mouseX,mouseY);
    Bullet bullet = new Bullet(patrick.posX+(mouseX-patrick.posX)/distance*30, patrick.posY+(mouseY-patrick.posY)/distance*30,
            14, (mouseX-patrick.posX)/distance*14, (mouseY-patrick.posY)/distance*14,dmg);
  }
  
  void paint(){
    pushMatrix();
    translate(patrick.posX,patrick.posY);
    if(angle(patrick.posX,patrick.posY,mouseX,mouseY)>=PI)scale(-1.0,1.0);
    if(nextAttack>120/attackspeed-10){
      turnImg(pistolShotI,0,0,patrick.size*2,patrick.size*2,angle(patrick.posX,patrick.posY,mouseX,mouseY));
      tint(255,255);
    }else turnImg(pistolI,0,0,patrick.size*2,patrick.size*2,angle(patrick.posX,patrick.posY,mouseX,mouseY));
    popMatrix();
  }
}

class Bullet{
  
  float posX;
  float posY;
  float speedX;
  float speedY;
  float size;
  float dmg;
  
  Bullet(float posX, float posY, float size, float speedX, float speedY, float dmg){
   this.posX=posX;
   this.posY=posY;
   this.speedX=speedX;
   this.speedY=speedY;
   this.size=size;
   this.dmg=dmg;
   bullets.add(this);
  }
  
  void paint(){
    pushMatrix();
    translate(posX,posY);
    if(angle(0,0,speedX,speedY)%360>PI)scale(-1.0,1.0);
    turnImg(bulletI,0,0,size*2,size*2,HALF_PI+angle(0,0,speedX,speedY));
    popMatrix();
  }
  
  void fly(){
    posX=posX+speedX;
    posY=posY+speedY;
  }
  
  boolean checkHit(){
    boolean destroyed=false;
    
    for(int i=0;i<enemies.size();i++){
      if(distance(posX,posY,enemies.get(i).posX,enemies.get(i).posY) <= size/2+enemies.get(i).size/2){
        enemies.get(i).getDmg(dmg);
        bullets.remove(this);
        destroyed=true;
      }
    }
    
    if(distance(posX,posY, 500,400)>1000){
      bullets.remove(this);
      destroyed = true;
    }
    
    return destroyed;
  }
}

class PringlesBullet extends Bullet{
  
  PringlesBullet(float posX, float posY, float speedX, float speedY, float dmg){
   super( posX,  posY, 20,  speedX,  speedY,  dmg);
  }
  
  void paint(){
    pushMatrix();
    translate(posX,posY);
    if((angle(0,0,speedX,speedY))>=PI)scale(-1.0,1.0);
    turnImg(pringlesBulletI,0,0,size*2,size*2,HALF_PI+angle(0,0,speedX,speedY));
    popMatrix();
  }
}

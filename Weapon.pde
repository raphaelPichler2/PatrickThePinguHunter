class Weapon{
  
  float baseDmg;
  float dmg;
  float baseAttackspeed;
  float attackspeed;
  float nextAttack;
  PImage shop;
  String name;
  int unlocked = 0;
  int price;
  
  Weapon(float dmg, float attackspeed){
    this.baseDmg = dmg;
    this.dmg = dmg;
    this.attackspeed = attackspeed;
    this.baseAttackspeed = attackspeed;
    this.nextAttack = attackspeed;
    shop=pistolI;
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
    name="pistol";
  }
  
  void attack(){
    float distance=distance(patrick.posX,patrick.posY,mouseXF,mouseYF);
    Bullet bullet = new Bullet(patrick.posX+(mouseXF-patrick.posX)/distance*30, patrick.posY+(mouseYF-patrick.posY)/distance*30,
            14, (mouseXF-patrick.posX)/distance*14, (mouseYF-patrick.posY)/distance*14,dmg);
  }
  
  void paint(){
    pushMatrix();
    translate(patrick.posX,patrick.posY);
    if(angle(patrick.posX,patrick.posY,mouseXF,mouseYF)>=PI)scale(-1.0,1.0);
    if(nextAttack>120/attackspeed-10){
      turnImg(pistolShotI,0,0,patrick.size*2,patrick.size*2,angle(patrick.posX,patrick.posY,mouseXF,mouseYF));
      tint(255,255);
    }else turnImg(pistolI,0,0,patrick.size*2,patrick.size*2,angle(patrick.posX,patrick.posY,mouseXF,mouseYF));
    popMatrix();
  }
}

class Shotgun extends Weapon{
  
  
  Shotgun(){
    super(10,1.2);
    shop=shotgunI;
    name="shotgun";
    price=400;
  }
  
  void attack(){
    float distance=distance(patrick.posX,patrick.posY,mouseXF,mouseYF);
    float speedX=(mouseXF-patrick.posX)/distance*14;
    float speedY=(mouseYF-patrick.posY)/distance*14;
    Bullet bullet = new Bullet(patrick.posX+speedX*2, patrick.posY+speedY*2, 10, speedX, speedY,dmg);
    Bullet bullet1 = new Bullet(patrick.posX+speedX*2, patrick.posY+speedY*2, 10, speedX+speedY*0.1, speedY-speedX*0.1,dmg);
    Bullet bullet2 = new Bullet(patrick.posX+speedX*2, patrick.posY+speedY*2, 10, speedX-speedY*0.1, speedY+speedX*0.1,dmg);
  }
  
  void paint(){
    pushMatrix();
    translate(patrick.posX,patrick.posY);
    if(angle(patrick.posX,patrick.posY,mouseXF,mouseYF)>=PI)scale(-1.0,1.0);
    if(nextAttack>120/attackspeed-10){
      turnImg(shotgunShotI,0,0,patrick.size*2,patrick.size*2,angle(patrick.posX,patrick.posY,mouseXF,mouseYF));
      tint(255,255);
    }else turnImg(shotgunI,0,0,patrick.size*2,patrick.size*2,angle(patrick.posX,patrick.posY,mouseXF,mouseYF));
    popMatrix();
  }
}

class Akimbo extends Weapon{
  
  
  Akimbo(){
    super(10,1.5);
    shop=akimboI;
    name="akimbo";
    price=100;
  }
  
  void attack(){
    float distance=distance(patrick.posX,patrick.posY,mouseXF,mouseYF);
    float speedX=(mouseXF-patrick.posX)/distance*14;
    float speedY=(mouseYF-patrick.posY)/distance*14;
    Bullet bullet = new Bullet(patrick.posX+speedX*2, patrick.posY+speedY*2, 14, speedX, speedY,dmg);
    Bullet bullet1 = new Bullet(patrick.posX-speedX*2, patrick.posY-speedY*2, 14, -speedX, -speedY,dmg);
  }
  
  void paint(){
    pushMatrix();
    translate(patrick.posX,patrick.posY);
    if(angle(patrick.posX,patrick.posY,mouseXF,mouseYF)>=PI)scale(-1.0,1.0);
    if(nextAttack>120/attackspeed-10){
      turnImg(akimboShotI,0,0,patrick.size*2,patrick.size*2,angle(patrick.posX,patrick.posY,mouseXF,mouseYF));
      tint(255,255);
    }else turnImg(akimboI,0,0,patrick.size*2,patrick.size*2,angle(patrick.posX,patrick.posY,mouseXF,mouseYF));
    popMatrix();
  }
}

class Sniper extends Weapon{
  
  
  Sniper(){
    super(10,1.2);
    shop=sniperI;
    name="sniper";
    price=300;
  }
  
  void attack(){
    float distance=distance(patrick.posX,patrick.posY,mouseXF,mouseYF);
    float speedX=(mouseXF-patrick.posX)/distance*14;
    float speedY=(mouseYF-patrick.posY)/distance*14;
    SniperBullet bullet = new SniperBullet(patrick.posX+speedX*2, patrick.posY+speedY*2, speedX, speedY,dmg);
  }
  
  void paint(){
    pushMatrix();
    translate(patrick.posX,patrick.posY);
    if(angle(patrick.posX,patrick.posY,mouseXF,mouseYF)>=PI)scale(-1.0,1.0);
    if(nextAttack>120/attackspeed-10){
      turnImg(sniperShotI,0,0,patrick.size*2,patrick.size*2,angle(patrick.posX,patrick.posY,mouseXF,mouseYF));
      tint(255,255);
    }else turnImg(sniperI,0,0,patrick.size*2,patrick.size*2,angle(patrick.posX,patrick.posY,mouseXF,mouseYF));
    popMatrix();
  }
}

class Uzi extends Weapon{
  
  
  Uzi(){
    super(10,3.5);
    shop=uziI;
    name="uzi";
    price=200;
  }
  
  void attack(){
    float distance=distance(patrick.posX,patrick.posY,mouseXF,mouseYF);
    float speedX=(mouseXF-patrick.posX)/distance*14;
    float speedY=(mouseYF-patrick.posY)/distance*14;
    float sprayS=random(-0.15,0.15);
    UziBullet uziBullet = new UziBullet(patrick.posX+speedX*2, patrick.posY+speedY*2, speedX+speedY*sprayS, speedY-speedX*sprayS,dmg);
  }
  
  void paint(){
    pushMatrix();
    translate(patrick.posX,patrick.posY);
    if(angle(patrick.posX,patrick.posY,mouseXF,mouseYF)>=PI)scale(-1.0,1.0);
    if(nextAttack>120/attackspeed-10){
      turnImg(uziShotI,0,0,patrick.size*2,patrick.size*2,angle(patrick.posX,patrick.posY,mouseXF,mouseYF));
      tint(255,255);
    }else turnImg(uziI,0,0,patrick.size*2,patrick.size*2,angle(patrick.posX,patrick.posY,mouseXF,mouseYF));
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
    
    if(distance(posX,posY, 500,400)>1000 || size<=0){
      bullets.remove(this);
      destroyed = true;
    }
    if(size<=0)destroyed = true;
    
    return destroyed;
  }
}

class UziBullet extends Bullet{
  
  UziBullet(float posX, float posY, float speedX, float speedY, float dmg){
    super( posX,  posY, 14,  speedX,  speedY,  dmg);
  }
  
  void fly(){
    posX=posX+speedX;
    posY=posY+speedY;
    size=size-28.0/120.0;
  }
}

class SniperBullet extends Bullet{
  ArrayList<Enemy> hit = new ArrayList<Enemy>();
  
  SniperBullet(float posX, float posY, float speedX, float speedY, float dmg){
    super( posX,  posY, 16,  speedX,  speedY,  dmg);
  }
  
  boolean checkHit(){
    boolean destroyed=false;
    
    for(int i=0;i<enemies.size();i++){
      if(!hit.contains(enemies.get(i)) && distance(posX,posY,enemies.get(i).posX,enemies.get(i).posY) <= size/2+enemies.get(i).size/2){
        hit.add(enemies.get(i));
        enemies.get(i).getDmg(dmg);
      }
    }
    
    if(distance(posX,posY, 500,400)>1000 || size<=0){
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

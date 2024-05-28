class Item{
  
  float posX;
  float posY;
  float speedX;
  float speedY;
  float size=40;
  boolean gravityEffect;
  int decay;
  
  Item(){
    decay=120*5;
    items.add(this);
  }
  
  void paint(){
    fill(#6DCB2F);
    ellipse(posX,posY,size,size);
  }
  
  boolean decay(){
    decay--;
    if(decay<=0){
      items.remove(this);
      return true;
    }
    return false;
  }
  
  void fly(){
    posX=posX+speedX;
    posY=posY+speedY;
    
    if(gravityEffect && posY<700-size/2)speedY=speedY+gravity;
    
    if(posY>700-size/2){
      posY=700-size/2;
      speedY=0;
      speedX=0;
    }
  }
  
  boolean checkTriggered(){
    boolean deletion=false;
    if(decay())deletion=true;
    if(distance(posX,posY,patrick.posX,patrick.posY)<=size/2+patrick.size/2){
      effect();
      items.remove(this);
      deletion=true;
    }
    return deletion;
  }
  
  void effect(){}
}

class Coin extends Item{
  
  Coin(float posX,float posY){
    super();
    speedY=-10;
    speedX=(500-posX)/150;
    this.posX=posX;
    this.posY=posY;
    gravityEffect=true;
  }
  
  void paint(){
    image(coinI,posX,posY,size,size);
  }
  
  void effect(){
    moneyInGame++;
    money++;
  }
}

class AttackspeedUP extends Item{
  
  AttackspeedUP(float posX,float posY){
    super();
    speedY=-10;
    speedX=(500-posX)/150;
    this.posX=posX;
    this.posY=posY;
    gravityEffect=true;
  }
  
  void paint(){
    image(attackspeedUPI,posX,posY,size,size);
  }
  
  void effect(){
    patrick.weapon.attackspeed=patrick.weapon.attackspeed*1.2;
  }
}

class JumpUP extends Item{
  
  JumpUP(float posX,float posY){
    super();
    speedY=-10;
    speedX=(500-posX)/150;
    this.posX=posX;
    this.posY=posY;
    gravityEffect=true;
  }
  
  void fly(){
    posX=posX+speedX;
    posY=posY+speedY;
    
    if(gravityEffect && posY<700-size/2)speedY=speedY+gravity;
    
    if(posY>700-size/2){
      posY=700-size/2;
      speedY=-speedY*0.5;
      speedX=speedX*0.8;
    }
    if(speedY<=0.1 && speedY>0){
      speedY=0;
      speedX=0;
    }
  }
  
  void paint(){
    image(jumpUpI,posX,posY,size,size);
  }
  
  void effect(){
    patrick.extraJumps=patrick.extraJumps+1;
  }
}

class Pringles extends Item{
  
  Pringles(float posX,float posY){
    super();
    speedY=(500-posY)/120;
    speedX=(500-posX)/120;
    this.posX=posX;
    this.posY=posY;
    gravityEffect=false;
  }
  
  void fly(){
    posX=posX+speedX;
    posY=posY+speedY;
    
    speedX=speedX*0.98;
    speedY=speedY*0.98;
  }
  
  void paint(){
    image(pringlesI,posX,posY,size,size);
  }
  
  void effect(){
    
    for(int i=0; i<16;i++){
      float angle=TWO_PI/16*i;
      PringlesBullet bullet = new PringlesBullet(posX, posY, 8*cos(angle), 8*sin(angle),10);
    }
  }
}

class DashReset extends Item{
  
  DashReset(float posX,float posY){
    super();
    speedY=(500-posY)/120;
    speedX=(500-posX)/120;
    this.posX=posX;
    this.posY=posY;
    gravityEffect=false;
  }
  
  void fly(){
    posX=posX+speedX;
    posY=posY+speedY;
    
    speedX=speedX*0.98;
    speedY=speedY*0.98;
  }
  
  void paint(){
    image(dashResetI,posX,posY,size,size);
  }
  
  void effect(){
    patrick.dashCDremain=20;
    patrick.dashCD=patrick.dashCD*0.9;
  }
}

class ShieldUP extends Item{
  
  ShieldUP(float posX,float posY){
    super();
    speedY=(500-posY)/120;
    speedX=(500-posX)/120;
    this.posX=posX;
    this.posY=posY;
    gravityEffect=false;
  }
  
  void fly(){
    posX=posX+speedX;
    posY=posY+speedY;
    
    speedX=speedX*0.98;
    speedY=speedY*0.98;
  }
  
  void paint(){
    image(shieldUPI,posX,posY,size,size);
  }
  
  void effect(){
    patrick.shielded=120*4;
  }
}

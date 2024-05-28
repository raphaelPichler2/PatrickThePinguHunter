class Patrick{
  
  float posX;
  float posY;
  float speed;
  float jumpStrength;
  float size;
  float speedX;
  float speedY;
  int extraJumps;
  int extraJumpsUsed;
  boolean jumpReleased;
  int extraHealth;
  float nextHealth;
  float dashCD;
  float dashCDremain;
  float shielded;
  
  Weapon weapon;
  
  int walkingAnimation;
  
  Patrick(){
  }
  
  void reset(){
    size=50;
    posX=500;
    posY=700-size/2;
    speed=4;
    jumpStrength=15;
    dashCD=120*20;
    dashCDremain=120;
    weapon.attackspeed=weapon.baseAttackspeed;
    extraJumps=0;
  }
  
  void paint(){
    //ellipse(posX,posY,size,size);
    if((keys[0]||keys[6]) &&  speedY==2)image(fallschirmI,posX,posY,size*4,size*4);
    
    if(speedX==0)image(hunterStandI,posX,posY,size*2,size*2);
    else{
      walkingAnimation--;
      pushMatrix();
      translate(posX,posY);
      if(speedX<0)scale(-1.0,1.0);
      if(walkingAnimation>=45)image(hunterWalk2I,0,0,size*2,size*2);
      if(walkingAnimation>=30 && walkingAnimation<45) image(hunterWalk1I,0,0,size*2,size*2);
      if(walkingAnimation>=15 && walkingAnimation<30) image(hunterWalk2I,0,0,size*2,size*2);
      if(walkingAnimation<15) image(hunterWalk3I,0,0,size*2,size*2);
      if(walkingAnimation<=0)walkingAnimation=60;
      
      popMatrix();
    }
    fill(#0CAA52);
    if(dashCDremain<=0)fill(#3BA200);
    noStroke();
    rect(posX+(size*(dashCD-dashCDremain)/dashCD-size)/2,posY-size,size*(dashCD-dashCDremain)/dashCD,5);
    stroke(0);

    weapon.paint();
    
    if(shielded>0)image(shieldedI,posX,posY,size*2,size*2);
  }
  
  void run(){
    speedX=0;
    if(keys[1] && !keys[3]) speedX=-speed;
    if(keys[3] && !keys[1]) speedX=speed;
    posX=posX+speedX;
    if(posX>1000)posX=0;
    if(posX<0)posX=1000;
  }
  
  void dash(){
    if(dashCDremain<=0 && keys[13]){
      dashCDremain=dashCD;
      posX=mouseXF;
      posY=mouseYF;
      speedY=0;
      shielded=120;
      if(posY>700-size/2)posY=700-size/2;
    }
    if(dashCDremain>0)dashCDremain--;
  }
  
  void jump(){
    if(!jumpReleased && !(keys[0]||keys[6]))jumpReleased=true;
    if( (keys[0]||keys[6]) ){
      if(posY>=700-size/2){ 
        speedY=-jumpStrength;
        extraJumpsUsed=0;
      }
      else{
        if(jumpReleased && extraJumpsUsed<extraJumps){
          speedY=-jumpStrength;
          extraJumpsUsed++;
        }
      }
      jumpReleased=false;
    }
  }
  
  void fall(){
    if(posY<700-size/2){
      speedY=speedY+gravity;
      if(keys[2])speedY=speedY+speed/5;
    }
    if((keys[0]||keys[6]) &&  speedY>2){
      speedY=2;
    }
    if(keys[2] && speedY<0)speedY=0;
    
    if(posY>700-size/2){
      posY=700-size/2;
      speedY=0;
    }
    
    posY=posY+speedY;
    if(posY>700-size/2)posY=700-size/2;
    if(posY<size/2){
      posY=size/2;
      speedY=0;
    }
  }
  
  void shield(){
    if(shielded>0)shielded--;
  }
  
  void getDmg(){
    if(shielded<=0){
      gameMode=2;
      saveData();
    }
  }
}

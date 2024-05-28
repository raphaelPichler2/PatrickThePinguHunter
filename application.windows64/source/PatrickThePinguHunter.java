import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class PatrickThePinguHunter extends PApplet {

boolean firstFrameClick=true;
Boolean[] keys= new Boolean[14];
Table table;
float fpms;

int gameMode;

float gravity=0.5f;

Patrick patrick = new Patrick();
int money=0;
float highscore=0;
int gamesPlayed=0;

ArrayList<Bullet> bullets= new ArrayList<Bullet>();
ArrayList<Bubble> bubbles= new ArrayList<Bubble>();
ArrayList<Enemy> enemies= new ArrayList<Enemy>();
ArrayList<Item> items= new ArrayList<Item>();

public void setup(){
  
  
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
  frameRate(120);
  imageMode(CENTER);
  
  for(int i=0;i<keys.length;i++){
    keys[i]=false;
  }
  table= loadTable("new.csv","header,csv");
  money=table.getInt(0,"value");
  highscore=table.getInt(1,"value");
  gamesPlayed=table.getInt(2,"value");
  
  loadImages();
  gameMode=0;
}

public void draw(){
  background(255);
  if(gameMode==0){
  //mainMenu
    
    textAlign(LEFT, CENTER);
    textC("gold: "+money,20,20,20,0);
    textC("score: "+score,20,40,20,0);
    textC("highscore: "+(int)highscore,20,60,20,0);
    textC("games played: "+gamesPlayed,20,80,20,0);
    textAlign(CENTER, CENTER);
  
    fill(255);
    rect(500,400,200,100);
    textC("start",500,400,20,0);
    if(buttonPressed(500,400,200,100)){
      startGame();
    }
  }
  
  if(gameMode==1)ingame();
  
  
  if (!keyPressed && !mousePressed)firstFrameClick=true;  
  if (keyPressed || mousePressed)firstFrameClick=false;
}
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
  
  public void paint(){
    fill(255);
    ellipse(posX,posY,size,size);
  }
  
  public void move(){
    posX+=speedX;
    posY+=speedY;
  }
  
  public void targetWalk(){
    if(posX>patrick.posX && speedX>0)speedX=-speedX;
    if(posX<patrick.posX && speedX<0)speedX=-speedX;
    if(Math.abs(patrick.posX-posX) <= Math.abs(speedX))posX=patrick.posX;
    else posX+=speedX;
  }
  
  public void targetFly(){
    speedX=speed*(patrick.posX-posX)/distance(posX,posY,patrick.posX,patrick.posY);
    speedY=speed*(patrick.posY-posY)/distance(posX,posY,patrick.posX,patrick.posY);
    
    posX+=speedX;
    posY+=speedY;
  }
  
  public boolean nextAttack(){
    boolean attackReady=false;
    if(nextAttack<=0){
      attackReady=true;
      nextAttack=120/attackspeed;
    }else{
      nextAttack--;
    }
    return attackReady;
  }
  public void attack(){
  }
  
  public boolean getDmg(float dmg){
    hp=hp-dmg;
    if(hp<=0){
      die();
      return true;
    }
    return false;
  }
  
  public void die(){
    score=score+worth;
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
      speedX=2.5f;
    }else{
      posX=1000+size;
      speedX=-2.5f;
    }
  }
  
  public void attack(){
    if(distance(posX,posY,patrick.posX,patrick.posY) <= size/2+patrick.size/2){
      patrick.getDmg();
      enemies.remove(this);
    }
  }
  
  public void paint(){
    pushMatrix();
    translate(posX,posY);
    if(speedX<0)scale(-1.0f,1.0f);
    image(sliderI,0,0,size*1.5f,size*1.5f);
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
  
  public void move(){
    targetWalk();
  }
  
  public void attack(){
    if(distance(posX,posY,patrick.posX,patrick.posY) <= size/2+patrick.size/2){
      patrick.getDmg();
      enemies.remove(this);
    }
  }
  
  public void paint(){
    if(animationTimer<=0)animationTimer=60;
    else animationTimer--;
    pushMatrix();
    translate(posX,posY);
    if(speedX<0)scale(-1.0f,1.0f);
    if(animationTimer>=45)image(walker1I,0,0,size*1.5f,size*1.5f);
    if(animationTimer>=15 && animationTimer<30)image(walker1I,0,0,size*1.5f,size*1.5f);
    if(animationTimer>=30 && animationTimer<45)image(walker2I,0,0,size*1.5f,size*1.5f);
    if(animationTimer<15)image(walker3I,0,0,size*1.5f,size*1.5f);
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
  
  public void move(){
    targetFly();
  }
  
  public void attack(){
    if(distance(posX,posY,patrick.posX,patrick.posY) <= size/2+patrick.size/2){
      patrick.getDmg();
      enemies.remove(this);
    }
  }
  
  public void paint(){
    pushMatrix();
    translate(posX,posY);
    if(speedX<0)scale(-1.0f,1.0f);
    image(jetPackerI,0,0,size*1.5f,size*1.5f);
    popMatrix();
  }
}

class Shooter extends Enemy{
  int animationTimer;
  
  Shooter(boolean side){
    super();
    attackspeed=0.5f;
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
  
  public void move(){
    targetWalk();
  }
  
  public void attack(){
    if(distance(posX,posY,patrick.posX,patrick.posY) <= size/2+patrick.size/2){
      patrick.getDmg();
      enemies.remove(this);
    }
    
    if(nextAttack()){
      float distance=distance(posX,posY,patrick.posX,patrick.posY);
      Bubble b=new Bubble(posX, posY, 25, (patrick.posX-posX)/distance*4, (patrick.posY-posY)/distance*4);
    }
  }
  
  public void paint(){
    if(animationTimer<=0)animationTimer=60;
    else animationTimer--;
    
    pushMatrix();
    translate(posX,posY);
    if(speedX<0)scale(-1.0f,1.0f);
    
    if(animationTimer>=45)image(shooter1I,0,0,size*1.5f,size*1.5f);
    if(animationTimer>=15 && animationTimer<30)image(shooter1I,0,0,size*1.5f,size*1.5f);
    if(animationTimer>=30 && animationTimer<45)image(shooter2I,0,0,size*1.5f,size*1.5f);
    if(animationTimer<15)image(shooter3I,0,0,size*1.5f,size*1.5f);

    //if(angle(posX,posY,patrick.posX,patrick.posY)%360>PI)scale(-1.0,1.0);
    turnImg(shooterGunI,0,0,size*1.5f,size*1.5f,angle(posX,posY,patrick.posX,patrick.posY));
    popMatrix();
  }
}

class JetShooter extends Enemy{
  int animationTimer;
  
  JetShooter(boolean side){
    super();
    attackspeed=0.5f;
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
  
  public void move(){
    targetFly();
  }
  
  public void attack(){
    if(distance(posX,posY,patrick.posX,patrick.posY) <= size/2+patrick.size/2){
      patrick.getDmg();
      enemies.remove(this);
    }
    
    if(nextAttack()){
      float distance=distance(posX,posY,patrick.posX,patrick.posY);
      Bubble b=new Bubble(posX, posY, 25, (patrick.posX-posX)/distance*4, (patrick.posY-posY)/distance*4);
    }
  }
  
  public void paint(){
    pushMatrix();
    translate(posX,posY);
    if(speedX<0)scale(-1.0f,1.0f);
    image(jetPShooterI,0,0,size*1.5f,size*1.5f);
    turnImg(shooterGunI,0,0,size*1.5f,size*1.5f,angle(posX,posY,patrick.posX,patrick.posY));
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
  
  public void paint(){
    pushMatrix();
    translate(posX,posY);
    image(bubbleI,0,0,size*2,size*2);
    popMatrix();
  }
  
  public void fly(){
    posX=posX+speedX;
    posY=posY+speedY;
  }
  
  public boolean checkHit(){
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
    speedY=0.5f;
    worth=10;
    if(side){
      posX=-size;
      speedX=2.5f;
    }else{
      posX=1000+size;
      speedX=-2.5f;
    }
  }
  
  public void attack(){
    if(distance(posX,posY,patrick.posX,patrick.posY) <= size/2+patrick.size/2){
      patrick.getDmg();
      enemies.remove(this);
    }
  }
  
  public void paint(){
    pushMatrix();
    translate(posX,posY);
    if(speedX<0)scale(-1.0f,1.0f);
    image(gliderI,0,0,size*1.5f,size*1.5f);
    popMatrix();
  }
}
PImage backgroundI;
PImage hunterStandI;
PImage hunterWalk1I;
PImage hunterWalk2I;
PImage hunterWalk3I;

PImage pistolI;
PImage pistolShotI;
PImage bulletI;

PImage sliderI;
PImage walker1I;
PImage walker2I;
PImage walker3I;
PImage jetPackerI;
PImage shooter1I;
PImage shooter2I;
PImage shooter3I;
PImage jetPShooterI;
PImage bubbleI;
PImage shooterGunI;
PImage gliderI;

PImage coinI;
PImage attackspeedUPI;
PImage jumpUpI;
PImage pringlesI;
PImage pringlesBulletI;
PImage dashResetI;
PImage shieldUPI;
PImage shieldedI;

public void loadImages(){
  backgroundI=loadImage("background.png");
  hunterStandI=loadImage("Hunter.png");
  hunterWalk1I=loadImage("HunterWalk1.png");
  hunterWalk2I=loadImage("HunterWalk2.png");
  hunterWalk3I=loadImage("HunterWalk3.png");
  pistolI=loadImage("Pistol.png");
  pistolShotI=loadImage("PistolShot.png");
  bulletI=loadImage("bullet.png");
  
  sliderI=loadImage("Slider.png");
  walker1I=loadImage("Walker1.png");
  walker2I=loadImage("Walker2.png");
  walker3I=loadImage("Walker3.png");
  jetPackerI=loadImage("JetPacker.png");
  shooter1I=loadImage("Shooter.png");
  shooter2I=loadImage("Shooter2.png");
  shooter3I=loadImage("Shooter3.png");
  jetPShooterI=loadImage("JetPShooter.png");
  bubbleI=loadImage("Bubble.png");
  shooterGunI=loadImage("ShooterGun.png");
  gliderI=loadImage("Glider.png");
  
  coinI=loadImage("Coin.png");
  attackspeedUPI=loadImage("AttackspeedUP.png");
  jumpUpI=loadImage("JumpUp.png");
  pringlesI=loadImage("Pringles.png");
  pringlesBulletI=loadImage("PringlesBullet.png");
  dashResetI=loadImage("DashReset.png");
  shieldUPI=loadImage("ShieldUp.png");
  shieldedI=loadImage("Shielded.png");
}
float spawnRate;
float nextSpawn;


int score;
int moneyInGame;

public void startGame(){
  gameMode=1;
  enemies.clear();
  bullets.clear();
  items.clear();
  bubbles.clear();
  spawnRate=20;
  score=0;
  moneyInGame=0;
  gamesPlayed++;
  patrick.reset();
}

public void ingame(){
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
  spawnRate=spawnRate+0.3f/120;
  
}

public void enemySpawn(){
  
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

public void dropItem(float posX,float posY){
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
  
  public void paint(){
    fill(0xff6DCB2F);
    ellipse(posX,posY,size,size);
  }
  
  public boolean decay(){
    decay--;
    if(decay<=0){
      items.remove(this);
      return true;
    }
    return false;
  }
  
  public void fly(){
    posX=posX+speedX;
    posY=posY+speedY;
    
    if(gravityEffect && posY<700-size/2)speedY=speedY+gravity;
    
    if(posY>700-size/2){
      posY=700-size/2;
      speedY=0;
      speedX=0;
    }
  }
  
  public boolean checkTriggered(){
    boolean deletion=false;
    if(decay())deletion=true;
    if(distance(posX,posY,patrick.posX,patrick.posY)<=size/2+patrick.size/2){
      effect();
      items.remove(this);
      deletion=true;
    }
    return deletion;
  }
  
  public void effect(){}
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
  
  public void paint(){
    image(coinI,posX,posY,size,size);
  }
  
  public void effect(){
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
  
  public void paint(){
    image(attackspeedUPI,posX,posY,size,size);
  }
  
  public void effect(){
    patrick.weapon.attackspeed=patrick.weapon.attackspeed*1.2f;
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
  
  public void fly(){
    posX=posX+speedX;
    posY=posY+speedY;
    
    if(gravityEffect && posY<700-size/2)speedY=speedY+gravity;
    
    if(posY>700-size/2){
      posY=700-size/2;
      speedY=-speedY*0.5f;
      speedX=speedX*0.8f;
    }
    if(speedY<=0.1f && speedY>0){
      speedY=0;
      speedX=0;
    }
  }
  
  public void paint(){
    image(jumpUpI,posX,posY,size,size);
  }
  
  public void effect(){
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
  
  public void fly(){
    posX=posX+speedX;
    posY=posY+speedY;
    
    speedX=speedX*0.98f;
    speedY=speedY*0.98f;
  }
  
  public void paint(){
    image(pringlesI,posX,posY,size,size);
  }
  
  public void effect(){
    
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
  
  public void fly(){
    posX=posX+speedX;
    posY=posY+speedY;
    
    speedX=speedX*0.98f;
    speedY=speedY*0.98f;
  }
  
  public void paint(){
    image(dashResetI,posX,posY,size,size);
  }
  
  public void effect(){
    patrick.dashCDremain=20;
    patrick.dashCD=patrick.dashCD*0.9f;
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
  
  public void fly(){
    posX=posX+speedX;
    posY=posY+speedY;
    
    speedX=speedX*0.98f;
    speedY=speedY*0.98f;
  }
  
  public void paint(){
    image(shieldUPI,posX,posY,size,size);
  }
  
  public void effect(){
    patrick.shielded=120*4;
  }
}
public boolean buttonPressed(float posX, float posY, float sizeX, float sizeY) {
  if (mousePressed && firstFrameClick && mouseX<posX+sizeX/2 && mouseX>posX-sizeX/2 && mouseY<posY+sizeY/2 && mouseY>posY-sizeY/2) {
    return true;
  }
  return false;
}

public void turnImg(PImage img,float x,float y,float sizeX,float sizeY,float degr){
  pushMatrix();
  translate(x,y);
  rotate(degr);
  image(img,0,0,sizeX,sizeY);
  popMatrix();
}

public void textC(String text,float x,float y, float size, int c){
  textSize(size);
  fill(c);
  text(text,x,y);
}

public float w(){
  return width/1000.0f;
}
public float h(){
  return height/800.0f;
}

public float distance(float x1, float y1, float x2, float y2) {
  float distance=(float)Math.sqrt(Math.pow(x1-x2, 2)+Math.pow(y1-y2, 2));
  return distance;
}

public float angle(float x1, float y1, float x2, float y2){
  float angle=0;
  angle=atan( (y2-y1) / (x2-x1));
  if(x1>x2)angle=TWO_PI-angle;
  if(x2-x1<=1 && x2-x1>=-1){
    if(y1<y2)angle=HALF_PI;
    if(y1>y2)angle=TWO_PI-HALF_PI;
  }
  
  return angle;
}

public void saveData(){
  
  table.getRow(0).setLong("value",money);
  table.getRow(1).setFloat("value",highscore);
  table.getRow(2).setLong("value",gamesPlayed);
  
  saveTable(table, "data/new.csv");
}

public void keyPressed() {
  if (key=='w'||key=='W')keys[0]=true;
  if (key=='a'||key=='A')keys[1]=true;
  if (key=='s'||key=='S')keys[2]=true;
  if (key=='d'||key=='D')keys[3]=true;
  if (key=='q'||key=='Q')keys[4]=true;
  if (key=='e'||key=='E')keys[5]=true;
  if (key==' ')          keys[6]=true;
  if (key=='p'||key=='P')keys[7]=true;
  if (key=='m'||key=='M')keys[8]=true;
  if (key=='r'||key=='R')keys[9]=true;
  if (key==ESC) {
    key=0;
    keys[10]=true;
  }
  if (key==TAB) {
    key=0;
    keys[11]=true;
  }
}

public void mousePressed() {
  if (mouseButton==LEFT)keys[12]=true;
  if (mouseButton==RIGHT)keys[13]=true;
}

public void keyReleased() {
  if (key=='w'||key=='W')keys[0]=false;
  if (key=='a'||key=='A')keys[1]=false;
  if (key=='s'||key=='S')keys[2]=false;
  if (key=='d'||key=='D')keys[3]=false;
  if (key=='q'||key=='Q')keys[4]=false;
  if (key=='e'||key=='E')keys[5]=false;
  if (key==' ')          keys[6]=false;
  if (key=='p'||key=='P')keys[7]=false;
  if (key=='m'||key=='M')keys[8]=false;
  if (key=='r'||key=='R')keys[9]=false;
  if (key==ESC) {
    key=0;
    keys[10]=false;
  }
  if (key==TAB) {
    key=0;
    keys[11]=false;
  }
}

public void mouseReleased() {
  if (mouseButton==LEFT)keys[12]=false;
  if (mouseButton==RIGHT)keys[13]=false;
}
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
    weapon=new Pistol();
  }
  
  public void reset(){
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
  
  public void paint(){
    //ellipse(posX,posY,size,size);
    
    if(speedX==0)image(hunterStandI,posX,posY,size*2,size*2);
    else{
      walkingAnimation--;
      pushMatrix();
      translate(posX,posY);
      if(speedX<0)scale(-1.0f,1.0f);
      if(walkingAnimation>=45)image(hunterWalk2I,0,0,size*2,size*2);
      if(walkingAnimation>=30 && walkingAnimation<45) image(hunterWalk1I,0,0,size*2,size*2);
      if(walkingAnimation>=15 && walkingAnimation<30) image(hunterWalk2I,0,0,size*2,size*2);
      if(walkingAnimation<15) image(hunterWalk3I,0,0,size*2,size*2);
      if(walkingAnimation<=0)walkingAnimation=60;
      
      popMatrix();
    }
    fill(0xff0CAA52);
    if(dashCDremain<=0)fill(0xff3BA200);
    noStroke();
    rect(posX+(size*(dashCD-dashCDremain)/dashCD-size)/2,posY-size,size*(dashCD-dashCDremain)/dashCD,5);
    stroke(0);

    weapon.paint();
    
    if(shielded>0)image(shieldedI,posX,posY,size*2,size*2);
  }
  
  public void run(){
    speedX=0;
    if(keys[1] && !keys[3]) speedX=-speed;
    if(keys[3] && !keys[1]) speedX=speed;
    posX=posX+speedX;
    if(posX>1000)posX=0;
    if(posX<0)posX=1000;
  }
  
  public void dash(){
    if(dashCDremain<=0 && keys[13]){
      dashCDremain=dashCD;
      posX=mouseX;
      posY=mouseY;
      speedY=0;
      shielded=120;
      if(posY>700-size/2)posY=700-size/2;
    }
    if(dashCDremain>0)dashCDremain--;
  }
  
  public void jump(){
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
  
  public void fall(){
    if(posY<700-size/2){
      speedY=speedY+gravity;
      if(keys[2])speedY=speedY+speed/5;
    }
    if(keys[2] && speedY<0)speedY=0;
    
    if(posY>700-size/2){
      posY=700-size/2;
      speedY=0;
    }
    
    posY=posY+speedY;
    if(posY>700-size/2)posY=700-size/2;
  }
  
  public void shield(){
    if(shielded>0)shielded--;
  }
  
  public void getDmg(){
    if(shielded<=0){
      gameMode=0;
      saveData();
    }
  }
}
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
  
  public void checkAttack(){
    if(nextAttack<=0 && keys[12]){
      attack();
      nextAttack=nextAttack+120/attackspeed;
    }
    if(nextAttack>0) nextAttack--;
  }
  public void attack(){}
  
  public void paint(){}
  
}

class Pistol extends Weapon{
  
  
  Pistol(){
    super(10,2);
  }
  
  public void attack(){
    float distance=distance(patrick.posX,patrick.posY,mouseX,mouseY);
    Bullet bullet = new Bullet(patrick.posX+(mouseX-patrick.posX)/distance*30, patrick.posY+(mouseY-patrick.posY)/distance*30,
            14, (mouseX-patrick.posX)/distance*14, (mouseY-patrick.posY)/distance*14,dmg);
  }
  
  public void paint(){
    pushMatrix();
    translate(patrick.posX,patrick.posY);
    if(angle(patrick.posX,patrick.posY,mouseX,mouseY)>=PI)scale(-1.0f,1.0f);
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
  
  public void paint(){
    pushMatrix();
    translate(posX,posY);
    if(angle(0,0,speedX,speedY)%360>PI)scale(-1.0f,1.0f);
    turnImg(bulletI,0,0,size*2,size*2,HALF_PI+angle(0,0,speedX,speedY));
    popMatrix();
  }
  
  public void fly(){
    posX=posX+speedX;
    posY=posY+speedY;
  }
  
  public boolean checkHit(){
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
  
  public void paint(){
    pushMatrix();
    translate(posX,posY);
    if((angle(0,0,speedX,speedY))>=PI)scale(-1.0f,1.0f);
    turnImg(pringlesBulletI,0,0,size*2,size*2,HALF_PI+angle(0,0,speedX,speedY));
    popMatrix();
  }
}
  public void settings() {  size(1000,800,P2D);  smooth(8); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "PatrickThePinguHunter" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}

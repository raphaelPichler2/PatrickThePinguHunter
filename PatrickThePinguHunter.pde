boolean firstFrameClick=true;
Boolean[] keys= new Boolean[14];
Table table;
float fpms;
float mouseXF;
float mouseYF;

int gameMode;

float gravity=0.5;

Patrick patrick = new Patrick();
int money=0;
float highscore=0;
int gamesPlayed=0;

ArrayList<Bullet> bullets= new ArrayList<Bullet>();
ArrayList<Bubble> bubbles= new ArrayList<Bubble>();
ArrayList<Enemy> enemies= new ArrayList<Enemy>();
ArrayList<Item> items= new ArrayList<Item>();

Pistol pistol;
Shotgun shotgun;
Akimbo akimbo;
Sniper sniper;
Uzi uzi;

void setup(){
  size(1000,800,P2D);
  smooth(8);
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
  frameRate(120);
  imageMode(CENTER);
  
  for(int i=0;i<keys.length;i++){
    keys[i]=false;
  }
  
  loadGameState();
  gameMode=0; 
}

void draw(){
  background(255);
  pushMatrix();
  mouseXF=mouseX;
  mouseYF=mouseY;
  if(width>1000){
    translate(1920/2-500,1080/2-400);
    mouseXF=mouseX-1920/2+500;
    mouseYF=mouseY-1080/2+400;
  }
  if(gameMode==0){
  //mainMenu
  
    textAlign(LEFT, CENTER);
    textC("gold: "+money,20,20,20,0);
    textC("highscore: "+(int)highscore,20,40,20,0);
    textC("games played: "+gamesPlayed,20,60,20,0);
    textAlign(CENTER, CENTER);
  
    fill(255);
    rect(500,400,200,100);
    textC("start",500,400,20,0);
    if(buttonPressed(500,400,200,100)){
      startGame();
    }
    fill(255);
    rect(150,400,200,100);
    textC("shop",150,400,20,0);
    if(buttonPressed(150,400,200,100)){
      gameMode=3;
    }
  }
  
  
  if(gameMode==1)ingame();
  
  
  if(gameMode==2){
  //deathscreen
    
    if(score==highscore)textC("new highscore: ",500,50,40,0);
    textC("game over: ",500,100,40,0);
    
    textAlign(LEFT, CENTER);
    textC("gold this round: "+moneyInGame,20,20,20,0);
    textC("gold: "+money,20,40,20,0);
    textC("score: "+score,20,60,20,0);
    textC("highscore: "+(int)highscore,20,80,20,0);
    textC("enemies killed: "+enemiesKilled,20,100,20,0);
    textC("games played: "+gamesPlayed,20,120,20,0);
    textAlign(CENTER, CENTER);
  
    fill(255);
    rect(850,700,200,100);
    textC("next",850,700,20,0);
    if(buttonPressed(850,700,200,100)){
      gameMode=0;
    }
  }
  
  
  if(gameMode==3){
  //shop
  
    textC("money: "+money,50,50,16,0);
    drawShop(pistol, 1);
    drawShop(akimbo, 2);
    drawShop(uzi, 3);
    drawShop(sniper, 4);
    drawShop(shotgun, 5);
    
    
    fill(255);
    rect(850,700,200,100);
    textC("back",850,700,20,0);
    if(buttonPressed(850,700,200,100)){
      gameMode=0;
    }
  }
  
  popMatrix();
  if(width>1000)image(fullScreenI,1920/2,1080/2-20);
  
  if (!keyPressed && !mousePressed)firstFrameClick=true;  
  if (keyPressed || mousePressed)firstFrameClick=false;
}

void drawShop(Weapon w, int i){
  float posX = 50 + 100*(i%10);
  float posY = 50 + 100* (int)(i/10);
  
  fill(255);
  if(w==patrick.weapon)rect(posX,posY,90,90);
  image(w.shop,posX,posY,100,100);
  
  if(w.unlocked>0){
    textC(w.name,posX,posY+30,12,0);
    if(buttonPressed(posX,posY,90,90)){
      patrick.weapon=w;
    }
  }else{
    fill(255);
    rect(posX,posY+30,90,18);
    textC(""+w.price,posX,posY+30,12,0);
    if(buttonPressed(posX,posY+30,90,18) && money>=w.price){
      w.unlocked+=1;
      money-=w.price;
      saveData();
    }
  }
}

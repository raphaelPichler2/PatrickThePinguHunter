boolean firstFrameClick=true;
Boolean[] keys= new Boolean[14];
Table table;
float fpms;

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
  table= loadTable("new.csv","header,csv");
  money=table.getInt(0,"value");
  highscore=table.getInt(1,"value");
  gamesPlayed=table.getInt(2,"value");
  
  loadImages();
  gameMode=0;
}

void draw(){
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

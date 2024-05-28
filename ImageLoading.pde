PImage backgroundI;
PImage fullScreenI;
PImage hunterStandI;
PImage hunterWalk1I;
PImage hunterWalk2I;
PImage hunterWalk3I;
PImage fallschirmI;

PImage pistolI;
PImage pistolShotI;
PImage shotgunI;
PImage shotgunShotI;
PImage akimboI;
PImage akimboShotI;
PImage sniperI;
PImage sniperShotI;
PImage uziI;
PImage uziShotI;
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

void loadImages(){
  backgroundI=loadImage("background.png");
  fullScreenI=loadImage("FullScreen.PNG");
  hunterStandI=loadImage("Hunter.png");
  hunterWalk1I=loadImage("HunterWalk1.png");
  hunterWalk2I=loadImage("HunterWalk2.png");
  hunterWalk3I=loadImage("HunterWalk3.png");
  fallschirmI=loadImage("Fallschirm.png");
  
  pistolI=loadImage("Pistol.png");
  pistolShotI=loadImage("PistolShot.png");
  shotgunI=loadImage("Shotgun.png");
  shotgunShotI=loadImage("ShotgunShot.png");
  akimboI=loadImage("Akimbo.png");
  akimboShotI=loadImage("AkimboShot.png");
  sniperI=loadImage("Sniper.png");
  sniperShotI=loadImage("SniperShot.png");
  uziI=loadImage("Uzi.png");
  uziShotI=loadImage("UziShot.png");
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

void loadGameState(){
  loadImages();
  
  pistol = new Pistol();
  shotgun = new Shotgun();
  akimbo = new Akimbo();
  sniper=new Sniper();
  uzi=new Uzi();
  
  table= loadTable("new.csv","header,csv");
  money=table.getInt(0,"value");
  highscore=table.getInt(1,"value");
  gamesPlayed=table.getInt(2,"value");
  
  pistol.unlocked=table.getInt(3,"value");
  shotgun.unlocked=table.getInt(4,"value");
  akimbo.unlocked=table.getInt(5,"value");
  sniper.unlocked=table.getInt(6,"value");
  uzi.unlocked=table.getInt(7,"value");
  
  patrick.weapon = pistol;
}

void saveData(){
  
  table.getRow(0).setLong("value",money);
  table.getRow(1).setFloat("value",highscore);
  table.getRow(2).setLong("value",gamesPlayed);
  
  table.getRow(3).setInt("value",pistol.unlocked);
  table.getRow(4).setInt("value",shotgun.unlocked);
  table.getRow(5).setInt("value",akimbo.unlocked);
  table.getRow(6).setInt("value",sniper.unlocked);
  table.getRow(7).setInt("value",uzi.unlocked);
  
  saveTable(table, "data/new.csv");
}

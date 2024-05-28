boolean buttonPressed(float posX, float posY, float sizeX, float sizeY) {
  if (mousePressed && firstFrameClick && mouseXF<posX+sizeX/2 && mouseXF>posX-sizeX/2 && mouseYF<posY+sizeY/2 && mouseYF>posY-sizeY/2) {
    return true;
  }
  return false;
}

void turnImg(PImage img,float x,float y,float sizeX,float sizeY,float degr){
  pushMatrix();
  translate(x,y);
  rotate(degr);
  image(img,0,0,sizeX,sizeY);
  popMatrix();
}

void textC(String text,float x,float y, float size, color c){
  textSize(size);
  fill(c);
  text(text,x,y);
}

float w(){
  return width/1000.0;
}
float h(){
  return height/800.0;
}

float distance(float x1, float y1, float x2, float y2) {
  float distance=(float)Math.sqrt(Math.pow(x1-x2, 2)+Math.pow(y1-y2, 2));
  return distance;
}

float angle(float x1, float y1, float x2, float y2){
  float angle=0;
  angle=atan( (y2-y1) / (x2-x1));
  if(x1>x2)angle=TWO_PI-angle;
  if(x2-x1<=1 && x2-x1>=-1){
    if(y1<y2)angle=HALF_PI;
    if(y1>y2)angle=TWO_PI-HALF_PI;
  }
  
  return angle;
}

void keyPressed() {
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

void mousePressed() {
  if (mouseButton==LEFT)keys[12]=true;
  if (mouseButton==RIGHT)keys[13]=true;
}

void keyReleased() {
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

void mouseReleased() {
  if (mouseButton==LEFT)keys[12]=false;
  if (mouseButton==RIGHT)keys[13]=false;
}

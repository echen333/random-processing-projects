// 4/8/21

float val[][]=new float[30][30];

void setup(){
  size(600,600,P3D);
  for(int i=0;i<=10;i++){
    for(int j=0;j<=10;j++){
      val[i][j]=noise(i/5.0,j/5.0,100)*300;
    }
  }
  
}

int shi=5;
void draw(){
  
  clear();
  background(255);
  
  fill(0,255,0);
  strokeWeight(1);
  translate(width/2,width/2,0);
  rotateY(frameCount/50.0);
  for(int i=-5;i<=5;i++){
    for(int j=-5;j<=5;j++){
      if(i!=-5){
        line(i*30,val[shi+i][shi+j],j*30,(i-1)*30,val[shi+i-1][shi+j],j*30);
      }
      if(j!=-5){
        line(i*30,val[shi+i][shi+j],j*30,i*30,val[shi+i][shi+j-1],(j-1)*30);
      }
      if(i!=-5 && j!=-5){
        line(i*30,val[shi+i][shi+j],j*30,(i-1)*30,val[shi+i-1][shi+j-1],(j-1)*30);
      }
    }
  }
  
  
  
}

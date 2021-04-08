// 4/7/2021

static final int SZ=600;
static final int PAD=200;
int rad=SZ/20;
ArrayList<Rect> rect=new ArrayList<Rect>();
ArrayList<Seg> seg=new ArrayList<Seg>();
Point st;

color rectFill=#afb9fa;
color playerFill=#aba0e5;
color playOutline=#a888ce;
color rays=#a66eb3;
color back=#a15497;

boolean in(Point x){
   for(Rect y:rect){
     if(x.x>=y.l && x.x<=y.r && x.y>=y.u && x.y<=y.d){
       return true;
     }
   }
   //TODO: impl dist to seg, ugh...
   return false;
}

void setup(){
    size(600,600);
    int sepline=(int)random(SZ);
    while(sepline<PAD || sepline>SZ-PAD){
      sepline=(int)random(SZ);
    }
    //TODO: Constrain w/ padding?
    int u=(int)random(SZ), d=(int)random(SZ);
    int u2=(int)random(SZ), d2=(int)random(SZ);
    rect.add(new Rect((int)random(sepline),(int)random(sepline),u,d));
    rect.add(new Rect((int)random(SZ-sepline)+sepline,(int)random(SZ-sepline)+sepline,u2,d2));
    while(true){
      st=new Point((int)random(SZ), (int)random(SZ));
      if(!in(st))break;
    }
    for(Rect x:rect){
        seg.add(new Seg(new Point(x.l,x.u),new Point(x.r,x.u)));
        seg.add(new Seg(new Point(x.l,x.d),new Point(x.r,x.d)));
        seg.add(new Seg(new Point(x.l,x.u),new Point(x.l,x.d)));
        seg.add(new Seg(new Point(x.r,x.u),new Point(x.r,x.d)));
    }
    seg.add(new Seg(new Point(0,0),new Point(SZ,0)));
    seg.add(new Seg(new Point(0,0),new Point(0,SZ)));
    seg.add(new Seg(new Point(SZ,0),new Point(SZ,SZ)));
    seg.add(new Seg(new Point(0,SZ),new Point(SZ,SZ)));
}

float cross(PVector a, PVector b){
  return a.x*b.y-a.y*b.x;
}

boolean intersect(Point a, Point b, Point c, Point d){
  PVector B=new PVector(b.x-a.x,b.y-a.y);
  PVector C=new PVector(c.x-a.x,c.y-a.y);
  PVector D=new PVector(d.x-a.x,d.y-a.y);
  float c1=cross(B,C);
  float c2=cross(B,D);
  int cc1=(int)(c1/abs(c1));
  int cc2=(int)(c2/abs(c2));
  if(cc1+cc2!=0){
    return false;
  }
  PVector A=new PVector(a.x-c.x,a.y-c.y);
  B=new PVector(b.x-c.x,b.y-c.y);
  D=new PVector(d.x-c.x,d.y-c.y);
  c1=cross(D,A);
  c2=cross(D,B);
  cc1=(int)(c1/abs(c1));
  cc2=(int)(c2/abs(c2));
  if(cc1+cc2!=0){
    return false;
  }
  return true;
}

PVector castRay(PVector dir){//normalize first
  PVector mag=PVector.mult(dir,2*SZ);
  for(Seg x:seg){
    if(intersect(st,new Point(st.x+mag.x,st.y+mag.y),x.x,x.y)){
      float L=0,R=mag.mag();
      for(int i=0;i<30;i++){
        float M=(L+R)/2;
         PVector test=PVector.mult(dir,M);
         if(intersect(st,new Point(st.x+test.x,st.y+test.y),x.x,x.y)){
           R=M;
         } else L=M;
      }
      mag=PVector.mult(dir,L);
    }
  }
  return mag;
}

void draw(){
    clear();
    background(back);
    move();
    
    /*
    line(st.x,st.y,mouseX,mouseY);
    PVector dir=new PVector(mouseX-st.x,mouseY-st.y);
    PVector ldir=new PVector(mouseX-st.x,mouseY-st.y);
    PVector rdir=new PVector(mouseX-st.x,mouseY-st.y);
    println(dir.heading());
    ldir.rotate(PI/6);
    rdir.rotate(-PI/6);
    dir.normalize();
    PVector mag=castRay(dir);
    PVector lmag=castRay(ldir);
    PVector rmag=castRay(rdir);
    strokeWeight(1);
    line(st.x,st.y,st.x+mag.x,st.y+mag.y);
    line(st.x,st.y,st.x+lmag.x,st.y+lmag.y);
    line(st.x,st.y,st.x+rmag.x,st.y+rmag.y);
    */
    
    PVector prev=new PVector(0,0);
    noStroke();
    fill(rays);
    for(int i=0;i<300;i++){
      PVector ray=new PVector(mouseX-st.x,mouseY-st.y);
      ray.rotate(-PI/6);
      ray.normalize();
      ray.rotate(PI/3/300*i);
      PVector raymag=castRay(ray);
      triangle(st.x,st.y,st.x+prev.x,st.y+prev.y,st.x+raymag.x,st.y+raymag.y);
      prev=raymag;
    }
    
    fill(playerFill);
    strokeWeight(2);
    circle(st.x,st.y,rad);
    strokeWeight(3);
    fill(rectFill);
    for(Rect x:rect){
      rect(x.l,x.u,x.r-x.l,x.d-x.u);
    }
}

final static float move=5;
boolean isLeft,isRight,isDown,isUp;

void keyPressed(){
    setMove(keyCode,true);
}

void keyReleased(){
  setMove(keyCode,false);
}

void move(){
  float spd=move;
  if((isRight||isLeft) && (isDown||isUp)){
    spd/=1.41;
  }
  float x=constrain(st.x+spd*((int(isRight)-int(isLeft))),rad,SZ-rad);  
  float y=constrain(st.y+spd*((int(isDown)-int(isUp))),rad,SZ-rad);  
  if(!in(new Point(x,y))){
    st=new Point(x,y);
  } else if(!in(new Point(x,st.y))){
    st=new Point(x,st.y);
  } else if(!in(new Point(st.x,y))){
    st=new Point(st.x,y);
  }
}

void setMove(final int code, boolean act){  
  if(code==LEFT || code=='A'){
    isLeft=act;
  }
  if(code==UP || code=='W'){
    isUp=act;
  }
  if(code==DOWN || code=='S'){
    isDown=act;
  }
  if(code==RIGHT || code=='D'){
    isRight=act;
  }
}

class Point{
  float x,y;
  Point(float a, float b){
    x=a;y=b;
  }
}

class Seg{
  Point x, y;
  Seg(Point a, Point b){
    x=a;y=b;
  }
}

class Rect{
  int l,r,u,d;
  Rect(int a, int b, int c, int e){
    if(c<=e){
       u=c;
       d=e;
    } else {
      u=e;
      d=c;
    }
    if(a<=b){
      l=a;
      r=b;
    } else {
      l=b;
      r=a;
    }
  }
}

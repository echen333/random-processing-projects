import java.util.*;
int MX=50;
int RAD=40;//actually DIA
final int SZ=600;

ArrayList<Integer> adj[],lvl[];
int[] dep, par;
int mxDep=0;
//simple, equal spacing for each depth

//more like tree visualizer
void setup(){
   size(600,600);
   background(255);
   textAlign(CENTER);
   textSize(20);
   strokeWeight(2);
   
   String x=getString("Enter graph:");
   if(x==null)return;
   StringTokenizer st=new StringTokenizer(x);
   int n=Integer.parseInt(st.nextToken());
   dep=new int[n+1];
   par=new int[n+1];
   adj=new ArrayList[n+1];
   lvl=new ArrayList[n+1];
   for(int i=0;i<=n;i++){
     adj[i]=new ArrayList();
     lvl[i]=new ArrayList();
   }
   
   for(int i=0;i<n-1;i++){
       int u=Integer.parseInt(st.nextToken());
       int v=Integer.parseInt(st.nextToken());
       adj[u].add(v);
       adj[v].add(u);
   }
   
   dfs(1,1);
   mxDep++;
   
   float xcoord[]=new float[n+1];
   float ycoord[]=new float[n+1];
   for(int i=0;i<mxDep;i++){
     for(int j=0;j<lvl[i].size();j++){
       xcoord[lvl[i].get(j)]=(float)SZ*(j+1)/(lvl[i].size()+1);
     }
   }
   
   for(int i=1;i<=n;i++){ //<>//
     ycoord[i]=(float)SZ*(dep[i]+1)/(mxDep+1);
     fill(255);
     circle(xcoord[i],ycoord[i],RAD);
     fill(0);
     text(i,xcoord[i],ycoord[i]+RAD/5);
   }
   for(int i=2;i<=n;i++){
     line(xcoord[i],ycoord[i]-RAD/2,xcoord[par[i]],ycoord[par[i]]+RAD/2);
   }
}

void dfs(int n, int p){
  lvl[dep[n]].add(n);
  mxDep=Math.max(mxDep,dep[n]);
  for(int x:adj[n])if(x!=p){
    dep[x]=dep[n]+1;
    par[x]=n;
    dfs(x,n);
  }
}

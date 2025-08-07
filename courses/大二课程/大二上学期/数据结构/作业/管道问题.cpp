#include "iostream"
#include "stdlib.h"
#define MAX_VERTEX_NUM 20
typedef float WeightType;
typedef struct ArcNode{
	int adjvex;
	WeightType weight;
	struct ArcNode*nextarc;
}ArcNode;
typedef struct VertexNode{
	char data;
	ArcNode*firstarc;
}VertexNode,AdjList[MAX_VERTEX_NUM];
typedef struct{
	AdjList vertices;
	int vexnum,arcnum;
	int kind;
}ALGraph;
int LocateVex(ALGraph G,char v)
{
	int i;
	for(i=0;i<G.vexnum;i++)
	{
		if(G.vertices [i].data == v)
		return i;
	}
	return -1;
 } 
 void CreateGraph(ALGraph &G)
 {
 	int i,j,k;
 	char vi,vj;
 	WeightType weight;
 	ArcNode*p,*q;
 	std::cout<<"请输入顶点个数,边数和图的类型:\n";
 	std::cin>>G.vexnum >>G.arcnum >>G.kind ;
 	for(i=0;i<G.vexnum ;i++)
 	{
 		std::cout<<"请输入各个顶点:\n";
 		std::cin>>G.vertices[i].data ;
 		G.vertices[i].firstarc=NULL;
	 }
	 for(k=0;k<G.arcnum ;k++)
	 {
	 	std::cout<<"请输入两顶点和其边的权值:\n";
	 	std::cin>>vi>>vj>>weight;
	 	i=LocateVex(G,vi);
	 	j=LocateVex(G,vj);
	 	p=(ArcNode*)malloc(sizeof(ArcNode));
		p->adjvex=j;
		p->weight=weight;
		p->nextarc=G.vertices [i].firstarc;
		G.vertices [i].firstarc=p;
		if(G.kind == 2)
		{
			q=(ArcNode*)malloc(sizeof(ArcNode));
			q->adjvex=i;
			q->weight=p->weight;
			q->nextarc=G.vertices [j].firstarc;
			G.vertices [j].firstarc=q;
		}																				}                                                                                
	 }
 int MinEdge(WeightType lowcost[],int vexmun)
 {
 	int i,k;
 	WeightType j;
 	k=0;
 	while(lowcost[k]==0)
 	{
 		k++;
	}
	j=lowcost[k];
	for(i=k+1;i<vexmun;i++)
	{
		if(lowcost[i]!=0&&lowcost[i]<j)
		{
			j=lowcost[i];
			k=i;
		}
	}
	return k;
 }
 void Prim(ALGraph G,int v0, int adjvex[])
 {
 	WeightType lowcost[MAX_VERTEX_NUM];
 	int i,k;
 	ArcNode*p;
 	for(i=0;i<G.vexnum ;i++)
 	{
 	    if (i!=v0)
 		{
 			lowcost[i]=999;
 			adjvex[i]=v0;
		 }
	 }
	 p=G.vertices [v0].firstarc;
	 while(p)
	 {
	 	lowcost[G,p->adjvex]=p->weight;
	 	p=p->nextarc;
	 }
	 lowcost[v0]=0;
	 for(i=0;i<G.vexnum ;i++)
	 {
	 	k=MinEdge(lowcost,G.vexnum );
	 	if(k>=G.vexnum )
	 	return;
	 	std::cout<<"("<<k<<","<<adjvex[k]<<"),"<<lowcost[k]<<'\n';
	 	lowcost[k]=0;
	 	p=G.vertices [k].firstarc;
	 	while(p)
	 	{
	 		if(p->weight<lowcost[p->adjvex])
	 		{
	 			adjvex[p->adjvex]=k;
	 			lowcost[p->adjvex]=p->weight;
			 }
			 p=p->nextarc;
		 }
	 }
 }
 int main()
 {
 	int adjvex[MAX_VERTEX_NUM];
 	ALGraph G;
 	G.kind =2;
 	CreateGraph(G);
 	Prim(G,0,adjvex);
 	return 0;
 }



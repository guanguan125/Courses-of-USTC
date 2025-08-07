#include <stdio.h>
#include <stdlib.h>
#include <string.h>
typedef struct{
	char character='0';//记录节点的字母 
	int alaways=-1,rchild=-1,lchild=-1,parent;//左右孩子与双亲的物理指针 
	char num[20];
	int c=0;//判断是否进入树 
}Node;
Node node[100];//树的节点存放的数组 
int n;//字符集的大小 
int gen,o,p=-1;//根的下标 
char num1[20],aid11[100],aid22[1024],aid33[100],aid44[1024];//num1用来暂存01编码 
int min()
{
	int i,min;
	for(i=0;i<=gen;i++)
	{
		if(node[i].c==0){min=i;break;
		}
	}
	for(i=min+1;i<=gen;i++)
	{
		if(node[i].c==1)continue;
		if(node[i].alaways<node[min].alaways)min=i;
	}
	node[min].c=1;
	return min;
}
void Initialization()
{
	printf("请输入字符集的大小n：");scanf("%d",&n);getchar();gen=n-1;
	int i,j,k,he,l=n,temp;
	for(i=0;i<n;i++)
	{
		printf("请输入第%d个字符的类型以及权值：",i+1);
		scanf("%c%d",&node[i].character,&node[i].alaways);getchar();
		printf("%c%d\n",node[i].character,node[i].alaways);//检验用 
	}//前i+1个都是字符以及权值，接下来建立树
	j=min();///********************************************* 
	for(i=0;i<n-1;i++)
	{
		k=min();node[l].alaways=node[j].alaways+node[k].alaways;//jk是两个子叶 
		if(node[k].alaways<node[j].alaways) {temp=k;k=j;j=temp;}//进行交换 
		node[l].lchild=j;node[l].rchild=k;
		j=min();
		l++;gen=l-1;
	}//完成了初始的构建树，现在总共2*n-1=l个节点， 所以l--即可表示根 
	l--;gen=l;o=l;//现在l表示根 
} 
void bianma(int aim)
{
	p++;
	if(node[aim].lchild!=-1)
	{
		num1[p]='0';
		bianma(node[aim].lchild);
		p--;
		num1[p]='1';
		bianma(node[aim].rchild);
		p--;
	}
	else{
	
	num1[p]='\0';
	strcpy(node[aim].num,num1);
	printf("%c   %s\n",node[aim].character,node[aim].num);}
}
void  goujianma()//aid11来存放英语语句 aid22存放编码后的数字 
{
	int i,j;aid22[0]='\0';
	printf("请输入需要编译的语句：");fflush(stdin);
	gets(aid11);	
	for(i=0;aid11[i]!='\0';i++)
	{
		for(j=0;j<n;j++)
		{
			if(aid11[i]==node[j].character)strcat(aid22,node[j].num);
		}
	}
	printf("%s编码后的二进制为：\n%s\n",aid11,aid22);
	FILE *fp;
	if( (fp=fopen("C:\\Users\\asus\\Desktop\\CodeFile.txt","w+")) == NULL )
		{
    	printf("Fail to open file!\n");
    	exit(0);  //退出程序（结束程序）
		}
		fprintf(fp,"%s",aid22);
	fclose(fp);
}

void jiema()//aid33[100],aid44[1024]来存放语句与二进制 
{aid33[0]='\0';
	char shiyong[2];shiyong[1]='\0';
	int i,j,k=0,l,flag=0;
		FILE *fp;
	if( (fp=fopen("C:\\Users\\asus\\Desktop\\CodeFile.txt","r")) == NULL )
		{
    	printf("Fail to open file!\n");
    	exit(0);  //退出程序（结束程序）
		}
	fgets(aid44,1024,fp);
	for(i=0;aid44[i]!='\0';i++)//把aid44中的取出到num1中去比较 
	{	
		for(l=k;l<i+1;l++)
		{
			num1[l-k]=aid44[l];//k要变 
		}num1[l-k]='\0';
		
		for(j=0;j<n;j++)
		{
			if(strcmp(num1,node[j].num)==0)
			{shiyong[0]=node[j].character;
			strcat(aid33,shiyong);k=i+1;}
		}
	} 
	printf("%s解码后是：\n%s",aid44,aid33);
		fclose(fp);


 } 
 void dayin()
 {
 	int i=0,j;
 	while(aid22[i]!='\0')
 	{
 		for(j=0;j<50;j++,i++)
		 {
		 if(aid22[i]=='\0')break;
		 printf("%c",aid22[i]);
		 }
 		printf("\n");
	 }
 }
void dayinhuffman()
{
	int i;printf("下标-左子树下标-右子树下标\n");
 	for(i=0;node[i].alaways!=-1;i++)printf("%d	%d		%d\n",i,node[i].lchild,node[i].rchild) ;
}
int main()
{
	int x=-1,hui;
	while(x){
		printf("0.结束程序\n1.初始化\n2.编码\n3.解码\n4.打印代码文件\n5.打印huffman树\n");
		scanf("%d",&x);
		switch(x)
			{
				case 1:Initialization();bianma(o);break;
				case 2:goujianma();break;
				case 3:jiema();break;
				case 4:dayin();break;
				case 5:dayinhuffman();break;
				default:break;
			}
		scanf("%d",&hui);
		system("cls");
	}
 } 

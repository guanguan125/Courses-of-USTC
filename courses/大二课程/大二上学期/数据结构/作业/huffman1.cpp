#include <stdio.h>
#include <stdlib.h>
#include <string.h>
typedef struct{
	char character='0';//��¼�ڵ����ĸ 
	int alaways=-1,rchild=-1,lchild=-1,parent;//���Һ�����˫�׵�����ָ�� 
	char num[20];
	int c=0;//�ж��Ƿ������ 
}Node;
Node node[100];//���Ľڵ��ŵ����� 
int n;//�ַ����Ĵ�С 
int gen,o,p=-1;//�����±� 
char num1[20],aid11[100],aid22[1024],aid33[100],aid44[1024];//num1�����ݴ�01���� 
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
	printf("�������ַ����Ĵ�Сn��");scanf("%d",&n);getchar();gen=n-1;
	int i,j,k,he,l=n,temp;
	for(i=0;i<n;i++)
	{
		printf("�������%d���ַ��������Լ�Ȩֵ��",i+1);
		scanf("%c%d",&node[i].character,&node[i].alaways);getchar();
		printf("%c%d\n",node[i].character,node[i].alaways);//������ 
	}//ǰi+1�������ַ��Լ�Ȩֵ��������������
	j=min();///********************************************* 
	for(i=0;i<n-1;i++)
	{
		k=min();node[l].alaways=node[j].alaways+node[k].alaways;//jk��������Ҷ 
		if(node[k].alaways<node[j].alaways) {temp=k;k=j;j=temp;}//���н��� 
		node[l].lchild=j;node[l].rchild=k;
		j=min();
		l++;gen=l-1;
	}//����˳�ʼ�Ĺ������������ܹ�2*n-1=l���ڵ㣬 ����l--���ɱ�ʾ�� 
	l--;gen=l;o=l;//����l��ʾ�� 
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
void  goujianma()//aid11�����Ӣ����� aid22��ű��������� 
{
	int i,j;aid22[0]='\0';
	printf("��������Ҫ�������䣺");fflush(stdin);
	gets(aid11);	
	for(i=0;aid11[i]!='\0';i++)
	{
		for(j=0;j<n;j++)
		{
			if(aid11[i]==node[j].character)strcat(aid22,node[j].num);
		}
	}
	printf("%s�����Ķ�����Ϊ��\n%s\n",aid11,aid22);
	FILE *fp;
	if( (fp=fopen("C:\\Users\\asus\\Desktop\\CodeFile.txt","w+")) == NULL )
		{
    	printf("Fail to open file!\n");
    	exit(0);  //�˳����򣨽�������
		}
		fprintf(fp,"%s",aid22);
	fclose(fp);
}

void jiema()//aid33[100],aid44[1024]��������������� 
{aid33[0]='\0';
	char shiyong[2];shiyong[1]='\0';
	int i,j,k=0,l,flag=0;
		FILE *fp;
	if( (fp=fopen("C:\\Users\\asus\\Desktop\\CodeFile.txt","r")) == NULL )
		{
    	printf("Fail to open file!\n");
    	exit(0);  //�˳����򣨽�������
		}
	fgets(aid44,1024,fp);
	for(i=0;aid44[i]!='\0';i++)//��aid44�е�ȡ����num1��ȥ�Ƚ� 
	{	
		for(l=k;l<i+1;l++)
		{
			num1[l-k]=aid44[l];//kҪ�� 
		}num1[l-k]='\0';
		
		for(j=0;j<n;j++)
		{
			if(strcmp(num1,node[j].num)==0)
			{shiyong[0]=node[j].character;
			strcat(aid33,shiyong);k=i+1;}
		}
	} 
	printf("%s������ǣ�\n%s",aid44,aid33);
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
	int i;printf("�±�-�������±�-�������±�\n");
 	for(i=0;node[i].alaways!=-1;i++)printf("%d	%d		%d\n",i,node[i].lchild,node[i].rchild) ;
}
int main()
{
	int x=-1,hui;
	while(x){
		printf("0.��������\n1.��ʼ��\n2.����\n3.����\n4.��ӡ�����ļ�\n5.��ӡhuffman��\n");
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

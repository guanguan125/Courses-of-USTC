#include <stdio.h>
#include <stdlib.h>

char filename[50]; 
char keyword[20];
char tempstr[1024];
int next[20];
int length;
void getNext()
{
	int j=0,k=0;next[0]=-1;
	while(j<=length-1)
	if(k==-1||next[j]==next[k])
	{
		j++;k++;
		if(next[j]!=next[k])next[j]=k;
		else next[j]=next[k];
	}
	else k=next[k];
}
int Length(char S[])
{
	int m;
	for(m=0;;m++)
	{
		if(S[m]=='\0')return m;
	}
}
int index()
{
	int i=0,j=0,k=0,flag=1;

	FILE *fp;
	if((fp=fopen(filename,"r"))==NULL)
	{
		printf("打开文件%s出错\n",filename);
		return 0;
	}
	while(fgets(tempstr,1024,fp)!=NULL)
	{k++;i=0;j=0;
		while(j<Length(keyword)&&i<Length(tempstr))
		{
		if(j==-1||tempstr[i]==keyword[j])	{i++;j++;}
		else j=next[j];
		if(j==Length(keyword))
			{
			printf("第%d行第%d列\n",k,i-length+1);j=0;}
		}
		
	
	
			//if(tempstr[i+length-1]=='\0')break;
		}
		
	 
	 fclose(fp);
 } 

int main()
{
	printf("请分别输入文件名以及关键词(必须在结尾加斜杠n):\n");
	gets(filename);


	gets(keyword);
	length=Length(keyword);
	getNext();
	index();
}

#include <stdio.h>
#include <stdlib.h>
typedef struct{
	int *car,*time;

}SqStack;SqStack stop;
	int top=-1;

typedef struct Node{
	int Car;
	struct Node *next;
}list,*List;

List Creat(int n,int m)
{
	stop.car=new int[n];
	stop.time=new int[n];
	int i;
	List head=(List)malloc(sizeof(list));
	head->next=NULL;head->Car=0;
	for(i=1;i<n;i++)
	{
		List p=(List)malloc(sizeof(list));	
		p->Car=0;p->next=head;head=p;
	}
	return head;
}

void Delete(List head,int n)
{
	delete []stop.car;delete []stop.time;
	int i;List p;
	for(i=0;i<n;i++)
	{
		p=head;
		head=head->next;
		free(p);
		
	}
}

void Arrival(List head,int n,int m,int carID,int time)//+++++++++++++++++++++++++++
{
	int i;
	if(top==(n-1))
	{
		for(i=0;i<m;i++)
		{
			if(head->Car==0)
			{
				head->Car=carID;
				printf("%d���ں򳵳�%d��λ\n",carID,i+1);
				break;
			}
			head=head->next;
		}
	}
	else
	{
		top++;
		stop.car[top]=carID;stop.time[top]=time;
		printf("%d����ͣ����%d��λ\n",carID,top+1);
	}
}
List Leave(List head,int n,int m,int carID,int time)//+++++++++++++++++++++++++++
{
	int i,j;top--;
	for(i=0;i<n;i++)
	{
		if(stop.car[i]==carID)break;
	}
	printf("%d����ͣ������ͣ��%d�����շ�%fԪ\n",carID,time-stop.time[i],(float)(time-stop.time[i])/30);
	for(j=i;j<n-1;j++)
	{
		stop.car[j]=stop.car[j+1];
		stop.time[j]=stop.time[j+1];
	}stop.car[n-1]=0;stop.time[n-1]=0;
	List q=head; 
	if(head->Car!=0)
	{
		top++;
		stop.car[n-1]=head->Car;
		stop.time[n-1]=time;
		List p=head;head=head->next;q=head;
		free(p);p=(List)malloc(sizeof(list));	
		while(1)
		{
			if(head->next==NULL)
			{
				head->next=p;p->next=NULL;return q;
			}
			head=head->next;
			
		}
	}
	return q;
}
void ShowStop(int n)
{
	printf("����ͣ���ĳ��ƺŴ��ﵽ��Ϊ��\n"); 
	int i;
	for(i=0;i<n;i++)
	{
		if(stop.car[i]!=0)
		printf("%d\n",stop.car[i]);
	}
}
void ShowList(List head,int m)
{
	int i;
	printf("�����Ŷӵĳ��ƺŴ�ǰ����Ϊ��\n"); 
	for(i=0;i<m;i++)
	{
		if(head->Car!=0)
		{
			printf("%d\n",head->Car);
			head=head->next;
		 } 
	}
}
int main()
{

	int n,m,p;List head; 
	printf("�밴˳������ͣ��������n����������m��ͣ���۸�p��"); 
	scanf("%d%d%d",&n,&m,&p); 
	getchar();
	head=Creat(n,m);
	int carID,time;
	char state;
	while(1)
		{
			printf("�밴˳������״̬�����ƺš�ʱ�䣺"); 
			scanf("%c%d%d",&state,&carID,&time);getchar();
			switch(state)
			{
				case 'A':Arrival(head,n,m,carID,time);break;
				case 'D':head=Leave(head,n,m,carID,time);break;
				case 'P':ShowStop(n);break;
				case 'W':ShowList(head,m);break;
				case 'E':break;
				default:printf("error\n"); break;
			}
			if(state=='E'){printf("����\n"); break;}
		}
	Delete(head,n);
 } 

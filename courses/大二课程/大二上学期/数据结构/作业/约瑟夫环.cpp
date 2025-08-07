#include <stdio.h>
#include <stdlib.h>
typedef struct LNode
{
	int num;
	int qpy;
	struct LNode *next;
}LNode,*Linklist;

Linklist CreatList(int n)
{
	int i;
	Linklist head,p,q;
	head=(Linklist)malloc(sizeof(LNode));
	p=head;
	for(i=1;i<n;i++)
	{
		q=(Linklist)malloc(sizeof(LNode));
		p->next=q;q->next=NULL;p=q;q=NULL;
	}
	p->next=head;
	return head;
}

void PutInqpy(int n,Linklist p)
{
	int i;
	for(i=1;i<=n;i++)
	{
		p->num=i;
		scanf("%d",&p->qpy);
		p=p->next;
	}
}

void Delete(int n,int m,Linklist head)
{
	int i,j,k,o=n;
	Linklist p,q;

	for(i=1;i<o;i++)
	{
	if(m!=n)m=m%n;
	if(m==1)
	{
		q=head;p=head;
		head=head->next;
		m=q->qpy;
		printf("%d ",q->num);
		for(;;)
		{
		
			if(p->next==q)break;
			p=p->next;
		}
		p->next=head;
		delete q;
	}
	else 
	{
		q=head;p=head;
		for(j=1;j<m;j++)q=q->next;
		for(;;)
		{
		
			if(p->next==q)break;
			p=p->next;
		}p->next=p->next->next;
		m=q->qpy;
		printf("%d ",q->num);
		head=q->next;
		delete q;
	}
	n--;
	}
	printf("%d ",head->num);
	delete head;
	
}

int main()
{
	int n,m;
	Linklist head; 
	printf("请输入总人数");
	scanf("%d",&n);
	printf("请输入初始密码");
	scanf("%d",&m);
	head=CreatList(n);//完成了循环链表的创建
	printf("请输入每个人的密码：");
	PutInqpy(n,head);
	Delete(n,m,head);
	return 0;
}  

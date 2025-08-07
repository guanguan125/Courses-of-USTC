#ifndef QUEUE_H
#define QUEUE_H

#include "net.h"

// 队列中元素变量
typedef struct Struct_Window_Packet Queue_Element_Type;

// 队列元素节点
struct Struct_Queue_Node
{
	// 数据域
	Queue_Element_Type data;
	// 下一个元素指针
	struct Struct_Queue_Node *next;
};

// 队列结构体
struct Struct_Queue
{
	// 队尾指针
	struct Struct_Queue_Node *rear;
	// 队首指针
	struct Struct_Queue_Node *front;
	// 长度
	int length;
	// 队列指针, 即空节点位置, 其下一个元素就三首元
	struct Struct_Queue_Node *p;
};

/**
 * @brief 初始化队列并创造一个空节点, 空节点不属于队列元素
 *
 * @param q 队列指针
 * @return int 正常返回0, 出错返回非0
 */
int Queue_Init(struct Struct_Queue *&q)
{
	q = (struct Struct_Queue *)malloc(sizeof(struct Struct_Queue));
	if (q == NULL)
	{
		return (1);
	}
	q->p = (struct Struct_Queue_Node *)malloc(sizeof(struct Struct_Queue_Node));
	if (q->p == NULL)
	{
		return (2);
	}
	q->p->next = NULL;
	q->front = NULL;
	q->rear = NULL;
	q->length = 0;
	return (0);
}

/**
 * @brief 销毁队列
 *
 * @param q 队列指针
 */
void Queue_Destroy(struct Struct_Queue *&q)
{
	struct Struct_Queue_Node *flag, *res;
	flag = q->p;
	while (flag != NULL)
	{
		res = flag;
		flag = flag->next;
		free(res);
	}
	free(q);
	q = NULL;
	return;
}

/**
 * @brief 清空队列
 *
 * @param q 队列指针
 */
void Queue_Clear(struct Struct_Queue *q)
{
	struct Struct_Queue_Node *flag1, *flag2;
	flag1 = q->p->next;
	while (flag1 != NULL)
	{
		flag2 = flag1;
		flag1 = flag1->next;
		free(flag2);
	}
	q->front = NULL;
	q->rear = NULL;
	q->length = 0;
	q->p->next = NULL;
	return;
}

/**
 * @brief 判断队列是否为空
 *
 * @param q 队列指针
 * @return int 队列空返回1, 否则返回0
 */
int Queue_Empty(struct Struct_Queue *q)
{
	if (q->length == 0)
	{
		return (1);
	}
	else
	{
		return (0);
	}
}

/**
 * @brief 获取队列长度
 *
 * @param q 队列指针
 * @return int 队列长度
 */
int Queue_Length(struct Struct_Queue *q)
{
	return (q->length);
}

/**
 * @brief 获取队列首元
 *
 * @param q 队列指针
 * @param e 队列首元地址, 其值被赋于此, 如果是NULL则不赋值
 * @return int 正常返回0, 出错返回非0
 */
int Queue_Front(struct Struct_Queue *q, Queue_Element_Type *e)
{
	if (q->length == 0)
	{
		return (1);
	}
	if (e != NULL)
	{
		*e = q->front->data;
	}
	return (0);
}

/**
 * @brief 获取队列尾元
 *
 * @param q 队列指针
 * @param e 队列尾元地址, 其值被赋于此, 如果是NULL则不赋值
 * @return int 正常返回0, 出错返回非0
 */
int Queue_Rear(struct Struct_Queue *q, Queue_Element_Type *e)
{
	if (q->length == 0)
	{
		return (1);
	}
	if (e != NULL)
	{
		*e = q->rear->data;
	}
	return (0);
}

/**
 * @brief 元素进队
 *
 * @param q 队列指针
 * @param e 进队元素
 * @return int 正常返回0, 出错返回非0
 */
int Queue_Enter(struct Struct_Queue *q, Queue_Element_Type e)
{
	struct Struct_Queue_Node *enter_element;
	enter_element = (struct Struct_Queue_Node *)malloc(sizeof(struct Struct_Queue_Node));
	if (enter_element == NULL)
	{
		return (1);
	}
	enter_element->data = e;
	enter_element->next = NULL;
	if (q->length == 0)
	{
		q->p->next = enter_element;
		q->front = q->p->next;
		q->rear = q->p->next;
	}
	else
	{
		q->rear->next = enter_element;
		q->rear = enter_element;
	}
	q->length++;
	return (0);
}

/**
 * @brief 元素出队
 *
 * @param q 队列指针
 * @param e 出队元素, 其值被赋于此, 如果是NULL则不赋值
 * @return int 正常返回0, 出错返回非0
 */
int Queue_Depart(struct Struct_Queue *q, Queue_Element_Type *e)
{
	struct Struct_Queue_Node *depart_element;
	depart_element = q->front;
	if (q->length == 0)
	{
		return (1);
	}
	if (e != NULL)
	{
		*e = depart_element->data;
	}
	if (q->length == 1)
	{
		free(q->p->next);
		q->p->next = NULL;
		q->front = NULL;
		q->rear = NULL;
	}
	else
	{
		q->p->next = q->front->next;
		free(q->front);
		q->front = q->p->next;
	}
	q->length--;
	return (0);
}

/**
 * @brief 遍历队列, 遍历内容需自行指定
 *
 * @param q 队列指针
 */
void Queue_Traverse(struct Struct_Queue *&q)
{
	struct Struct_Queue_Node *flag;
	for (flag = q->front; flag != NULL; flag = flag->next)
	{
		printf("%d\n", flag->data.sequence);
	}
	return;
}

#endif

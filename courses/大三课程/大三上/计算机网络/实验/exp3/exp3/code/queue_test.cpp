#include "queue.h"

int main(int argc, char const *argv[])
{
    Struct_Queue *q;
    Queue_Init(q);

    Queue_Element_Type e;
    for(int i = 0; i < 10; i++)
    {
        e.sequence = i;
        Queue_Enter(q, e);
    }
    printf("test enter\n");
    Queue_Traverse(q);


    for(int i = 0; i < 5; i++)
    {
        Queue_Depart(q, NULL);
    }
    printf("test depart\n");
    Queue_Traverse(q);

    Queue_Enter(q, e);
    printf("test enter\n");
    Queue_Traverse(q);

    Queue_Clear(q);
    printf("test clear\n");
    Queue_Traverse(q);

    for(int i = 0; i < 10; i++)
    {
        e.sequence = i;
        Queue_Enter(q, e);
    }
    printf("test enter\n");
    Queue_Traverse(q);

    printf("test rear and front\n");
    printf("%d\n", q->rear->data.sequence);printf("%d\n", q->front->data.sequence);
    return 0;
}

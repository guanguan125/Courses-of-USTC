/*
 * exp1.c
 *
 * Created: 2023/4/23 15:41:19
 * Author : Lenovo
 */ 
#include <avr/io.h>
#include <avr/interrupt.h>
ISR(TIMER0_OVF_vect)
{ PORTC ^=(1<<PORTC0);}
int main(void)
{ DDRC |=(1<<DDRC0);//PC0Ϊ�����LED����
	TCCR0 = (1<<CS02)|(1<<CS00);//1024��Ƶ
	TCNT0 = 0;//��0��ʼ����
	TIMSK |=(1<<TOIE0);//����TOV0�ж�
	sei();//ȫ���жϿ�
	while (1)
	{
	}
}


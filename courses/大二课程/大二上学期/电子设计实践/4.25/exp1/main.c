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
{ DDRC |=(1<<DDRC0);//PC0为输出到LED正极
	TCCR0 = (1<<CS02)|(1<<CS00);//1024分频
	TCNT0 = 0;//从0开始计数
	TIMSK |=(1<<TOIE0);//允许TOV0中断
	sei();//全局中断开
	while (1)
	{
	}
}


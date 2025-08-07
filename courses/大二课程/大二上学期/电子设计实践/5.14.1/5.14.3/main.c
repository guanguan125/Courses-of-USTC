/*
 * 5.14.3.c
 *
 * Created: 2023/5/14 21:18:15
 * Author : Lenovo
 */ 
#define F_CPU 8000000UL
#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>
#include "twi_lcd.h"
unsigned char duty=50;//占空比，百分比
unsigned int freq=30;//30~8000Hz
ISR(INT0_vect)
{ if(duty > 90)//百分比
	 duty = 10;
	else duty +=5;
}
ISR(INT1_vect)
{ if(freq >7999) freq = 30;
	else freq +=100;
}
int main(void)
{ 
	DDRD &=~((1<<DDRD2) |(1<<DDRD3));//INT0(PD2)和INT1(PD3)分别调整占空比和频率
	PORTD |=(1<<PORTD2)|(1<<PORTD3);//开启内部上拉电阻，即PD2和PD3管脚默认为高电平
	DDRB |=(1<<DDRB1);//PB1控制蜂鸣器的IO
	MCUCR |=(1<<ISC01)|(1<<ISC11);//INT0和INT1下降沿触发中断（执行对应的ISR）
	GICR |=(1<<INT0)|(1<<INT1);//开中断
	sei();//全局中断开
	unsigned int high,low,i;
	while (1)
	{ high = F_CPU/freq*duty/100;//
		low = F_CPU/freq - high;//
		if(low >1290)low-=1290;
		high /=12; low /=12;
		PORTB |=(1<<PORTB1);for(i=0;i<high;i++) _delay_us (1);
		PORTB &=~(1<<PORTB1);for(i=0;i<low;i++) _delay_us (1);
	}
}
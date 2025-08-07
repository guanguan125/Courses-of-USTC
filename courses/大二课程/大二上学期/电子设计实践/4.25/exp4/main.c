/*
 * exp4.c
 *
 * Created: 2023/4/23 19:41:34
 * Author : Lenovo
 */ 
#include <avr/io.h>
#include "twi_lcd.h"
#include <avr/interrupt.h>
unsigned char counter=1;
ISR(INT0_vect)
{if(counter <20)
	counter++;
	else
	counter = 1;
}
ISR(TIMER1_OVF_vect)
{
	OCR1A = counter * 6;
}
int main(void)
{ unsigned char uc_tmp; LCD_Init();
	DDRB |=(1<<DDRB1);//PB1(OC1A)���
	ICR1 = 200;/*TOPֵ*/ OCR1A = 10;//A·�Ƚ�ֵ
	TCCR1A |= (1<<COM1A1)|(1<<COM1A0);//�ܽ��л���ʽ
	TCCR1B |= (1<<WGM13)|(1<<CS11);//ģʽΪ8��ʱ��8��Ƶ
	TIMSK =(1<<TOIE1);//����TC1����ж�
	DDRD &= ~(1<<DDRD2);//PD2(int0)Ϊ����<-tp223
	MCUCR |=((1<<ISC01)|(1<<ISC00));//int0 �����ش����ж�
	GICR |= (1<<INT0);/*����INT0�ж�*/ sei(); //��ȫ���ж�
	while (1) { uc_tmp = counter;
		LCD_Write_Char(0,6,uc_tmp/10+0x30);
		LCD_Write_NewChar(uc_tmp%10+0x30);
	_delay_ms (2); }
}
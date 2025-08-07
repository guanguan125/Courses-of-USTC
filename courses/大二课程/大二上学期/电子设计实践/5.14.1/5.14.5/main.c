/*
 * 5.14.5.c
 *
 * Created: 2023/5/15 19:13:36
 * Author : Lenovo
 */ 
#define F_CPU 1000000UL
#include <avr/io.h>
#include "twi_lcd.h"
#include <util/delay.h>
int main(void)
{ unsigned char i=2,ch=33;//����
	//UCSRC = 0x80;//���UCSRC
	UBRRH = 0;
	UBRRL = 12;//1MHz,4800bps,0.2%
	UCSRB = (1<<RXEN)|(1<<TXEN);
	//����USART���պͷ���
	UCSRC =(1<<URSEL)|(3<<UCSZ0);
	//�첽,��У��,8λ��1ֹͣλ,...
	TWI_Init();
	LCD_Init();
	LCD_Write_String(0,0,"S:");
	//LCD��1����ʾ
	LCD_Write_String(1,0,"R:");
	while (1)
	{ LCD_Write_Char(0,i,ch);//��ʾ���͵�����
		while(!(UCSRA & (1<<UDRE)));//�ȴ�����
		//���Է������ݣ�
		UDR = ch;//��������
		//_delay_us(100);
		_delay_ms (200);
		while(!(UCSRA & (1<<RXC)));//�ȴ�����
		LCD_Write_Char(1,i,UDR);//��ʾ��������
		if(i==15)i=2;//�ƻ�����ʾ
		else i++;
		if(ch==127)ch=161;//����
		else if(ch==223)ch=33;//�ƻ���
		else ch++;//��һ��������ʾ���ַ�
		_delay_ms (200);
	} //while����
} //main����



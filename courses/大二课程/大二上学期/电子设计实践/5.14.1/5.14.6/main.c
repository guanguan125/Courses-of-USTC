/*
 * 5.14.6.c
 *
 * Created: 2023/5/15 19:24:08
 * Author : Lenovo
 */ 
#define F_CPU 1000000UL
#include <avr/io.h>
#include "twi_lcd.h"
#include <util/delay.h>
unsigned char tmp[4];
int main(void)
{ unsigned char i=0,tp_r=0;//��ʱ����
	TCNT0 = 0;//����TC0ͳ�ƿ��صĴ���
	TCCR0 = (1<<CS02)|(1<<CS01)|(1<<CS00);
	//��T0�����ؼ���
	UCSRC = 0x80;//���UCSRC
	UBRRH = 0;//
	UBRRL = 12;//1MHz,4800bps,0.2%
	UCSRB = (1<<RXEN)|(1<<TXEN);
	//����USART���պͷ���
	UCSRC =(1<<URSEL)|(3<<UCSZ0);
	//�첽,��У��,8λ���ݣ�1λֹͣλ,...
	TWI_Init();
	LCD_Init();
	LCD_Write_String(0,0,"a:Touchpad");
	while (1)
	{ if(tp_r!=TCNT0)//���ش��������仯
		{ tp_r = TCNT0;
			//��ȡTCNT0�����µĿ��ش���
			while(!(UCSRA & (1<<UDRE)));
			//���Է������ݣ�
			UDR = tp_r;//��������
		}
		if(UCSRA & (1<<RXC))//���յ�����?
		{ LCD_Write_Char(1,i,UDR);//��ʾ
			i++;
		}
		if(i>15)i=0;//�����ʾ��������
		_delay_ms (1);
	}
}
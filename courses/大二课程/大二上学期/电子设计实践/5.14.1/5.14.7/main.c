/*
 * 5.14.7.c
 *
 * Created: 2023/5/15 19:51:21
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
	UBRRH = 0;
	UBRRL = 12;//1MHz,4800bps,0.2%
	UCSRB = (1<<RXEN)|(1<<TXEN);
	//����USART���պͷ���
	UCSRC =(1<<URSEL)|(3<<UCSZ0);
	//�첽,��У��,8λ���ݣ�1λֹͣλ,...
	TWI_Init();
	LCD_Init();
	LCD_Write_String(0,0,"b:Trans");
	while (1)
	{ if(UCSRA & (1<<RXC))//���յ�����
		{ tp_r = UDR;//������
			i=3; //1�ֽ����3λ10������
			while(tp_r>0)//ת�����ַ�
			{ tmp[i]=tp_r%10+0x30;
				tp_r = tp_r/10;
				while(!(UCSRA & (1<<UDRE)));//�ȴ�
				UDR = tmp[i];//�����ַ�
				i--;
			}
			while(i>0)//�����λ����ʾ
			{ tmp[i--]=0x20; }
			LCD_Write_String(1,0,tmp);
		}
		_delay_ms(1);
	} //while����
} //main����

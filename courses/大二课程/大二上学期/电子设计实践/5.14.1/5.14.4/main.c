/*
 * 5.14.4.c
 *
 * Created: 2023/5/15 18:48:08
 * Author : Lenovo
 */ 
#define F_CPU 1000000UL
#include <avr/io.h>
#include "twi_lcd.h"
#include <util/delay.h>
int main(void)
{ unsigned char cmd_cnt=2,cmd_data[3]={0,0,0};//�������������
UCSRC = 0x80;//���UCSRC
UBRRL = 0;//
UBRRL = 12;//1MHz,4800bps,0.2%
UCSRB = (1<<RXEN)|(1<<TXEN);//����USART���պͷ���
UCSRC =(1<<URSEL)|(3<<UCSZ0);//�첽,��У��,8λ���ݣ�1λֹͣλ,...
TWI_Init();
LCD_Init();
while (1)
{ if(UCSRA & (1<<RXC))//���յ�����
	{ cmd_data[cmd_cnt] = UDR;//������
		cmd_cnt--;
	}
if(cmd_cnt<1)//�յ������ֽ�
{ switch(cmd_data[2])
	{//case 0xc0://LCDָ��ֱ�Ӳ���
		case 0x5c://proteus:\+����
		LCD_8Bit_Write(cmd_data[1],0);
		break;
		case 0xc1://��æ��־
		break;
		//case 0xc2://��RAMд����
		case 0x5d://proteus ]+��ʾ�ַ�
		LCD_8Bit_Write(cmd_data[1],1);
		break;
		case 0xc3://��RAM������
		break;
	}
	while(!(UCSRA & (1<<UDRE)));//�ȴ�����
	UDR = 'O';//�����ַ�
	while(!(UCSRA & (1<<UDRE)));//�ȴ�����
	UDR = 'K';//�����ַ�
	cmd_cnt=2;//������һ����������
}
_delay_ms (1);
} //while����
} //main����

/*
 * 5.14.1.c
 *
 * Created: 2023/5/14 20:14:32
 * Author : Lenovo
 */ 

#include <avr/io.h>
#define F_CPU 1000000UL
#include <util/delay.h>
#include <util/twi.h> //TWI�ӿ�״̬�붨���
#include "twi_lcd.h"
#include <avr/interrupt.h>
unsigned char hexStr[17]={'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F','-'};
unsigned char key_no[5]={16,16,16,16,0};//���4λ�������µı���,�ԡ�\0'����
unsigned char getkey,keyno;//ȡ��������ɨ�����룬���°����ı���
int main(void) { DDRD = (0xf0);//PD7~4Ϊ���S_R0~3��PD3~0Ϊ����S_C0~3
	PORTD = (0xff);//PD7~4����ߵ�ƽ,PD3~0���ڲ�������������
	TCCR0 = (1<<CS02)|(1<<CS00);//1024��Ƶ
	TCNT0 = 102;//��102��ʼ������1MHz/1024/154ԼΪ150ms�ж�һ��
	TIMSK |=(1<<TOIE0);//����TOV0�ж�
	TWI_Init(); LCD_Init();
	sei();//ȫ���жϿ�
	while (1) 
	{ LCD_Write_Char(0,1,hexStr[key_no[3]]);
		LCD_Write_NewChar(hexStr[key_no[2]]);
		LCD_Write_NewChar(hexStr[key_no[1]]);
		LCD_Write_NewChar(hexStr[key_no[0]]);
		_delay_ms(20); 
	}
}
		ISR(TIMER0_OVF_vect)//����ж�TCNT0=255�����102
		{ TCNT0 = 102;//��102��ʼ������1MHz/1024/154ԼΪ150ms�ж�һ��
			keyno = 16;//Ĭ���ް�������
			//1.ɨ���1��
			PORTD = ~(1<<PORTD7);//PORTD7Ϊ0,����Ϊ1���͸���1��
			_delay_us(2);
			getkey = (PIND & 0x0f);//ȡ�������е���״̬
			switch(getkey) { case 0x07:keyno = 0;break;//1��1�б���Ϊ0/1 //S4
				case 0x0b:keyno = 1;break;//1��2�б���Ϊ1/2 //S8
				case 0x0d:keyno = 2;break;//1��3�б���Ϊ2/3 //S12
			case 0x0e:keyno = 3;break;//1��4�б���Ϊ3/A //S16
			 }
			//2.ɨ���2��
			PORTD = ~(1<<PORTD6);//PORTD6Ϊ0,����Ϊ1���͸���2��
			_delay_us(2);
			getkey = (PIND & 0x0f);//ȡ�������е���״̬
			//3.ɨ���3��
			//4.ɨ���4��
			PORTD = ~(1<<PORTD4);//PORTD4Ϊ0������Ϊ1���͸���4��
			_delay_us(2); getkey = (PIND & 0x0f);//ȡ�������е���״̬
			switch(getkey) { case 0x07:keyno =12;break;//4��1�б���Ϊ12/*
			case 0x0b:keyno =13;break;//4��2�б���Ϊ13/0
			case 0x0d:keyno =14;break;//4��3�б���Ϊ14/#
			case 0x0e:keyno =15;break;//4��4�б���Ϊ15/D
			 }
			/*һ�ְ������д������*/
			if(keyno<16) { key_no[3]=key_no[2]; //�ƶ���������
			key_no[2]=key_no[1];
			key_no[1]=key_no[0];
			key_no[0]=keyno; //�µİ������� 
			}
		} //ISR����
			


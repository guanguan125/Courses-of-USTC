/*
 * GccApplication2.c
 *
 * Created: 2023/4/9 15:10:40
 * Author : Lenovo
 */ 

#include <avr/io.h>
#define F_CPU 1000000UL
#include <util/delay.h>
#include <avr/interrupt.h>
unsigned int counter=0; //ȫ�ֱ���
ISR(INT1_vect)
{if(counter < 9999) counter++;
else counter = 0; }
int main(void)
{
    /* Replace with your application code */
	unsigned char seg7_hex[16]=
	{0xfc,0x60,0xda,0xf2,0x66,0xb6,0xbe,0xe0,
	0xfe,0xf6,0xee,0x3e,0x9c,0x7a,0x9e,0x8e};//MSB-a,��,g,dp-LSB
	unsigned char i,seg7_com[4]={0xe,0xd,0x0b,0x07};
	unsigned int d_t;
	DDRC = (0x0f);//PC3~0Ϊ��������ƹ�����-1,-2,-3,-4
	DDRB = (0xff);//PB7~0Ϊ�������Ӧ����a,b,...,g,dp�ε�����
	DDRD &= ~(1<<DDRD3);//PD2(int0)���Ӵ�������
	MCUCR |=((1<<ISC11)|(1<<ISC10));//int0 �����ش����ж�
	GICR |= (1<<INT1);//����INT0�ⲿ�ж�
	sei(); //����ȫ���ж�SREG(I)
    while (1) 
    {
		d_t = counter;
		for(i=0;i<4;i++)
		{ PORTC |=0x0f; //��ֹ��ʾ
			PORTB =seg7_hex[d_t%10]; //����
			PORTC =seg7_com[i]; //��ʾ
			d_t=d_t/10; //��һλ
			_delay_ms(5);
		}
    }
}


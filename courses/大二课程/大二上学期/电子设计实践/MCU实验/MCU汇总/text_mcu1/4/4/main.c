/*
 * 4.c
 *
 * Created: 2023/3/29 19:46:05
 * Author : Lenovo
 */ 

#include <avr/io.h>
#define F_CPU 1000000UL
#include <util/delay.h>

int main(void)
{
	DDRB = (1<<DDRB0);//PB0Ϊ���ģʽ
	DDRD &= ~(1<<DDRD1);//PB1Ϊ����
    /* Replace with your application code */
    while (1) 
    {
		if(PIND & (1<<PIND1)) //PINB[1]=1?
		{
			int i,j;
		DDRB = (1<<DDRB0); //PC[2~0]Ϊ���
		for(i=0;i<100;i++)//����
		{ PORTB |= (1<<PORTB0);//PC[0]=1
			for(j=0;j<=i;j++)_delay_us(150);
			PORTB &= ~(1<<PORTB0);//PC[0]=0
			for(j=0;j<100-i;j++)_delay_us(150);
		}
		for(i=100;i>0;i--)//����
		{ PORTB |= (1<<PORTB0);//PC[0]=1
			for(j=0;j<=i;j++)_delay_us(150);
			PORTB &= ~(1<<PORTB0);//PC[0]=0
			for(j=0;j<100-i;j++)_delay_us(150);
		}
		}
		else
		PORTB &= ~(1<<PORTB0); //PORTC[0]=0
    }
}


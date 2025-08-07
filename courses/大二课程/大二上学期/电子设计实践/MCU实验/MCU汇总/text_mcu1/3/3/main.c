/*
 * 3.c
 *
 * Created: 2023/3/29 19:36:27
 * Author : Lenovo
 */ 

#include <avr/io.h>
#define F_CPU 1000000UL
#include <util/delay.h>

int main(void)
{
    /* Replace with your application code */
	int i,j;
	DDRD = (1<<DDRD2); //PC[2~0]ÎªÊä³ö
	while(1)
	{
	for(i=0;i<100;i++)//½¥ÁÁ
   { PORTD |= (1<<PORTD2);//PC[0]=1
	   for(j=0;j<=i;j++)_delay_us(150);
	   PORTD &= ~(1<<PORTD2);//PC[0]=0
	   for(j=0;j<100-i;j++)_delay_us(150);
   }
   for(i=100;i>0;i--)//½¥°µ
   { PORTD |= (1<<PORTD2);//PC[0]=1
	   for(j=0;j<=i;j++)_delay_us(150);
	   PORTD &= ~(1<<PORTD2);//PC[0]=0
	   for(j=0;j<100-i;j++)_delay_us(150);
   }
	}    
}


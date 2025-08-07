/*
 * 2.c
 *
 * Created: 2023/3/29 19:31:15
 * Author : Lenovo
 */ 

#include <avr/io.h>


int main(void)
{
    /* Replace with your application code */
	int i,j;
	DDRB |= (1<<DDRB1)|(1<<DDRB2)|(1<<DDRB3);
    while (1) 
    {
		PORTB = (1<<PORTB1);//only red on
		for(i=0;i<100;i++)
		for(j=0;j<1000;j++);
		PORTB = (1<<PORTB2);//only green on
		for(i=0;i<100;i++)
		for(j=0;j<1000;j++);
		PORTB = (1<<PORTB3);//only blue on
		for(i=0;i<100;i++)
		for(j=0;j<1000;j++);
    }
}


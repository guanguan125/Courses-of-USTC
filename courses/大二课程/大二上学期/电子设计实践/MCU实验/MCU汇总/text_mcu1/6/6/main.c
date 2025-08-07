/*
 * 6.c
 *
 * Created: 2023/3/29 21:20:56
 * Author : Lenovo
 */ 

#include <avr/io.h>


int main(void)
{
    unsigned char tpr1=0, tpr2=0,counter=0;
	DDRB= (1<<DDRB2)|(1<<DDRB3)|(1<<DDRB4);
	DDRD &= ~(1<<DDRD6);
    /* Replace with your application code */
    while (1) 
    {
		tpr2 = tpr1;
		tpr1 = (PIND & (1<<PIND6))>>6;
		if(tpr2==0 && tpr1==1)counter++;
		switch(counter)
		{
			case 1 : PORTB = (1<<PORTB2);break;
			case 2 : PORTB = (1<<PORTB3);break;
			case 3 : PORTB = (1<<PORTB4);break;
			default :PORTB =0;counter = 0;
		}
    }
}


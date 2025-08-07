/*
 * 实验5(2).c
 *
 * Created: 2023/4/9 14:53:59
 * Author : Lenovo
 */ 

#include <avr/io.h>
#include <avr/interrupt.h>
unsigned char counter=0; //全局,开关次数
ISR(INT1_vect)//似函数
{ if(counter <4)
	counter++;
	else counter = 0;
}
int main(void)
{
	unsigned char seg7_hex[16]=
	{0xfc,0x60,0xda,0xf2,0x66,0xb6,0xbe,0xe0,
	0xfe,0xf6,0xee,0x3e,0x9c,0x7a,0x9e,0x8e};//MSB-a,b,…,dp-LSB
	DDRB = (0xff);//PB0~7为输出控制七段数码管的a~g,dp
	DDRC = (0x01);//PC0为输出控制数码管的共阴极管脚(如'-1’)
	PORTC = (0x00);//PC0输出低电平‘0’
	DDRD &= ~(1<<DDRD3);//PD2(int0)为输入（从tp223触摸开关）
	MCUCR |=((1<<ISC11)|(1<<ISC10));//int0 上升沿触发中断
	GICR |= (1<<INT1);//允许INT0中断
	sei(); //开启全局中断SREG(I)=1
    while (1) 
    {
		PORTB = seg7_hex[counter];
    }
}


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
{ unsigned char i=0,tp_r=0;//临时变量
	TCNT0 = 0;//利用TC0统计开关的次数
	TCCR0 = (1<<CS02)|(1<<CS01)|(1<<CS00);
	//对T0上升沿计数
	UCSRC = 0x80;//清空UCSRC
	UBRRH = 0;
	UBRRL = 12;//1MHz,4800bps,0.2%
	UCSRB = (1<<RXEN)|(1<<TXEN);
	//开启USART接收和发送
	UCSRC =(1<<URSEL)|(3<<UCSZ0);
	//异步,无校验,8位数据，1位停止位,...
	TWI_Init();
	LCD_Init();
	LCD_Write_String(0,0,"b:Trans");
	while (1)
	{ if(UCSRA & (1<<RXC))//有收到数据
		{ tp_r = UDR;//读数据
			i=3; //1字节最多3位10进制数
			while(tp_r>0)//转换成字符
			{ tmp[i]=tp_r%10+0x30;
				tp_r = tp_r/10;
				while(!(UCSRA & (1<<UDRE)));//等待
				UDR = tmp[i];//发送字符
				i--;
			}
			while(i>0)//不足的位不显示
			{ tmp[i--]=0x20; }
			LCD_Write_String(1,0,tmp);
		}
		_delay_ms(1);
	} //while结束
} //main结束

/*
 * 5.14.1.c
 *
 * Created: 2023/5/14 20:14:32
 * Author : Lenovo
 */ 

#include <avr/io.h>
#define F_CPU 1000000UL
#include <util/delay.h>
#include <util/twi.h> //TWI接口状态码定义等
#include "twi_lcd.h"
#include <avr/interrupt.h>
unsigned char hexStr[17]={'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F','-'};
unsigned char key_no[5]={16,16,16,16,0};//存放4位连续按下的编码,以’\0'结束
unsigned char getkey,keyno;//取按键阵列扫描输入，按下按键的编码
int main(void) { DDRD = (0xf0);//PD7~4为输出S_R0~3，PD3~0为输入S_C0~3
	PORTD = (0xff);//PD7~4输出高电平,PD3~0的内部上拉电阻启用
	TCCR0 = (1<<CS02)|(1<<CS00);//1024分频
	TCNT0 = 102;//从102开始计数，1MHz/1024/154约为150ms中断一次
	TIMSK |=(1<<TOIE0);//允许TOV0中断
	TWI_Init(); LCD_Init();
	sei();//全局中断开
	while (1) 
	{ LCD_Write_Char(0,1,hexStr[key_no[3]]);
		LCD_Write_NewChar(hexStr[key_no[2]]);
		LCD_Write_NewChar(hexStr[key_no[1]]);
		LCD_Write_NewChar(hexStr[key_no[0]]);
		_delay_ms(20); 
	}
}
		ISR(TIMER0_OVF_vect)//溢出中断TCNT0=255溢出到102
		{ TCNT0 = 102;//从102开始计数，1MHz/1024/154约为150ms中断一次
			keyno = 16;//默认无按键按下
			//1.扫描第1行
			PORTD = ~(1<<PORTD7);//PORTD7为0,其它为1，送给第1行
			_delay_us(2);
			getkey = (PIND & 0x0f);//取按键阵列的列状态
			switch(getkey) { case 0x07:keyno = 0;break;//1行1列编码为0/1 //S4
				case 0x0b:keyno = 1;break;//1行2列编码为1/2 //S8
				case 0x0d:keyno = 2;break;//1行3列编码为2/3 //S12
			case 0x0e:keyno = 3;break;//1行4列编码为3/A //S16
			 }
			//2.扫描第2行
			PORTD = ~(1<<PORTD6);//PORTD6为0,其它为1，送给第2行
			_delay_us(2);
			getkey = (PIND & 0x0f);//取按键阵列的列状态
			//3.扫描第3行
			//4.扫描第4行
			PORTD = ~(1<<PORTD4);//PORTD4为0，其它为1，送给第4行
			_delay_us(2); getkey = (PIND & 0x0f);//取按键阵列的列状态
			switch(getkey) { case 0x07:keyno =12;break;//4行1列编码为12/*
			case 0x0b:keyno =13;break;//4行2列编码为13/0
			case 0x0d:keyno =14;break;//4行3列编码为14/#
			case 0x0e:keyno =15;break;//4行4列编码为15/D
			 }
			/*一轮按键阵列处理结束*/
			if(keyno<16) { key_no[3]=key_no[2]; //移动按键数据
			key_no[2]=key_no[1];
			key_no[1]=key_no[0];
			key_no[0]=keyno; //新的按键数据 
			}
		} //ISR结束
			


/*
 * GccApplication1.c
 *
 * Created: 2023/4/9 14:13:30
 * Author : Lenovo
 */ 

#include <avr/io.h>
unsigned int counter=0;//全局变量
#define F_CPU 1000000UL
#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>
int main(void)
{
   unsigned char seg7_hex[17]={0xfc,0x60,0xda,0xf2,0x66,0xb6,0xbe,0xe0,0xfe,0xf6,0xee,0x3e,0x9c,0x7a,0x9e,0x8e,0x02};//4-7译码
   unsigned char i,seg7_com[4]={0xe,0xd,0x0b,0x07};//扫描码
   unsigned char seg7_no[4]={16,16,16,16};//要显示的4位数字
   unsigned char getkey,keyno;//取扫描输入，对按下按键的编码
   DDRC =(0x0f);//PC3~0输出到公共端-1，-2，-3，-4
   DDRB =(0xff);
   DDRD =(0x0f);
   PORTD =(0xff);
   while(1)
    {
		 /*按键阵列扫描，判断，编码*/
		 keyno = 16;//默认无按键按下
		 //1.扫描第1行
		 PORTD = ~(1<<PORTD0);//PORTD0为低电平，扫描第1行
		 _delay_us(1);
		 getkey = (PIND & 0xf0)>>4;//获取列状态,并移动到低4位
		 switch(getkey)
		 { 
			 case 0x0e:keyno = 1;break;//1行1列为S0
			 case 0x0d:keyno = 2;break;//1行2列为S1
			 case 0x0b:keyno = 3;break;//1行3列为S2
			 case 0x07:keyno = 10;break;//1行4列为S3
		 }
		 //2.扫描第2行
		 PORTD = ~(1<<PORTD1);//PORTD1为低电平，扫描第2行
		 _delay_us(7);
		 getkey = (PIND & 0xf0)>>4;//获取列状态,并移动到低4位
		 switch(getkey)
		 { case 0x0e:keyno = 4;break;
			 //2行1列为S4
			 case 0x0d:keyno = 5;break;
			 //2行2列为S5
			 case 0x0b:keyno = 6;break;
			 //2行3列为S6
			 case 0x07:keyno = 11;break;
			 //2行4列为S7
		 }
		 //3.扫描第3行
		 PORTD = ~(1<<PORTD2);//扫描第3行
		 _delay_us(14);
		 getkey = (PIND & 0xf0)>>4;//获取列状态
		 switch(getkey)
		 { case 0x0e:keyno = 7;break;//3行1列为S8
			 case 0x0d:keyno = 8;break;//3行2列为S9
			 case 0x0b:keyno = 9;break;//…为S10
			 case 0x07:keyno = 12;break;//…为S11
		 }
		 //4.扫描第4行
		 PORTD = ~(1<<PORTD3);//PORTD3为低电平，扫描第4行
		 _delay_us(21);
		 getkey = (PIND & 0xf0)>>4;//获取列状态,并移动到低4位
		 switch(getkey)
		 { case 0x0e:keyno =13;break;//4行1列为S12
			 case 0x0d:keyno =0;break;//4行2列为S13
			 case 0x0b:keyno =14;break;//4行3列为S14
			 case 0x07:keyno =15;break;//4行4列为S15
		 }
		 if(keyno<16) /*扫描一轮并编码后*/
		 { seg7_no[3]=seg7_no[2]; //移动按键数据
			 seg7_no[2]=seg7_no[1];
			 seg7_no[1]=seg7_no[0];
			 seg7_no[0]=keyno; //新的按键数据
		 }
		/*4位七段数码管动态扫描显示*/
		 for(i=0;i<4;i++)
		 {
			 PORTC |= 0x0f; //禁止显示
			 PORTB = seg7_hex[seg7_no[i]];
			 PORTC = seg7_com[i]; //显示
			 _delay_ms(28);
		 }
    }
}


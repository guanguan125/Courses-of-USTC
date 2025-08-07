/*
 * GccApplication2.c
 *
 * Created: 2023/4/19 16:41:21
 * Author : Lenovo
 */ 

#include <avr/io.h>
#include "twi_lcd.h"
#include "hc_sr04.h"



int main(void)
{
	unsigned int distance=0;
	unsigned char i=15,uc_d=0;
	TWI_Init(); LCD_Init();
	while (1)
	{ distance = HCSR04_Run();
		LCD_Write_String(0,0,"Distance:");
		i=15; //�����λ��ʼת������ʾ�����7λ
		while(distance>0)
		{ uc_d = distance % 10+0x30;
			LCD_Write_Char(0,i,uc_d);
		i--; distance /=10;}
		while(i>8) //��λû������ʱ����ʾ
		{ LCD_Write_Char(0,i,0x20);
            i--;
		 }
   _delay_ms(100);}
}



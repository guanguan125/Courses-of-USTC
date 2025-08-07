/*
 * text_mcu2.c
 *
 * Created: 2023/3/29 16:57:54
 * Author : Lenovo
 */ 

#include <avr/io.h>


int main(void)
{
	int i,j;//循环变量
    *(volatile unsigned char *)(0x20+0x14)=0x01;//DDCR[0]=1
    while (1) 
    {
		*(volatile unsigned char *)(0x20+0x15)=0x01;//PCRTC[0]=1
		for(i=0;i<100;i++) for(j=0;j<1000;j++);//延时等等
		*(volatile unsigned char *)(0x20+0x15)=0x00;//PCRTC[0]=0
		for(i=0;i<100;i++) for(j=0;j<1000;j++);//延时等等
    }
}


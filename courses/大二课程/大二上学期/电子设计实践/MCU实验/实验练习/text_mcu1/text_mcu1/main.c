/*
 * text_mcu1.c
 *
 * Created: 2023/3/29 16:37:09
 * Author : Lenovo
 */ 

#include <avr/io.h>


int main(void)
{
   *(volatile unsigned char *)(0x20+0x14)=0x01;//DDCR[0]=1
   *(volatile unsigned char *)(0x20+0x15)=0x01;//PCRTC[0]=1
   while(1)
   {
	
   }
}


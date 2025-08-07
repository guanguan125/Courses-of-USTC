/*
 * exp3.c
 *
 * Created: 2023/4/12 19:36:22
 * Author : Lenovo
 */ 

#include <avr/io.h>
#include <util/twi.h> //TWI接口状态码定义等
#include "twi_lcd.h"
int main(void)
{unsigned char counter=0;
	unsigned char sla_addr = 0x33<<1;//从机地址为0x33(最低位为开启广播)
	unsigned char chs[3];
	TWCR=0x0;//禁止TWI接口
	DDRC &=~((1<<DDRC5)|(1<<DDRC4));//PC5/4输入
	PORTC |=(1<<PORTC5)|(1<<PORTC4);//SCL/SDA内部上拉
	DDRC|=(1<<DDRC3);//PC3位输出
	TWAR = sla_addr;//设置从机地址
	TWI_Init();
	LCD_Init();
while (1)
{ TWCR = (1<<TWINT)|(1<<TWEA)|(1<<TWEN);//清标志，开TWI，自动应答
	while(!(TWCR & (1<<TWINT)));//等待接收sla+w
	if((TWSR & 0xf8)==TW_SR_SLA_ACK)//sla+W已收到，已发ACK
	{ TWCR = (1<<TWINT)|(1<<TWEA)|(1<<TWEN);//清除标志，开启ACK
		while(!(TWCR & (1<<TWINT)));//等待接收数据
		if((TWSR & 0xf8)==TW_SR_DATA_ACK)//数据已收到，已发ACK
		{ counter = TWDR; //收到的数据存储在counter里
			TWCR = (1<<TWINT)|(1<<TWEA)|(1<<TWEN);//
		}
		unsigned char d_t = counter;
		for(int i=0;i<4;i++)//1个整数转换为4位字符
		{
			chs[3-i]=d_t%10+0x30;
			d_t=d_t/10;
		}
		LCD_Write_String(0,3,"Touchpad Times:");
		LCD_Write_String(1,8,chs);
	}
	TWCR = (1<<TWINT);//清除TWINT标志，关闭TWI接口
	
} //while结束
} //main函数结束

/*
 * exp1.c
 *
 * Created: 2023/4/12 18:30:33
 * Author : asus
 */ 

#include <avr/io.h>
#include <util/twi.h> //TWI�ӿ�״̬�붨���
#include "twi_lcd.h"
int main(void)
{
	unsigned char counter=0;
	unsigned char sla_addr = 0x33<<1;//�ӻ���ַΪ0x33(���λΪ�����㲥)
	unsigned char chs[4];
	unsigned char d_t=0;
	unsigned int i=0;
	TWCR=0x0;//��ֹTWI�ӿ�
	DDRC &=~((1<<DDRC5)|(1<<DDRC4));//PC5/4����
	PORTC |=(1<<PORTC5)|(1<<PORTC4);//SCL/SDA�ڲ�����
	TWBR = 0x02;//fscl=50KHz
	TWSR = 0x00;//��Ԥ��Ƶ
	
	
	TWAR = sla_addr;//���ôӻ���ַ
	TWI_Init();
	LCD_Init();
	while (1)
	{ TWCR = (1<<TWINT)|(1<<TWEA)|(1<<TWEN);//���־����TWI���Զ�Ӧ��
		
		while(!(TWCR & (1<<TWINT)));//�ȴ�����sla+w
		
		if((TWSR & 0xf8)==TW_SR_SLA_ACK)//sla+W���յ����ѷ�ACK
		{ TWCR = (1<<TWINT)|(1<<TWEA)|(1<<TWEN);//�����־������ACK
			while(!(TWCR & (1<<TWINT)));//�ȴ���������
			if((TWSR & 0xf8)==TW_SR_DATA_ACK)//�������յ����ѷ�ACK
			{ counter = TWDR; //�յ������ݴ洢��counter��
				TWCR = (1<<TWINT)|(1<<TWEA)|(1<<TWEN);//
				
			}
		}
		TWCR = (1<<TWINT);//���TWINT��־���ر�TWI�ӿ�
		d_t = counter;
		for(i=0;i<4;i++)//1������ת��Ϊ4λ�ַ�
		{
			chs[3-i]=d_t%10+0x30;
			d_t=d_t/10;
		}
		LCD_Write_String(0,2,"Touchpad Times:");
		LCD_Write_String(1,8,chs); //��LCD����ʾ����(����4λ)
		
	} //while����
} //main��������


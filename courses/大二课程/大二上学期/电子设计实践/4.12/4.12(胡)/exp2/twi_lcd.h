/*
 * twi_lcd.h
 *
 * Created: 2023/4/12 18:47:30
 *  Author: asus
 */ 


#ifndef TWI_LCD_H_
#define TWI_LCD_H_
#ifndef F_CPU
#define F_CPU 1000000UL //��ʱ��
#endif
#include "twi_fun.h"
#include <util/delay.h>
//LCD1602 ���ƺ���ʾָ��
#define LCD_CLEARDISPLAY 0x01//����������ACΪDDRAM��ַ0
#define LCD_RETURNHOME 0x02//����ACΪDDRAM��ַ0������ԭ��
#define LCD_ENTRYMODESET 0x04//��I/D��Sλ�������ƶ��������ʾ��λ
#define LCD_DISPLAYCONTROL 0x08//��D/C/B������ʾ���أ���꿪��/��˸
#define LCD_CURSORSHIFT 0x10//��S/C��R/Lһ�����ù���ƶ�����ʾ��λ
#define LCD_FUNCTIONSET 0x20//��DL��N��Fһ������LCD����:8/4λ��
//��;1/2����ʾ;5*8/10�����ַ�
#define LCD_SETCGRAMADDR 0x40//����CGRAM��ַ����ַ������(AC��
#define LCD_SETDDRAMADDR 0x80//����DDRAM��ַ����ַ������(AC��
// LCD����ģʽ����λ(LCD_ENTRYMODESET=0x04)
#define LCD_ENTRYSHIFT 0x01//Sλ=1����ʾ��λ��=0����λ
#define LCD_ENTRYINC 0x02//I/Dλ=1����ʾ����(����)
//LCD��ʾ���ؿ���λ (LCD_DISPLAYCONTROL=0x08)
#define LCD_BLINKON 0x01//B=1����˸
#define LCD_CURSORON 0x02//C=1�����
#define LCD_DISPLAYON 0x04//D=1����ʾ��
//LCD������ʾ��λ����λ(LCD_CURSORSHIFT=0x10)
#define LCD_CURSOR2LEFT 0x00//S/C=0,R/L=0:���������
#define LCD_CURSOR2RIGHT 0x04//S/C=0,R/L=1:���������
#define LCD_DC2LEFT 0x08//S/C=1,R/L=0:��ʾ�����ƣ���������
#define LCD_DC2RIGHT 0x0C//S/C=1,R/L=1:��ʾ������,��������
//LCD��������λ(LCD_FUNCTIONSET=0x20)
#define LCD_4BITMODE 0x00 //DL=0:4λ(DB7-4)���ݣ���2�δ���
#define LCD_8BITMODE 0x10 //DL=1��8λ(DB7-0)���ݴ���
#define LCD_1LINE 0x00 //N=0��1����ʾ
#define LCD_2LINE 0x08 //N=1��2����ʾ
#define LCD_5X8DOTS 0x00 //F=0��5X8 dots�ַ�
#define LCD_5XADOTS 0x04 //F=1��5X10 dots�ַ���ֻ��1����ʾ
//LCD 1602 ���ƹܽţ�I2C���ݵĵ�4λ��PCF8574-P0~3)
#define LCD_RS 0x01 //PCF8574-P0����LCD1602��RS�ܽ�
#define LCD_RW 0x02 //PCF8574-P1������LCD1602��RW�ܽ�
#define LCD_E 0x04 //PCF8574-P2������LCD1602��E�ܽ�
#define LCD_BACKLIGHTON 0x08 //PCF8574-P3����LCD1602��K�ܽ�
#define LCD_SLAVE_ADDRESS 0x27 //�ӻ���ַPCF8574(A2-0:111)
unsigned char TWI_Write_LCD(unsigned char uc_data)
{ TWI_Start();//����START�ź�
	if(TWI_Get_State_Info()!=TW_START) return 0;//���ɹ�
	TWI_Write(LCD_SLAVE_ADDRESS<<1|TW_WRITE); //����SLA+W
	if(TWI_Get_State_Info()!=TW_MT_SLA_ACK)return 0;//���ɹ�
	TWI_Write(uc_data|LCD_BACKLIGHTON);//��������+���ⳣ��
	if(TWI_Get_State_Info()!=TW_MT_DATA_ACK)return 0;//���ɹ�
	TWI_Stop();
	return 1;//�ɹ�
}
void LCD_4Bit_Write(unsigned char uc_data)//4λ��ʽдPCF8574
{ TWI_Write_LCD(uc_data);//�����ͳ���E=0
	_delay_us(1);//����
	TWI_Write_LCD(uc_data|LCD_E);//�����ͳ���E=1
	_delay_us(1);//����
	TWI_Write_LCD(uc_data & (~LCD_E));//�����ͳ���E=0
	_delay_us(50);//�ȴ����ݴ������
}
void LCD_8Bit_Write(unsigned char uc_data,unsigned char uc_mode)
//2��4λ���ݴ��䷽ʽдPCF9574,uc_mode:0-����,1-����
{ unsigned char high4bit = uc_data & 0xf0;
	unsigned char low4bit = (uc_data<<4)&0xf0;
	LCD_4Bit_Write(high4bit|uc_mode);//�ȷ��͸�4λ
	LCD_4Bit_Write(low4bit|uc_mode);//�ٷ��͵�4λ
}
void LCD_Init()//��ʼ��LCD1602
{ _delay_ms(50);//�ϵ�������ٵ�40ms
	LCD_4Bit_Write(0x30); //��Ĭ��8λ�ӿڣ����Ž���4λ�ӿ�ģʽ
	_delay_us(4500);//�ȴ�����4.5ms
	LCD_4Bit_Write(0x30); _delay_us(4500);//�ȴ�����4.5ms
	LCD_4Bit_Write(0x30); _delay_us(150);//�ȴ�����150us
	LCD_4Bit_Write(0x20);//����4λ�ӿ�ģʽ
	//����ģʽ����ʾ��������
	LCD_8Bit_Write(LCD_FUNCTIONSET|LCD_4BITMODE|LCD_2LINE|LCD_5X8DOTS,
	0);
	LCD_8Bit_Write(LCD_DISPLAYCONTROL|LCD_DISPLAYON,0);//��ʾ
	LCD_8Bit_Write(LCD_CLEARDISPLAY,0); _delay_us(2000);//�ȴ�
	LCD_8Bit_Write(LCD_ENTRYMODESET|LCD_ENTRYINC,0);//��ʾ����(����)
	LCD_8Bit_Write(LCD_RETURNHOME,0);//����ԭ��
	_delay_us(2000);//�ȴ�
}
void LCD_Set_Cursor_Location(unsigned char row,unsigned char col)
//���ù��λ��,row:0~1,col:0~39
{ unsigned char offset[]={0x0,0x40}; LCD_8Bit_Write(LCD_SETDDRAMADDR|(col+offset[row]),0);
}
void LCD_Write_NewChar(char c_data)//�ڵ�ǰλ����ʾ
{ LCD_8Bit_Write(c_data,1);
}
void LCD_Write_Char(unsigned char row,unsigned char col,char c_data)
//��ָ��λ����ʾ
{ LCD_Set_Cursor_Location(row,col); LCD_8Bit_Write(c_data,1);
}
void LCD_Write_String(unsigned char row,unsigned char col,const char *pStr)
//��ָ��λ����ʾ��
{
	LCD_Set_Cursor_Location(row,col);
	while((*pStr) != '\0')
	{
		LCD_8Bit_Write(*pStr,1);
		pStr ++;
	}




#endif /* TWI_LCD_H_ */
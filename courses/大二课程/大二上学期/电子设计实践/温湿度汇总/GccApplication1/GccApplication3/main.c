/*
 * GccApplication3.c
 *
 * Created: 2023/4/19 16:48:14
 * Author : Lenovo
 */ 
#include <avr/io.h>
#include "twi_lcd.h"
void ADC_Init(unsigned char adc_ch)//ADC��ʼ������4bit,adc0~7:0~7
{ ADMUX = (1<<REFS0)|(adc_ch & 0x0f);//�ο���ѹ��AVCC����4bitΪͨ��ѡ��
	ADCSRA = (1<<ADEN)|(1<<ADFR)|(1<<ADPS1)|(1<<ADPS0);//����ADC������ģʽ,�Ҷ��룬
	//Ԥ��Ƶ8��1000/8=125kHz
ADCSRA |=(1<<ADSC);//ADC��ʼת��
}
int main(void)
{ unsigned char adc_dh,adc_dl;
	//���ڴ洢adch/l�Ĵ����������
	float adc_result;//adc�ɼ����
	unsigned char i,uc_int,uc_display[8];//��ʱ����
	LCD_Init();
	ADC_Init(3); //��ʼ��adc����ADC3��PC3���������ο���ѹ��
	while (1)
	{ while(!(ADCSRA & (1<<ADIF)));//�ȴ�ADCת������
		adc_dl = ADCL;//�ȶ���8λ
		adc_dh = ADCH;//�ٶ���8λ
		adc_result = adc_dh *256.0+adc_dl;//�ϲ�
		adc_result *=5.0/1024.0;//�����ѹ
		for(i=0;i<8;i++)//��ʼ����ʾ������������ʾ
		{ uc_display[i]=0x20; }
		LCD_Write_String(0,0,"ADC Result:");
		uc_int = (unsigned char) adc_result;//ȡ����
		adc_result -=uc_int;//ȡС��
		i=2;//����ռ2λ
		uc_display[3]=0x30;//��ʼ����Ϊ0
		while(uc_int > 0 && i >0)
		{ uc_display[i--]=uc_int%10+0x30;//���λ����ת�����ַ�
		uc_int/=10;/*ȥ�����������λ*/}
		uc_display[3]='.';//С����
		i=4; //С����Ԫ��4��ʼ�洢
		while(adc_result>0 && i<7)//��λС��
		{
			adc_result *=10;//��һλС������������
			uc_int = (unsigned char) adc_result;//ȡ����
			adc_result -=uc_int; //ʣ�µ�С������
			uc_display[i++]=uc_int+0x30; //��ǰ��С��Ϊת��Ϊ�ַ�����ʾ
		}
		uc_display[7]=0; //�ַ�����
		LCD_Write_String(1,8,uc_display); //��ʾ�ɼ�ת����ĵ�ѹ��ֵ
		_delay_us(300);
		}
	}



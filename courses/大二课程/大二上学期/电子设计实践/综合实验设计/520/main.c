/*
 * 520.c
 *
 * Created: 2023/5/20 7:39:01
 * Author : Lenovo
 */ 
#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>
#define F_CPU 1000000UL
#include "twi_lcd.h"
#include "hc_sr04.h"
#include "m_28byj48.h"
void ADC_Init(unsigned char adc_ch)//ADC��ʼ������4bit,adc0~7:0~7
{ ADMUX = (1<<REFS0)|(adc_ch & 0x0f);//�ο���ѹ��AVCC����4bitΪͨ��ѡ��
	ADCSRA = (1<<ADEN)|(1<<ADFR)|(1<<ADPS1)|(1<<ADPS0);//����ADC������ģʽ,�Ҷ��룬
	//Ԥ��Ƶ8��1000/8=125kHz
	ADCSRA |=(1<<ADSC);//ADC��ʼת��
}
int main(void)
{
	unsigned int distance=0;
	unsigned char i=15,uc_d=0,j=0;
	unsigned int n,m;
	unsigned int high,low,y;
	TWI_Init(); LCD_Init();
    DDRD |= (1<<DDRD2)|(1<<DDRD1)|(1<<DDRD0);
	DDRD &=~(1<<DDRD0);//���룺ͨ��PD0���ӵ���Դ�����򸺼���������תѡ��
	PORTD |=(1<<PORTD0); //�ڲ�����
	unsigned char adc_dh,adc_dl;
	//���ڴ洢adch/l�Ĵ����������
	float adc_result;//adc�ɼ����
	unsigned char dh,uc_int,uc_display[8];//��ʱ����
	LCD_Init();
	ADC_Init(6); //��ʼ��adc����ADC6��PC6���������ο���ѹ��
    while (1)
    { 
		PORTD = (1<<PORTD2);//only red on
	    _delay_ms(500);
	    for(n=0;n<100;n++)
	    for(m=0;m<1000;m++);
	    PORTD = (1<<PORTD1);//only green on
	    _delay_ms(500);
	    for(n=0;n<100;n++)
	    for(m=0;m<1000;m++);
	    PORTD = (1<<PORTD0);//only blue on
	    _delay_ms(500);
	    for(n=0;n<100;n++)
	    for(m=0;m<1000;m++);
		distance = HCSR04_Run();
		LCD_Write_String(0,0,"Distance:");
		i=15; //�����λ��ʼת������ʾ�����7λ
		while(distance>0)
		{ uc_d = distance % 10+0x30;
			LCD_Write_Char(0,i,uc_d);
			if(distance<10000)
			LCD_Write_String(1,4,"Close");
			else
			LCD_Write_String(1,0,"NOT");
		i--; distance /=10;}
		while(i>8) //��λû������ʱ����ʾ
		{ 
			LCD_Write_Char(0,i,0x20);i--;
		}
		_delay_ms(100);
		if(PIND & (1<<PIND0))
		run_stepper(0,1,4096);
		//8��������ʽ��˳ʱ�룬ת��һ��
		else
		run_stepper(0,0,4096);
		//8��������ʽ����ʱ�룬ת��һ��
		while(!(ADCSRA & (1<<ADIF)));//�ȴ�ADCת������
		adc_dl = ADCL;//�ȶ���8λ
		adc_dh = ADCH;//�ٶ���8λ
		adc_result = adc_dh *256.0+adc_dl;//�ϲ�
		adc_result *=5.0/1024.0;//�����ѹ
		for(dh=0;dh<8;dh++)//��ʼ����ʾ������������ʾ
		{ uc_display[dh]=0x20; }
		uc_int = (unsigned char) adc_result;//ȡ����
		adc_result -=uc_int;//ȡС��
		dh=2;//����ռ2λ
		uc_display[3]=0x30;//��ʼ����Ϊ0
		while(uc_int > 0 && dh >0)
		{ uc_display[dh--]=uc_int%10+0x30;//���λ����ת�����ַ�
		uc_int/=10;/*ȥ�����������λ*/}
		uc_display[3]='.';//С����
		dh=4; //С����Ԫ��4��ʼ�洢
		while(adc_result>0 && dh<7)//��λС��
		{
			adc_result *=10;//��һλС������������
			uc_int = (unsigned char) adc_result;//ȡ����
			adc_result -=uc_int; //ʣ�µ�С������
			uc_display[dh++]=uc_int+0x30; //��ǰ��С��Ϊת��Ϊ�ַ�����ʾ
		}
		uc_display[7]=0; //�ַ�����
		LCD_Write_String(1,9,uc_display); //��ʾ�ɼ�ת����ĵ�ѹ��ֵ
		_delay_us(300);
    }
}


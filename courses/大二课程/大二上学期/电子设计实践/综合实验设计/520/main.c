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
void ADC_Init(unsigned char adc_ch)//ADC初始化，低4bit,adc0~7:0~7
{ ADMUX = (1<<REFS0)|(adc_ch & 0x0f);//参考电压：AVCC，低4bit为通道选择
	ADCSRA = (1<<ADEN)|(1<<ADFR)|(1<<ADPS1)|(1<<ADPS0);//开启ADC，连续模式,右对齐，
	//预分频8，1000/8=125kHz
	ADCSRA |=(1<<ADSC);//ADC开始转换
}
int main(void)
{
	unsigned int distance=0;
	unsigned char i=15,uc_d=0,j=0;
	unsigned int n,m;
	unsigned int high,low,y;
	TWI_Init(); LCD_Init();
    DDRD |= (1<<DDRD2)|(1<<DDRD1)|(1<<DDRD0);
	DDRD &=~(1<<DDRD0);//输入：通过PD0连接到电源正极或负极进行正反转选择
	PORTD |=(1<<PORTD0); //内部上拉
	unsigned char adc_dh,adc_dl;
	//用于存储adch/l寄存器里的数据
	float adc_result;//adc采集结果
	unsigned char dh,uc_int,uc_display[8];//临时变量
	LCD_Init();
	ADC_Init(6); //初始化adc，对ADC6（PC6）采样，参考电压…
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
		i=15; //从最低位开始转换和显示，最多7位
		while(distance>0)
		{ uc_d = distance % 10+0x30;
			LCD_Write_Char(0,i,uc_d);
			if(distance<10000)
			LCD_Write_String(1,4,"Close");
			else
			LCD_Write_String(1,0,"NOT");
		i--; distance /=10;}
		while(i>8) //高位没有数字时不显示
		{ 
			LCD_Write_Char(0,i,0x20);i--;
		}
		_delay_ms(100);
		if(PIND & (1<<PIND0))
		run_stepper(0,1,4096);
		//8拍驱动方式，顺时针，转动一周
		else
		run_stepper(0,0,4096);
		//8拍驱动方式，逆时针，转动一周
		while(!(ADCSRA & (1<<ADIF)));//等待ADC转换结束
		adc_dl = ADCL;//先读低8位
		adc_dh = ADCH;//再读高8位
		adc_result = adc_dh *256.0+adc_dl;//合并
		adc_result *=5.0/1024.0;//计算电压
		for(dh=0;dh<8;dh++)//初始化显示变量，都不显示
		{ uc_display[dh]=0x20; }
		uc_int = (unsigned char) adc_result;//取整数
		adc_result -=uc_int;//取小数
		dh=2;//整数占2位
		uc_display[3]=0x30;//初始整数为0
		while(uc_int > 0 && dh >0)
		{ uc_display[dh--]=uc_int%10+0x30;//最低位数字转换成字符
		uc_int/=10;/*去掉整数的最低位*/}
		uc_display[3]='.';//小数点
		dh=4; //小数从元素4开始存储
		while(adc_result>0 && dh<7)//三位小数
		{
			adc_result *=10;//第一位小数调整到整数
			uc_int = (unsigned char) adc_result;//取整数
			adc_result -=uc_int; //剩下的小数部分
			uc_display[dh++]=uc_int+0x30; //当前的小数为转换为字符以显示
		}
		uc_display[7]=0; //字符结束
		LCD_Write_String(1,9,uc_display); //显示采集转换后的电压数值
		_delay_us(300);
    }
}


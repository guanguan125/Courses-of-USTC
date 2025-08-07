/*
 * GccApplication3.c
 *
 * Created: 2023/4/19 16:48:14
 * Author : Lenovo
 */ 
#include <avr/io.h>
#include "twi_lcd.h"
void ADC_Init(unsigned char adc_ch)//ADC初始化，低4bit,adc0~7:0~7
{ ADMUX = (1<<REFS0)|(adc_ch & 0x0f);//参考电压：AVCC，低4bit为通道选择
	ADCSRA = (1<<ADEN)|(1<<ADFR)|(1<<ADPS1)|(1<<ADPS0);//开启ADC，连续模式,右对齐，
	//预分频8，1000/8=125kHz
ADCSRA |=(1<<ADSC);//ADC开始转换
}
int main(void)
{ unsigned char adc_dh,adc_dl;
	//用于存储adch/l寄存器里的数据
	float adc_result;//adc采集结果
	unsigned char i,uc_int,uc_display[8];//临时变量
	LCD_Init();
	ADC_Init(3); //初始化adc，对ADC3（PC3）采样，参考电压…
	while (1)
	{ while(!(ADCSRA & (1<<ADIF)));//等待ADC转换结束
		adc_dl = ADCL;//先读低8位
		adc_dh = ADCH;//再读高8位
		adc_result = adc_dh *256.0+adc_dl;//合并
		adc_result *=5.0/1024.0;//计算电压
		for(i=0;i<8;i++)//初始化显示变量，都不显示
		{ uc_display[i]=0x20; }
		LCD_Write_String(0,0,"ADC Result:");
		uc_int = (unsigned char) adc_result;//取整数
		adc_result -=uc_int;//取小数
		i=2;//整数占2位
		uc_display[3]=0x30;//初始整数为0
		while(uc_int > 0 && i >0)
		{ uc_display[i--]=uc_int%10+0x30;//最低位数字转换成字符
		uc_int/=10;/*去掉整数的最低位*/}
		uc_display[3]='.';//小数点
		i=4; //小数从元素4开始存储
		while(adc_result>0 && i<7)//三位小数
		{
			adc_result *=10;//第一位小数调整到整数
			uc_int = (unsigned char) adc_result;//取整数
			adc_result -=uc_int; //剩下的小数部分
			uc_display[i++]=uc_int+0x30; //当前的小数为转换为字符以显示
		}
		uc_display[7]=0; //字符结束
		LCD_Write_String(1,8,uc_display); //显示采集转换后的电压数值
		_delay_us(300);
		}
	}



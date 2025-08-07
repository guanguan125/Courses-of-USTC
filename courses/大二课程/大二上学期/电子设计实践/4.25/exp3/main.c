/*
 * exp3.c
 *
 * Created: 2023/4/23 19:39:04
 * Author : Lenovo
 */ 
#include <avr/io.h>
#include <avr/interrupt.h>
unsigned char ui_cnt=0;//ͳ���жϴ�����ȷ��OCR1A/B��ֵ
ISR(TIMER1_OVF_vect)
{ ui_cnt++;//ͳ��TC1����жϴ���
	if(ui_cnt>249)ui_cnt=0;//ͳ�Ƶ�250��ʱ����
	if(ui_cnt<125)//ǰ���
	{ OCR1A = 0;//�ߵ�ƽ�ĳ���ʱ�䳤
		OCR1B +=4;//�ߵ�ƽ�ĳ���ʱ�佥��
	}
	else//����
	{ OCR1A =500;//�͵�ƽ�ĳ���ʱ�䳤
		OCR1B -=4;//�ߵ�ƽ�ĳ���ʱ�佥��
	}
}
int main(void)
{
	DDRB |=(1<<DDRB1)|(1<<DDRB2);//PB1(OC1A),PB2(OC1B)Ϊ���
	ICR1 = 500;//����TOPֵ
	OCR1A = 1;//����A·�Ƚ�ֵ
	OCR1B = 1;//����B·�Ƚ�ֵ
	TCCR1A |= (1<<COM1A1)|(1<<COM1A0)|(1<<COM1B1)|(1<<COM1B0);//���á�����Ƚϡ��ܽ��л���ʽ��
	TCCR1B |= (1<<WGM13)|(1<<CS11);//����PWMģʽΪ8��ʱ��8��Ƶ
	TIMSK = (1<<TOIE1);//����TC1����ж�
	sei();//����ȫ���ж�
	while (1)
	{
	}
}


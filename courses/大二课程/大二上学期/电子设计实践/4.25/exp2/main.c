/*
 * exp2.c
 *
 * Created: 2023/4/23 19:37:08
 * Author : Lenovo
 */ 
#include <avr/io.h>
int main(void)
{
	DDRB |=(1<<DDRB1);//PB1(OC1A)Ϊ���
	ICR1 =2048;//����TOPֵ
	OCR1A = 1024;//����A·�Ƚ�ֵ
	TCCR1A |= (1<<COM1A1);//��������ȽϹܽ��л���ʽ��
	TCCR1B |= (1<<WGM13)|(1<<CS12);//����PWMģʽΪ8��ʱ��256��Ƶ
	while (1)
	{
	}
}


/*
 * exp5.c
 *
 * Created: 2023/4/23 19:46:55
 * Author : Lenovo
 */ 
#include <avr/io.h>
#include "m_28byj48.h"
int main(void)
{ DDRD &=~(1<<DDRD0);//���룺ͨ��PD0���ӵ���Դ�����򸺼�����
	����תѡ��
	PORTD |=(1<<PORTD0); //�ڲ�����
	while (1)
	{ if(PIND & (1<<PIND0))
		run_stepper(0,1,4096);
		//8��������ʽ��˳ʱ�룬ת��һ��
		else
		run_stepper(0,0,4096);
		//8��������ʽ����ʱ�룬ת��һ��
	}
}


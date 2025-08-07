/*
 * m_28byj48.h
 *
 * Created: 2023/4/23 19:47:47
 *  Author: Lenovo
 */ 


#ifndef M_28BYJ48_H_
#define M_28BYJ48_H_
#ifndef F_CPU
#define F_CPU 1000000UL/*<util/delay.h>��Ҫ����F_CPU����*/
#endif
#include <util/delay.h> //������ʱ����_delay_ms()��_delay_us()��
#include <avr/io.h>
/* 3�ֲ�ͬ������ʽ��28byj48��������Ŀ����źţ���������
* ��4λ��bit3����28byj48����ɫ��(D),bit2-��(C),bit1-��(B),bit0-��(A)*/
const unsigned char
stepper_ph[3][8]={{0x01,0x03,0x02,0x06,0x04,0x0c,0x08,0x09},//���8��
{0x03,0x06,0x0C,0x09},//˫4��
{0x01,0x02,0x04,0x08}};//��4��
unsigned char stepper_index = 0;//��¼�����Ʋ�������Ĳ���
/* 28BYJ-48��������Ŀ��ƺ����������������Ϊ��
* phase:ѡ�񲽽������������ʽ��0��8�ģ�1��˫4�ģ�2����4��
* dir:���������ת������0��˳ʱ�룬1����ʱ��
* step:���Ʋ������ת�����ٲ������ٸ����壩��0~65535*/
void run_stepper(unsigned char phase,unsigned char dir,unsigned int step)
{ unsigned char ph = phase ? 0x03:0x07;//������ʽ��ȷ�������ѡ������
	unsigned char inc = dir ?0x01:ph; /*��ʱ������Ϊ1��˳ʱ�� 4��Ϊ3,8��Ϊ7*/
	unsigned int i;//����ѭ������i
	DDRC |=(1<<DDRC3)|(1<<DDRC2)|(1<<DDRC1)|(1<<DDRC0);//PC���
	for(i=0;i<step;i++)//���step�����岽
	{ stepper_index += inc;//ͨ���������������ϵ��л��������
		stepper_index &= ph; //ȥ�����������Ч��λֵ
		PORTC &=0xf0; //ѡ����Ӧ�Ŀ�������ͨ���˿�C�������
		PORTC |= stepper_ph[phase][stepper_index];
		_delay_us(900);//8�� _delay_us(1600);//˫4��//_delay_us(2000);//������
	} }
	#endif /* M_28BYJ48_H_ */
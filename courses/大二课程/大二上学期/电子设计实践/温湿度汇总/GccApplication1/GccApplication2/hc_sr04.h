/*
 * hc_sr04.h
 *
 * Created: 2023/4/19 16:43:00
 *  Author: Lenovo
 */ 
#ifndef HC_SR04_H_
#define HC_SR04_H_
#ifndef F_CPU
#define F_CPU 1000000UL
#endif
#include <avr/io.h>
#include <util/delay.h>
unsigned int HCSR04_Run(void)
{ unsigned int i_cnt=0;//ͳ��echo�ĸߵ�ƽ(�̶�ʱ���µĴ���)
	unsigned int uc_cnt=1;//��ʱ������ͳ����һ��ʱ����û����Ӧ��
	/*Ϊ�˲�����׼ȷ����ϵͳ��ʹ�����жϣ�����Ҫ��ֹ�ж� cli(); */
	DDRD |= (1<<DDRD6);//PD6Ϊ�������HC_SR04��Trig�ܽţ�
	DDRD &= ~(1<<DDRD5);//PD5Ϊ���루����HC_SR04��Echo�ܽţ�
	PORTD |=(1<<PORTD6);//PD6����ߵ�ƽ��Trig����HC_SR04׼�����ͳ�����
	_delay_us(20);//����20us(>10us)
	PORTD &=~(1<<PORTD6);//PD6����͵�ƽ��Trig����֪ͨ
	while((PIND&(1<<PIND5))==0) //�ȴ�EchoΪ�ߵ�ƽ(���յ������ز�)
	{ uc_cnt++; if(uc_cnt>9000)break;//�����������ʱ������
	}
	i_cnt = 2;//ͳ��Echo�ĳ�ֵ=��⵽echo�ź�+ѭ�����ж�Լ2��CPUʱ������
	while((PIND&(1<<PIND5))!=0)//����ͳ��ECHO�źŸߵ�ƽ�ĳ���ʱ��
	i_cnt++;//ÿ��=���ݼ���+&����+�ж�+ѭ��+��Լ5��ʱ�����ڣ�Ĭ��1MHz��
	/*��֮ǰ�������жϣ�������Կ��ж��� sei();*/
	return(i_cnt*5.0/100.0*17.0);//���ؾ��룬��λmm
}
#endif /* HC_SR04_H_ */


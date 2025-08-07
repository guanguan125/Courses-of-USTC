
/*
* dht11.h
* DHT11��ʪ�ȴ��������ݵĶ�ȡ��ʹ��ATMEGA8A PD7
* Created: 2023/4
*/
#ifndef DHT11_H_
#define DHT11_H_
#ifndef F_CPU
#define F_CPU 1000000UL
#endif
#include <avr/io.h>
#include <util/delay.h>
unsigned char byteReadDHT11(void) //��DHT11��ȡһ���ֽڵ�����
{ unsigned char oneBit,oneByte=0;//ÿ�ν���1λ��������8λ���ղ�����
	unsigned char i,uc_cnt;//ѭ����������ʱ������������ͳ�ƣ�
	for(i=0;i<8;i++)//����8λ���ݣ��Ƚ��յ������λ
	{//1bit��50us�ĵ͵�ƽ��ʼ�����26~28us�ĸߵ�ƽΪ0��70us�ĸߵ�ƽΪ1
		uc_cnt = 1;//��ʱ������ֵ��ͳ��50us�͵�ƽ
		while((PIND & (1<<PIND7))==0)//��50us�ĵ͵�ƽ
		{ uc_cnt++;//��ʱ����
		if(uc_cnt==0)break;/*�����������ʱ������*/}
		_delay_us(30);//����30us�ĸߵ�ƽ���绹�Ǹߵ�ƽ�յ���1���������յ���0��
		oneBit = 0;//�ٶ��յ���0��
		if((PIND & (1<<PIND7))!=0)oneBit = 1;//���Ǹߵ�ƽ���յ���1��
		uc_cnt = 1;//��ʱ������ֵ��ͳ��70us�ߵ�ƽ
		while((PIND & (1<<PIND7))!=0)//��70us�ĸߵ�ƽ
		{ uc_cnt++; /*��ʱ����*/if(uc_cnt==0)break;/*�������:��ʱ������*/}
		oneByte <<=1;//�յ�1λ��֮ǰ�յ���Ϊ��λ��������һλ
	oneByte |=oneBit;/*���յ��ĺϲ����ֽ���*/}
	return oneByte; /*�����յ���1�ֽ�*/
}
void DHT11_Run(unsigned char * uc_data) //��DHT11ͨ�ŵ����ú����ݴ����
{ unsigned char uc_cnt;//��ʱ������������ͳ�ƣ�
	DDRD |=(1<<DDRD7);//PD7Ϊ���ģʽ
	PORTD &=~(1<<PORTD7);/*PD7���0*/_delay_ms(20);//����18ms��START�ź�
	PORTD |=(1<<PORTD7); /*PD7���1:20~40us*/_delay_us(20);//20us�ߵ�ƽ
	DDRD &=~(1<<DDRD7); /*PD7Ϊ����ģʽ*/_delay_us(20);//�ȴ�DHT11��Ӧ
	if((PIND &(1<<PIND7))!=0)return;//DHT11û����Ӧ
	uc_cnt = 1;//��ʱ������ֵ��ͳ��80us�͵�ƽ��Ӧ
	while((PIND & (1<<PIND7))==0)//��80us�ĵ͵�ƽ
	{ uc_cnt++;//��ʱ����
	if(uc_cnt==0)break;/*�����������ʱ������*/}
	uc_cnt = 1;//��ʱ������ֵ��ͳ��80us�ߵ�ƽ��Ӧ
	while((PIND & (1<<PIND7))!=0)//��80us�ĸߵ�ƽ
	{ uc_cnt++; /*��ʱ����*/ if(uc_cnt==0)break; /*�����������ʱ������*/
	}
	for(uc_cnt=0;uc_cnt<5;uc_cnt++) //����DHT11���͵�40λ��ʪ������
	{ uc_data[uc_cnt]=byteReadDHT11();//0-ʪ����/С��,�¶���/С��,У��-4
	}
}
#endif /* DHT11_H_ */

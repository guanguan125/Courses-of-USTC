/*
 * exp2.c
 *
 * Created: 2023/4/12 18:32:33
 * Author : asus
 */ 
#define F_CPU 1000000UL
#include <util/delay.h>

#include <avr/io.h>


#include <util/twi.h> //TWI�ӿ�״̬�붨���
#include <avr/interrupt.h>
unsigned char counter=0;
unsigned char n=0;
ISR(INT0_vect)
{
	
	if(counter <15)
	counter++;
	else
	counter = 0;
}
int main(void)
{ unsigned char sla_w = 0x33<<1; //��MCU��ַΪ0x33(λ0Ϊ�����㲥)��д��MCU
	DDRC &= ~((1<<DDRC5)|(1<<DDRC4));//PC5/4Ϊ����
	PORTC |= (1<<PORTC5)|(1<<PORTC4);//�����ڲ�����
	TWBR = 0x02;//fscl=50KHz
	TWSR = 0x00;//��Ԥ��Ƶ
	DDRD &= ~(1<<DDRD2);//PD2(int0) �Ӵ������ص�sig�ܽ�
	MCUCR |=((1<<ISC01)|(1<<ISC00));//int0�ܽ��������ش����ж�INT0
	GICR |= (1<<INT0);//����INT0�ⲿ�ж�
	sei(); //����ȫ���ж�SREG(I)=1
	while (1)
	{ TWCR = (1<<TWINT)|(1<<TWSTA)|(1<<TWEN);//���־����TWI����START
		while(!(TWCR & (1<<TWINT)));//�ȴ�START����
		if((TWSR & 0xf8) == TW_START)//START�ѷ���
		{ TWDR=sla_w;//����SLA+W
			TWCR=(1<<TWINT)|(1<<TWEN);//�����־��������sla+w
			while(!(TWCR & (1<<TWINT)));//�ȴ�sla+w����
			if((TWSR & 0xf8)==TW_MT_SLA_ACK)//sla+W�ѷ���
				{ 
					
					TWDR=counter;//���Ϳ��ش���
					
					TWCR=(1<<TWINT)|(1<<TWEN);//�����־������������
					while(!(TWCR & (1<<TWINT)));//�ȴ����ݷ���
					if((TWSR & 0xf8)==TW_MT_DATA_ACK)//�����ѷ���
					TWCR=(1<<TWINT)|(1<<TWEN)|(1<<TWSTO);//���־����STOP
					
				}
				
			
		}
			TWCR=(1<<TWINT);//�����־λ����ֹTWI
			_delay_ms(500);
		} //while����
	} //main��������
		



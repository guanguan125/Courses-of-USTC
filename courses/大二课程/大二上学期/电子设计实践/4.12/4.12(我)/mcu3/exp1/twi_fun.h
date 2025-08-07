/*
 * twi_fun.h
 *
 * Created: 2023/4/12 18:32:11
 *  Author: Lenovo
 */ 


#ifndef TWI_FUN_H_
#define TWI_FUN_H_
#include <util/twi.h>//����Դ�TWI�ӿڵļĴ�����ͷ�ļ�
void TWI_Init(void)//twi �ӿڵĳ�ʼ��
{//����SCL��Ƶ�ʣ�1MHz cpu-50KHz scl,2M-100K,8M-400K
	TWSR = 0x00; //���2λΪԤ��Ƶ����(00-1,01-4,10-16,11-64)
	TWBR = 0x02; //λ�����ã�fscl=cpuƵ��/(16+2*TWBR*Ԥ��Ƶֵ)
}
TWCR = (1<<TWEN); //����TWI
void TWI_Start(void)//����Start�źţ���ʼ����TWIͨ��
{ TWCR = (1<<TWINT)|(1<<TWSTA)|(1<<TWEN);//����Start�ź�
	while(!(TWCR &(1<<TWINT)));//�ȴ�Start�źŷ���
}
void TWI_Stop(void)//����Stop�źţ���������TWIͨ��
{ TWCR = (1<<TWINT)|(1<<TWSTO)|(1<<TWEN);//����Stop�ź�
}
void TWI_Write(unsigned char uc_data) //��TWI�ӿڷ���8λ����
{
	TWDR = uc_data;//8λ���ݴ����TWDR
	TWCR = (1<<TWINT)|(1<<TWEN);//����TWDR�е�����
	while(!(TWCR &(1<<TWINT)));//�ȴ����ݷ���
}
unsigned char TWI_Read_With_ACK(void)
{
	TWCR = (1<<TWINT)|(1<<TWEA)|(1<<TWEN);//׼���������ݣ���ACK
	while(!(TWCR &(1<<TWINT)));//�ȴ���������
	return TWDR;//���ؽ��յ�������
}
unsigned char TWI_Read_With_NACK(void)
{
	TWCR = (1<<TWINT)|(1<<TWEN);//׼���������ݣ���NACK
	while(!(TWCR &(1<<TWINT)));//�ȴ���������
	return TWDR;//���ؽ��յ�������
}unsigned char TWI_Get_State_Info(void)
{
	unsigned char uc_status;
	uc_status = TWSR & 0xf8;
	return uc_status;
} 
#endif /* TWI_FUN_H_ */
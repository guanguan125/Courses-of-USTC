/*
 * DS1302.h
 *
 * Created: 2023/5/14 21:01:48
 *  Author: Lenovo
 */ 


#ifndef DS1302_H_
#define DS1302_H_
/*DS1302��ATmega8a�Ľӿ� PC2~SCLK,PC1~I/O,PC0~/RST */
//DS1302��ַ����
//��ʼʱ�䶨��
unsigned char time_buf[8] = {0x20,0x23,0x04,0x25,0x08,0x08,0x08,0x02};//
unsigned char dis_time_buf[16]={0};//���Ҫ��ʾ��ʱ����������
//DS1302��ʼ������
void ds1302_init(void)/*DS1302��MCU�ӿ� PC2~SCLK,PC1~I/O,PC0~/RST */
{
	DDRC|=(1<<DDRC2)|(1<<DDRC1)|(1<<DDRC0);//PC2,1,0Ϊ���
	//DDRC &=~(1<<DDRC1);//PC1(I/O:DATA)��Ϊ����
	PORTC &= ~(1<<PORTC0);//RST���õ�
	PORTC &= ~(1<<PORTC2);//SCK���õ�
}
void ds1302_write_byte(unsigned char addr, unsigned char d) //��DS1302д��һ�ֽ�����
{ unsigned char i;
	PORTC |=(1<<PORTC0);//RST=1,����DS1302����
	//д��Ŀ���ַ��addr
	addr = addr & 0xFE; //���λ���㣬�Ĵ���0λΪ0ʱд��Ϊ1ʱ��
	for (i = 0; i < 8; i ++) {//1Byte=8bit����λ0��ʼ����
		if (addr & 0x01) PORTC |=(1<<PORTC1);//PC1(IO)���1
		else PORTC &=~(1<<PORTC1);//PC1(IO)���0
		_delay_us (1);
		PORTC |=(1<<PORTC2);////����ʱ�ӣ�PC2(SCLK)���1
		_delay_us (2);
		PORTC &=~(1<<PORTC2);//PC2(SCLK)���0
		_delay_us (2);
		addr = addr >> 1;
	} //end for loop
	//д�����ݣ�d
	for (i = 0; i < 8; i ++) {//1Byte=8bit����λ0��ʼ����
		if (d & 0x01) { PORTC |=(1<<PORTC1);//PC1(IO)���1
		}
		else { PORTC &=~(1<<PORTC1);//PC1(IO)���0
		}
		_delay_us (1);
		PORTC |=(1<<PORTC2);////����ʱ�ӣ�PC2(SCLK)���1
		_delay_us (2);
		PORTC &=~(1<<PORTC2);//PC2(SCLK)���0
		_delay_us (2);
		d = d >> 1;
	} //end for loop 2
	PORTC &=~(1<<PORTC0);//RST=0,ֹͣDS1302����
} //end for ds1302_write_byte function
//��DS1302����һ�ֽ�����
unsigned char ds1302_read_byte(unsigned char addr) {
	unsigned char i,temp=0;
	PORTC |=(1<<PORTC0);//RST=1,����DS1302����
	//д��Ŀ���ַ��addr
	addr = addr | 0x01; //���λ��1���Ĵ���0λΪ0ʱд��Ϊ1ʱ��
	for (i = 0; i < 8; i ++) {//1Byte=8bit����λ0��ʼ����
		if (addr & 0x01) {PORTC |=(1<<PORTC1);//PC1(IO)���1
		 }
		else { PORTC &=~(1<<PORTC1);//PC1(IO)���0 
		}
		_delay_us (1);
		PORTC |=(1<<PORTC2);////����ʱ�ӣ�PC2(SCLK)���1
		_delay_us (2);
		PORTC &=~(1<<PORTC2);//PC2(SCLK)���0
		_delay_us (2);
		addr = addr >> 1;
	} //end for loop 1
	//��ȡ���ݵ�temp
	DDRC &=~(1<<DDRC1);//PC1(IO),Ϊ����
	for (i = 0; i < 8; i ++) {//��0λ��ʼ����
		temp = temp >> 1;//ÿ����1λ�������λ
		if (PINC & (1<<PINC1)) {//PC1�ܽ�Ϊ1��0
		temp |= 0x80;//�յ�1 
		}
		else { temp &= 0x7F;//�յ�0 
		}
		_delay_us (1);
		PORTC |=(1<<PORTC2);////����ʱ�ӣ�PC2(SCLK)���1
		_delay_us (2);
		PORTC &=~(1<<PORTC2);//PC2(SCLK)���0
	_delay_us (2); }
	DDRC |=(1<<DDRC1);//�ָ�PC1(IO),Ϊ���
	PORTC &=~(1<<PORTC0);//RST=0,ֹͣDS1302����
	return temp;
}
#endif /* DS1302_H_ */
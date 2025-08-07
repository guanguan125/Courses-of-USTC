/*
 * DS1302.h
 *
 * Created: 2023/5/14 21:01:48
 *  Author: Lenovo
 */ 


#ifndef DS1302_H_
#define DS1302_H_
/*DS1302与ATmega8a的接口 PC2~SCLK,PC1~I/O,PC0~/RST */
//DS1302地址定义
//初始时间定义
unsigned char time_buf[8] = {0x20,0x23,0x04,0x25,0x08,0x08,0x08,0x02};//
unsigned char dis_time_buf[16]={0};//存放要显示的时间日期数据
//DS1302初始化函数
void ds1302_init(void)/*DS1302与MCU接口 PC2~SCLK,PC1~I/O,PC0~/RST */
{
	DDRC|=(1<<DDRC2)|(1<<DDRC1)|(1<<DDRC0);//PC2,1,0为输出
	//DDRC &=~(1<<DDRC1);//PC1(I/O:DATA)暂为输入
	PORTC &= ~(1<<PORTC0);//RST脚置低
	PORTC &= ~(1<<PORTC2);//SCK脚置低
}
void ds1302_write_byte(unsigned char addr, unsigned char d) //向DS1302写入一字节数据
{ unsigned char i;
	PORTC |=(1<<PORTC0);//RST=1,启动DS1302总线
	//写入目标地址：addr
	addr = addr & 0xFE; //最低位置零，寄存器0位为0时写，为1时读
	for (i = 0; i < 8; i ++) {//1Byte=8bit，从位0开始发送
		if (addr & 0x01) PORTC |=(1<<PORTC1);//PC1(IO)输出1
		else PORTC &=~(1<<PORTC1);//PC1(IO)输出0
		_delay_us (1);
		PORTC |=(1<<PORTC2);////产生时钟：PC2(SCLK)输出1
		_delay_us (2);
		PORTC &=~(1<<PORTC2);//PC2(SCLK)输出0
		_delay_us (2);
		addr = addr >> 1;
	} //end for loop
	//写入数据：d
	for (i = 0; i < 8; i ++) {//1Byte=8bit，从位0开始发送
		if (d & 0x01) { PORTC |=(1<<PORTC1);//PC1(IO)输出1
		}
		else { PORTC &=~(1<<PORTC1);//PC1(IO)输出0
		}
		_delay_us (1);
		PORTC |=(1<<PORTC2);////产生时钟：PC2(SCLK)输出1
		_delay_us (2);
		PORTC &=~(1<<PORTC2);//PC2(SCLK)输出0
		_delay_us (2);
		d = d >> 1;
	} //end for loop 2
	PORTC &=~(1<<PORTC0);//RST=0,停止DS1302总线
} //end for ds1302_write_byte function
//从DS1302读出一字节数据
unsigned char ds1302_read_byte(unsigned char addr) {
	unsigned char i,temp=0;
	PORTC |=(1<<PORTC0);//RST=1,启动DS1302总线
	//写入目标地址：addr
	addr = addr | 0x01; //最低位置1，寄存器0位为0时写，为1时读
	for (i = 0; i < 8; i ++) {//1Byte=8bit，从位0开始发送
		if (addr & 0x01) {PORTC |=(1<<PORTC1);//PC1(IO)输出1
		 }
		else { PORTC &=~(1<<PORTC1);//PC1(IO)输出0 
		}
		_delay_us (1);
		PORTC |=(1<<PORTC2);////产生时钟：PC2(SCLK)输出1
		_delay_us (2);
		PORTC &=~(1<<PORTC2);//PC2(SCLK)输出0
		_delay_us (2);
		addr = addr >> 1;
	} //end for loop 1
	//读取数据到temp
	DDRC &=~(1<<DDRC1);//PC1(IO),为输入
	for (i = 0; i < 8; i ++) {//从0位开始接收
		temp = temp >> 1;//每接收1位放在最高位
		if (PINC & (1<<PINC1)) {//PC1管脚为1或0
		temp |= 0x80;//收到1 
		}
		else { temp &= 0x7F;//收到0 
		}
		_delay_us (1);
		PORTC |=(1<<PORTC2);////产生时钟：PC2(SCLK)输出1
		_delay_us (2);
		PORTC &=~(1<<PORTC2);//PC2(SCLK)输出0
	_delay_us (2); }
	DDRC |=(1<<DDRC1);//恢复PC1(IO),为输出
	PORTC &=~(1<<PORTC0);//RST=0,停止DS1302总线
	return temp;
}
#endif /* DS1302_H_ */
/*
 * GccApplication1.c
 *
 * Created: 2023/4/9 14:13:30
 * Author : Lenovo
 */ 

#include <avr/io.h>
unsigned int counter=0;//ȫ�ֱ���
#define F_CPU 1000000UL
#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>
int main(void)
{
   unsigned char seg7_hex[17]={0xfc,0x60,0xda,0xf2,0x66,0xb6,0xbe,0xe0,0xfe,0xf6,0xee,0x3e,0x9c,0x7a,0x9e,0x8e,0x02};//4-7����
   unsigned char i,seg7_com[4]={0xe,0xd,0x0b,0x07};//ɨ����
   unsigned char seg7_no[4]={16,16,16,16};//Ҫ��ʾ��4λ����
   unsigned char getkey,keyno;//ȡɨ�����룬�԰��°����ı���
   DDRC =(0x0f);//PC3~0�����������-1��-2��-3��-4
   DDRB =(0xff);
   DDRD =(0x0f);
   PORTD =(0xff);
   while(1)
    {
		 /*��������ɨ�裬�жϣ�����*/
		 keyno = 16;//Ĭ���ް�������
		 //1.ɨ���1��
		 PORTD = ~(1<<PORTD0);//PORTD0Ϊ�͵�ƽ��ɨ���1��
		 _delay_us(1);
		 getkey = (PIND & 0xf0)>>4;//��ȡ��״̬,���ƶ�����4λ
		 switch(getkey)
		 { 
			 case 0x0e:keyno = 1;break;//1��1��ΪS0
			 case 0x0d:keyno = 2;break;//1��2��ΪS1
			 case 0x0b:keyno = 3;break;//1��3��ΪS2
			 case 0x07:keyno = 10;break;//1��4��ΪS3
		 }
		 //2.ɨ���2��
		 PORTD = ~(1<<PORTD1);//PORTD1Ϊ�͵�ƽ��ɨ���2��
		 _delay_us(7);
		 getkey = (PIND & 0xf0)>>4;//��ȡ��״̬,���ƶ�����4λ
		 switch(getkey)
		 { case 0x0e:keyno = 4;break;
			 //2��1��ΪS4
			 case 0x0d:keyno = 5;break;
			 //2��2��ΪS5
			 case 0x0b:keyno = 6;break;
			 //2��3��ΪS6
			 case 0x07:keyno = 11;break;
			 //2��4��ΪS7
		 }
		 //3.ɨ���3��
		 PORTD = ~(1<<PORTD2);//ɨ���3��
		 _delay_us(14);
		 getkey = (PIND & 0xf0)>>4;//��ȡ��״̬
		 switch(getkey)
		 { case 0x0e:keyno = 7;break;//3��1��ΪS8
			 case 0x0d:keyno = 8;break;//3��2��ΪS9
			 case 0x0b:keyno = 9;break;//��ΪS10
			 case 0x07:keyno = 12;break;//��ΪS11
		 }
		 //4.ɨ���4��
		 PORTD = ~(1<<PORTD3);//PORTD3Ϊ�͵�ƽ��ɨ���4��
		 _delay_us(21);
		 getkey = (PIND & 0xf0)>>4;//��ȡ��״̬,���ƶ�����4λ
		 switch(getkey)
		 { case 0x0e:keyno =13;break;//4��1��ΪS12
			 case 0x0d:keyno =0;break;//4��2��ΪS13
			 case 0x0b:keyno =14;break;//4��3��ΪS14
			 case 0x07:keyno =15;break;//4��4��ΪS15
		 }
		 if(keyno<16) /*ɨ��һ�ֲ������*/
		 { seg7_no[3]=seg7_no[2]; //�ƶ���������
			 seg7_no[2]=seg7_no[1];
			 seg7_no[1]=seg7_no[0];
			 seg7_no[0]=keyno; //�µİ�������
		 }
		/*4λ�߶�����ܶ�̬ɨ����ʾ*/
		 for(i=0;i<4;i++)
		 {
			 PORTC |= 0x0f; //��ֹ��ʾ
			 PORTB = seg7_hex[seg7_no[i]];
			 PORTC = seg7_com[i]; //��ʾ
			 _delay_ms(28);
		 }
    }
}


        %% �������ݣ�����ʱ���ն�ֱ�Ӷ�sc_data���д����Ƿ���ʱͨ�����ڷ���
        function [rxData] = CDMA_RxRFloopback( tx_data,system_type,xsrpip,pcip)
        
		sampleRate=2;	
           %% ����UDP����
            echoudp('off');
            % ����UDPӦ�������
            echoudp('on', 12345);                   
            % ����UDP���ӣ������ֱ�Ϊ��ԴIP��Դ�˿ڣ�����IP�����ض˿ڣ���ʱ(��)�����뻺��(�ֽ�)
%            udp_obj = udp(FPGA_IP,FPGA_PORT,'LocalHost',PC_IP,'LocalPort',PC_PORT,'TimeOut',100,'OutputBufferSize',61440,'InputBufferSize',61440*10);
  udp_obj = udp(xsrpip,13345,'LocalHost',pcip,'LocalPort',12345,'TimeOut',10,'OutputBufferSize',61440,'InputBufferSize',61440*10);
	    fopen(udp_obj);

            %% ��������
            SEND_PACKET_LENGTH=768;
            A=1;	%����
            SAMPLE_LENGTH=2560*6*sampleRate;
            TxdataI=real(tx_data(1,1:SAMPLE_LENGTH))*A;
            TxdataQ=imag(tx_data(1,1:SAMPLE_LENGTH))*A;
            %���Ͳ�������
            %������ͬ���͹���ʱ������
            syncChoice=0;   %������ͬ��ѡ��,0Ϊѡ�񱾵�ͬ���źţ�1ʱѡ���ⲿͬ���ź�
            clcChoice=0;    %����ʱ��ѡ��,Ϊ0ʱΪѡ�񱾵�ʱ�ӣ�Ϊ1ʱѡ���ⲿʱ�ӡ�
            syncClock = SyncClock(syncChoice,clcChoice); 
            fwrite(udp_obj,syncClock,'uint8'); 
            pause(0.01);   %��ʱ��λ��
            %·��ѡ������
            daOut=6;        %DAת����������·��ѡ�����ﲻʹ�ã���������ν
            rf1Tx=6;        %��Ƶ����ͨ��1������·��ѡ��TX1������������
            rf2Tx=0;        %��Ƶ����ͨ��2������·��ѡ�����ﲻʹ�ã���������ν
            eth=0;          %���ڲɼ��źŵ�����·��ѡ�����ڽ���RX1����
            sysAnalogRx=0;  %ϵͳģ���������źŵ�����·��ѡ�����ﲻʹ�ã���������ν
            router = RouterParam(daOut,rf1Tx,rf2Tx,eth,sysAnalogRx);%��ȡ·��ѡ�����
            fwrite(udp_obj,router,'uint8');%�����ڷ���·��ѡ�����
            pause(0.01);   %��ʱ��λ��
            %ETH����ʱ϶�ṹ����
            txSolt=4;         %����һ֡�е�ʱ϶����n��ȡֵ��Χ2��15����Ϊ���õķ�������
            txSoltSwitch=15;  %������Щʱ϶�����ݣ���Щʱ϶�������ݣ��գ�������Ϊ1��ʾ��������Ϊ0��ʾ�أ���ȫ0���ݡ���Ϊʱ϶������2��������3��ʾȫ������
            txFreqDiv=3;    %���ݷ������ʷ�Ƶֵ����30.72MHzΪ�������з�Ƶ��N��0ʱ����ʱ��Ϊ30.72MHZ��N��1ʱ����ʱ��Ϊ15.36MHZ��
            txDataNum=SAMPLE_LENGTH;  %һ��ʱ϶�е����ݸ�����ȡֵ��Χ100��65535
            [txCommand] = TxCommand(txSolt,txSoltSwitch,txFreqDiv,txDataNum);%��ȡ����ʱ϶�ṹ���Ʋ���
            fwrite(udp_obj,txCommand,'uint8'); %�����ڷ��ͷ���ʱ϶�ṹ���Ʋ���
            pause(0.01);   %��ʱ��λ��
            %�����ڷ�����������
	    if system_type==0
            test_Send_IQ = uint8(hex2dec({'00','00','99','bb', '64','00','00','00',  '00','00','00','00',  '00','00','00','00',  '00','00','00','00'}));
            fwrite(udp_obj, test_Send_IQ, 'uint8');
            pause(0.01);   %��ʱ��λ��
            %�������ݴ���
            dataIQ=TxDataDeal(TxdataI,TxdataQ);
            %��������
            for pn =1:fix(SAMPLE_LENGTH*2/(SEND_PACKET_LENGTH/2))
               fwrite(udp_obj,dataIQ(1,(pn-1)*SEND_PACKET_LENGTH/2+1:pn*SEND_PACKET_LENGTH/2),'uint16');
           end
           fwrite(udp_obj,dataIQ(1,pn*SEND_PACKET_LENGTH/2+1:SAMPLE_LENGTH),'uint16');
            pause(0.01);   %��ʱ��λ��
	    end

        
        %% ѭ�����ղ���������
        runInd = 1;
        while runInd == 1 
            %% ��������                
                RECV_PACKET_LENGTH = 360;           %UDP������Ч�ֽڳ���/4,ȡֵ��Χ16��360(ʵ��ֵ������ֵ��4)
		if system_type==0||system_type==1	%QPSK����ϵͳ
                	RECV_BYTE_NUM = 2560*6*sampleRate*2;            %�ܵĽ����ֽ�����һ�βɼ���֡
		else	%���չ����ź�
			RECV_BYTE_NUM = 38400*sampleRate*2;
		end		
                soltNo=2;       %�ɼ��ĸ�ʱ϶�����ݣ�ȡֵ0��15
                %freqDiv=(txFreqDiv+1)/sampleRate-1; 
                freqDiv=3;
                packSize=RECV_PACKET_LENGTH;
                if freqDiv==0   %6���ֽں�2��I��2��Q
                    packNum=ceil(RECV_BYTE_NUM/(RECV_PACKET_LENGTH*4/3));
                else            %4���ֽں�1��I��1��Q
                    packNum= ceil(RECV_BYTE_NUM/RECV_PACKET_LENGTH);
                end
                contSoltSwitch=0;
                contSwitch=0;
                getIQ = GetIQ(soltNo,freqDiv,packNum,packSize,contSoltSwitch,contSwitch);
                %�����ڷ��Ͳɼ�ʱ϶�ṹ����
                fwrite(udp_obj, getIQ, 'uint8');
                %��������
                recvInd = 1;
                cc = 1;
                rx_data=zeros(1,RECV_PACKET_LENGTH*4*packNum);
                while recvInd == 1         %ѭ�����տ���
                [udp_data,count] = fread(udp_obj,RECV_PACKET_LENGTH);
                    if count==0
                        recvInd = 0;
                    end
                    rx_data(1,cc:cc+count-1)=udp_data';
                    cc = cc+count;
                    if cc>=RECV_PACKET_LENGTH*4*packNum||cc==1
                        recvInd = 0;
                    end
                end
                %�Խ��յ����ݽ��д��� 
                [rxdataI,rxdataQ]=RxDataDeal(rx_data,freqDiv,length(rx_data));
                rx_data=rxdataI*1i-rxdataQ;
  
%             %�������
%             delay = 260;
%             fd = 3.84e6;
%             fs = sampleRate*fd;
%             rcos_wi = rcosflt(real(rx_data),fd,fs,'fir/sqrt',0.22,delay);
%             rcos_wq = rcosflt(imag(rx_data),fd,fs,'fir/sqrt',0.22,delay);
%             rxData = rcos_wi + 1i*rcos_wq;
%             rxData = rxData';
%             sampleRate = 4;
%             %ȥ�����������ǰ���delay*sampleRate����
%             rxData = rxData(1, delay*sampleRate+1:delay*sampleRate+25600*2*sampleRate);
            rxData = rx_data;
            runInd=0;
        end
        echoudp('off')
        fclose(udp_obj);
        delete(udp_obj);
        clear udp_obj;
    end
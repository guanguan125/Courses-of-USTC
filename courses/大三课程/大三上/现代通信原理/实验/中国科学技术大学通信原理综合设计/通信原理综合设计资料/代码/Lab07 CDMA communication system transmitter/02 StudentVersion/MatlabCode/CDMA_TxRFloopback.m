        %% 发送数据，仿真时接收端直接对sc_data进行处理，非仿真时通过网口发送
        %system_type系统类型，QPSK传输系统为0，接收公网信号为1
        function [] = CDMA_TxRFloopback( tx_data,system_type,pcip,xsrpip)
		sampleRate=2;	
           %% 启动UDP连接
            echoudp('off');
            % 启动UDP应答服务器
            echoudp('on', 12345);                   
            % 调用UDP连接，参数分别为：源IP，源端口，本地IP，本地端口，超时(秒)，输入缓存(字节)
%            udp_obj = udp(FPGA_IP,FPGA_PORT,'LocalHost',PC_IP,'LocalPort',PC_PORT,'TimeOut',100,'OutputBufferSize',61440,'InputBufferSize',61440*10);
  udp_obj = udp(xsrpip,13345,'LocalHost',pcip,'LocalPort',12345,'TimeOut',10,'OutputBufferSize',61440,'InputBufferSize',61440*10);
	    fopen(udp_obj);

            %% 发送数据
            SEND_PACKET_LENGTH=768;
            A=1;	%幅度
            SAMPLE_LENGTH=2560*6*sampleRate;
            TxdataI=real(tx_data(1,1:SAMPLE_LENGTH))*A;
            TxdataQ=imag(tx_data(1,1:SAMPLE_LENGTH))*A;
            %发送参数配置
            %上下行同步和工作时钟配置
            syncChoice=0;   %上下行同步选择,0为选择本地同步信号，1时选择外部同步信号
            clcChoice=0;    %工作时钟选择,为0时为选择本地时钟，为1时选择外部时钟。
            syncClock = SyncClock(syncChoice,clcChoice); 
            fwrite(udp_obj,syncClock,'uint8'); 
            pause(0.01);   %延时单位秒
            %路由选择配置
            daOut=6;        %DA转换器的数据路由选择，这里不使用，所以无所谓
            rf1Tx=6;        %射频发射通道1的数据路由选择，TX1发射网口数据
            rf2Tx=0;        %射频发射通道2的数据路由选择，这里不使用，所以无所谓
            eth=0;          %网口采集信号的数据路由选择，网口接收RX1数据
            sysAnalogRx=0;  %系统模拟器接收信号的数据路由选择，这里不使用，所以无所谓
            router = RouterParam(daOut,rf1Tx,rf2Tx,eth,sysAnalogRx);%获取路由选择参数
            fwrite(udp_obj,router,'uint8');%向网口发送路由选择参数
            pause(0.01);   %延时单位秒
            %ETH发射时隙结构控制
            txSolt=4;         %定义一帧中的时隙个数n，取值范围2－15。人为设置的发射周期
            txSoltSwitch=15;  %定义哪些时隙发数据，哪些时隙不发数据（空），比特为1表示开，比特为0表示关，发全0数据。因为时隙个数配2，这里配3表示全发数据
            txFreqDiv=3;    %数据发送速率分频值，以30.72MHz为基础进行分频。N＝0时，读时钟为30.72MHZ；N＝1时，读时钟为15.36MHZ。
            txDataNum=SAMPLE_LENGTH;  %一个时隙中的数据个数，取值范围100－65535
            [txCommand] = TxCommand(txSolt,txSoltSwitch,txFreqDiv,txDataNum);%获取发射时隙结构控制参数
            fwrite(udp_obj,txCommand,'uint8'); %向网口发送发射时隙结构控制参数
            pause(0.01);   %延时单位秒
            %向网口发送数据命令
	    if system_type==0
            test_Send_IQ = uint8(hex2dec({'00','00','99','bb', '64','00','00','00',  '00','00','00','00',  '00','00','00','00',  '00','00','00','00'}));
            fwrite(udp_obj, test_Send_IQ, 'uint8');
            pause(0.01);   %延时单位秒
            %发送数据处理
            dataIQ=TxDataDeal(TxdataI,TxdataQ);
            %发送数据
            for pn =1:fix(SAMPLE_LENGTH*2/(SEND_PACKET_LENGTH/2))
               fwrite(udp_obj,dataIQ(1,(pn-1)*SEND_PACKET_LENGTH/2+1:pn*SEND_PACKET_LENGTH/2),'uint16');
           end
           fwrite(udp_obj,dataIQ(1,pn*SEND_PACKET_LENGTH/2+1:SAMPLE_LENGTH),'uint16');
            pause(0.01);   %延时单位秒
	    end

        
        %% 循环接收并处理数据
        
        echoudp('off')
        fclose(udp_obj);
        delete(udp_obj);
        clear udp_obj;
    end
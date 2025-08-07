%% QPSK通信系统设计
%% 20201015
%% LiuDong
%% 20220511
%% lihuxiao

pcip = '192.168.1.181';
xsrpip = '192.168.1.167';
%% 参数
filePath =  'Windows XP.wav';
SNR =30;       % 信噪比（dB）
rf_switch = 0;  % 运行方式，0表示仿真，1表示硬件

%% 读取音频文件
[voiceData,Fs] = GetVoiceData(filePath);

%% PCM编码
sampleVal =4000; %抽样频率
[sampleData,encode_data] = PCM_13Encode(voiceData,Fs,sampleVal);
   figure(1)
    plot(sampleData)
    title('发送语音信号')
%% 数据分帧 
bitLen = 2880; %一帧传输比特数据长度，默认固定2880

[rx_FreData,FreData,frame_num,encode_data,paddingBits] = BitAllocation(bitLen,encode_data);

%% 按帧发送
for n=1:size(FreData)
    %% 添加CRC
    crc_num = 8;%CRC位数，默认固定8位
    [addcrc_data] = txCRCattach(FreData(n,:), crc_num);
    
    %% 信道编码
     Gx = [171, 133];    %卷积码的生成矩阵
     K = 7;                     %卷积码的约束长度
     [tchcode_data] = txTrchCoder(addcrc_data,Gx,K);
     
     %% 插入同步码
     c = [1 1 0 1 1 0 1 0 1 1 0 0 0 1 0 1 1 0 1 1]; %前导码
     addsync_data = AddSyncSig(tchcode_data,c);
     
     %% QPSK调制
     modType = 1;%调制方式，1：QPSK
     mod_data=txMod(addsync_data,modType);
     
     %% 上采样
     sample_rate = 10;%上采样率，每个符号sample_rate个采样
     
     updata = UpSample(mod_data,sample_rate);
     %% 脉冲成形
     %shaping_data = updata;
     [shaping_data] = PulseShaper (updata, sample_rate);
%      figure(1)
%      plot(real(shaping_data))
     
     %% 信道
     FRAME_LEN = 30720;%帧样点数据长度，固定30720
     tx_dataIQ = [shaping_data,randi([0,1],1,FRAME_LEN-length(shaping_data))*2-1];
     if rf_switch ==1
       [rxdataIQ,ERR_CODE] = RFLoopback(tx_dataIQ,pcip,xsrpip);
        rx_data = rxdataIQ;
     else
        rx_data = QPSK_awgn(tx_dataIQ,SNR);
     end
     
     figure(2)
     plot(real(rx_data))
     %% 匹配滤波
     [ rx_data ] = MatchFiltering( rx_data,sample_rate );
     
     %% 帧同步
     [frame_data,findscNo,modScCorr] = DeSync(rx_data,c,sample_rate);
     findscNo
     %% 下采样

     [down_data] = DownSample (frame_data, sample_rate);
     figure(3)
     plot(frame_data,'*')
     title('帧同步后星座图')
     
     figure(4)
     plot(down_data,'*')
      title('下采样后星座图')
     %% 信道估计与均衡
     outData = APcorrect(down_data,c);
     figure(5)
     plot(outData,'*')
     title('均衡后星座图')
     %% QPSK 解调
     demod_data = rxDemod(outData,modType);
     
     %% 信道译码
     [tchdecode_data] = rxTrchDecoder(demod_data,Gx,K);
     
     %% CRC校验
     [CRC_flag,rx_bit] = rxCRC(tchdecode_data, crc_num);
     
%      CRC_flag  %CRC校验结果，1表示传输正确，0表示传输错误
     fprintf('第%d帧CRC：%d    ',n,CRC_flag);
     
     if length(FreData(n,:))==length(rx_bit)
         [errnum,ber] = QPSK_ber(FreData(n,:),rx_bit);
        errnum; %当前帧误码数
        ber; %当前帧误码率
        fprintf('第%d帧误码数：%d    ',n,errnum);
        fprintf('第%d帧误码率：%d\n',n,ber);
        rx_FreData(n,:) = rx_bit;
     end
%    
end


%% 数据组帧
[reshape_bits,rewav_bits] = BitAssemble(rx_FreData,frame_num,bitLen,paddingBits);   

%% PCM译码
[pcm_dedata] = PCM_13Decode( rewav_bits );
   figure(6)
   plot(pcm_dedata)
   title('接收语音信号')
%% 写入音频文件
writeFilePath = 'recvsound.wav';
[out_data] = WriteVoiceData(writeFilePath, pcm_dedata, sampleVal);
     
%% 总误码数、总误码率
[errnum,ber] = QPSK_ber(encode_data,reshape_bits);
fprintf('总误码数：%d    ',errnum);
fprintf('总误码率：%d\n',ber);

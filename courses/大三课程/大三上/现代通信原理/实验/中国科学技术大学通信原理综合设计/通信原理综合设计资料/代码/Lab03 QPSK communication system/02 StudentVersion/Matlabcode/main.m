%% QPSKͨ��ϵͳ���
%% 20201015
%% LiuDong
%% 20220511
%% lihuxiao

pcip = '192.168.1.181';
xsrpip = '192.168.1.167';
%% ����
filePath =  'Windows XP.wav';
SNR =30;       % ����ȣ�dB��
rf_switch = 0;  % ���з�ʽ��0��ʾ���棬1��ʾӲ��

%% ��ȡ��Ƶ�ļ�
[voiceData,Fs] = GetVoiceData(filePath);

%% PCM����
sampleVal =4000; %����Ƶ��
[sampleData,encode_data] = PCM_13Encode(voiceData,Fs,sampleVal);
   figure(1)
    plot(sampleData)
    title('���������ź�')
%% ���ݷ�֡ 
bitLen = 2880; %һ֡����������ݳ��ȣ�Ĭ�Ϲ̶�2880

[rx_FreData,FreData,frame_num,encode_data,paddingBits] = BitAllocation(bitLen,encode_data);

%% ��֡����
for n=1:size(FreData)
    %% ���CRC
    crc_num = 8;%CRCλ����Ĭ�Ϲ̶�8λ
    [addcrc_data] = txCRCattach(FreData(n,:), crc_num);
    
    %% �ŵ�����
     Gx = [171, 133];    %���������ɾ���
     K = 7;                     %������Լ������
     [tchcode_data] = txTrchCoder(addcrc_data,Gx,K);
     
     %% ����ͬ����
     c = [1 1 0 1 1 0 1 0 1 1 0 0 0 1 0 1 1 0 1 1]; %ǰ����
     addsync_data = AddSyncSig(tchcode_data,c);
     
     %% QPSK����
     modType = 1;%���Ʒ�ʽ��1��QPSK
     mod_data=txMod(addsync_data,modType);
     
     %% �ϲ���
     sample_rate = 10;%�ϲ����ʣ�ÿ������sample_rate������
     
     updata = UpSample(mod_data,sample_rate);
     %% �������
     %shaping_data = updata;
     [shaping_data] = PulseShaper (updata, sample_rate);
%      figure(1)
%      plot(real(shaping_data))
     
     %% �ŵ�
     FRAME_LEN = 30720;%֡�������ݳ��ȣ��̶�30720
     tx_dataIQ = [shaping_data,randi([0,1],1,FRAME_LEN-length(shaping_data))*2-1];
     if rf_switch ==1
       [rxdataIQ,ERR_CODE] = RFLoopback(tx_dataIQ,pcip,xsrpip);
        rx_data = rxdataIQ;
     else
        rx_data = QPSK_awgn(tx_dataIQ,SNR);
     end
     
     figure(2)
     plot(real(rx_data))
     %% ƥ���˲�
     [ rx_data ] = MatchFiltering( rx_data,sample_rate );
     
     %% ֡ͬ��
     [frame_data,findscNo,modScCorr] = DeSync(rx_data,c,sample_rate);
     findscNo
     %% �²���

     [down_data] = DownSample (frame_data, sample_rate);
     figure(3)
     plot(frame_data,'*')
     title('֡ͬ��������ͼ')
     
     figure(4)
     plot(down_data,'*')
      title('�²���������ͼ')
     %% �ŵ����������
     outData = APcorrect(down_data,c);
     figure(5)
     plot(outData,'*')
     title('���������ͼ')
     %% QPSK ���
     demod_data = rxDemod(outData,modType);
     
     %% �ŵ�����
     [tchdecode_data] = rxTrchDecoder(demod_data,Gx,K);
     
     %% CRCУ��
     [CRC_flag,rx_bit] = rxCRC(tchdecode_data, crc_num);
     
%      CRC_flag  %CRCУ������1��ʾ������ȷ��0��ʾ�������
     fprintf('��%d֡CRC��%d    ',n,CRC_flag);
     
     if length(FreData(n,:))==length(rx_bit)
         [errnum,ber] = QPSK_ber(FreData(n,:),rx_bit);
        errnum; %��ǰ֡������
        ber; %��ǰ֡������
        fprintf('��%d֡��������%d    ',n,errnum);
        fprintf('��%d֡�����ʣ�%d\n',n,ber);
        rx_FreData(n,:) = rx_bit;
     end
%    
end


%% ������֡
[reshape_bits,rewav_bits] = BitAssemble(rx_FreData,frame_num,bitLen,paddingBits);   

%% PCM����
[pcm_dedata] = PCM_13Decode( rewav_bits );
   figure(6)
   plot(pcm_dedata)
   title('���������ź�')
%% д����Ƶ�ļ�
writeFilePath = 'recvsound.wav';
[out_data] = WriteVoiceData(writeFilePath, pcm_dedata, sampleVal);
     
%% ������������������
[errnum,ber] = QPSK_ber(encode_data,reshape_bits);
fprintf('����������%d    ',errnum);
fprintf('�������ʣ�%d\n',ber);

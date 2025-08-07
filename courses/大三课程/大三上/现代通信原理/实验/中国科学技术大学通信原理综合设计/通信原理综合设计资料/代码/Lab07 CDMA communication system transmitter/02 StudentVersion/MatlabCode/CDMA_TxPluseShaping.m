function tx_data=CDMA_TxPluseShaping(sc_data,sampleRate)
rrc_ind=1;
if rrc_ind == 1
    %�˲���ϵ��
    Beta = 0.22;    % Filter rolloff factor
    N = 260;        % Filter order (must be even). The length of the impulse response is N+1.
    %���ɸ������ҹ����˲���
    h  = fdesign.pulseshaping(sampleRate,'Square Root Raised Cosine','N,Beta',N,Beta);  
    Hd = design(h);
    rrcFilter = Hd.Numerator;
    %��ֵ���˲�.
    tx_data = upfirdn(sc_data, rrcFilter, sampleRate);
    %ȥ���˲���������������
    tx_data = tx_data((N-sampleRate)/2+1:end-(N-sampleRate)/2-1);
%���˲�������ֵ��sampleRate=2
else
    temp_sc_data(1,1:2:2560*6*2) = sc_data;
    temp_sc_data(1,2:2:2560*6*2) = sc_data;
    tx_data = temp_sc_data;  
end
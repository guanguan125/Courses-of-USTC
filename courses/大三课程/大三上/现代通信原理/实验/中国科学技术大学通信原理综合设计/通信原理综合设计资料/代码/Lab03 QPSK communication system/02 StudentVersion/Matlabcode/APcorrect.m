%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            APcorrect.m
%  Description:         �ŵ��������ŵ�����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter
%           outData     ���ƺ�����
%       Input Parameter
%           inputData	ͬ���������
%           c                  ͬ����
%           sample_rate  һ����Ԫ�����ڵ�������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:           2018-05-25
%       Author:         LiuDong
%       Version:        1.0 
%       Modification:   ����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function outData=APcorrect(inputData,c)

%��ͬ�������ɲο��ź�
bitSymbol = 2; %�̶�ʹ��QPSK����һ�����Ŷ�Ӧ2bit
c_len = (length(c))/bitSymbol;  %ͬ����ķ��ų���
c_mod_data = zeros(1,c_len);
c = c*(-2)+1;   %ӳ�䣬0 1ӳ��Ϊ 1 -1
c_mod_data=c(1,1:2:end)+i*c(1,2:2:end);%�ο��źŶ�Ӧ��QPSK����
rx_c_mod_data=inputData(1,1:10);

ang=angle(c_mod_data)-angle(rx_c_mod_data);%������λƫת
len_rx_c_mod=length(rx_c_mod_data);
len_data=length(inputData(1,len_rx_c_mod+1:end));  %��ȡ�ο��źź����������

%��λ��������
ref_ang=zeros(1,len_data);
if len_data<len_rx_c_mod           %�жϽ�ȡ�ο��źź�����ݳ�����ο��źų���
    n=floor(len_rx_c_mod/len_data);     
    for m=1:len_data
        ref_ang(m)=ang(m*n);            %����ÿ���źŵ�ƫתֵ
    end
elseif len_data>len_rx_c_mod  
    n=len_data/len_rx_c_mod;
    for m=1:len_data
        ref_ang(m)=ang(ceil(m/n));     %����ÿ���źŵ�ƫתֵ
    end
end
ref_A=sqrt(2)/(sum(abs(rx_c_mod_data))/10);     %����ϵ��
outData=inputData(1,len_rx_c_mod+1:end).*exp(1i*ref_ang)*ref_A;%��λ����


end
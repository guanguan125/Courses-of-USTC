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

function outData=APcorrect(inputData,c,EN_AP)

% %��ͬ�������ɲο��ź�


%%

rx_c_mod_data=inputData(1,1:30);
len_rx_c_mod=length(rx_c_mod_data);
 if EN_AP==1
c_mod_data= -c*2+1;   %ӳ�䣬0 1ӳ��Ϊ-1 1
ang=angle(c_mod_data)-angle(rx_c_mod_data);%������λƫת

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
 else
    outData= inputData(1,len_rx_c_mod+1:end);
 end

end
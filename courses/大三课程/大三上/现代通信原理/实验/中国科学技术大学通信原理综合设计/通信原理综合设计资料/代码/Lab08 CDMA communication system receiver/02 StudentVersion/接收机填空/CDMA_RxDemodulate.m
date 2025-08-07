%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            mfRxDemodulate.m
%  Description:         ʹ�òο���λ�ķ��������ʱƵͬ����
%  Reference:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter
%           out_data	���������������� 
%           temp_data   ����Ƶƫ������ݣ���ҪΪ�۲�����ͼ
%       Input Parameter
%           input_data	��������������
%           pich_data   ��Ϊ�ο��źŵĵ�Ƶ�ź�����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:           2017-12-1
%       Author:         david.lee
%       Version:        1.0 
%       Modification:   ����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [out_data, temp_data] = CDMA_RxDemodulate(input_data, pich_data)  

%% ������ʼ��
out_data = zeros(1, length(input_data)*2);
%ʹ�ο����ݳ��Ⱥ����ݳ���һ��
ref_data = zeros(1, length(input_data));
if length(input_data) < length(pich_data)
    n = length(pich_data)/length(input_data);
    for m = 1:length(input_data)
        ref_data(m) =  pich_data(m*n);
    end   
elseif length(input_data) > length(pich_data)
    n = length(input_data)/length(pich_data);
    for m = 1:length(input_data)
        ref_data(m) =  pich_data(ceil(m/n));
    end
else 
    ref_data =  pich_data;
end

%% ����ʵ��
%��PCPICH���ݵ���λ��Ϊ�ο�������Ƶƫ���µ���λƫ��
temp_data = input_data.*exp(-1i*angle(ref_data));
%%%%%%%%%%%%%%% student code %%%%%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            mfRxDespread.m
%  Description:         ����
%  Reference:           3GPP TS 25.213, 5.1 Spreading
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter
%           out_data	����������������� 
%       Input Parameter
%           input_data	���������������
%           sf          ȡֵ��Χ4��8������512
%           ovsf_No     ��Ƶ��ţ�ȡֵ��Χ0~sf-1
%           sample_rate ������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:           2017-12-1
%       Author:         david.lee
%       Version:        1.0 
%       Modification:   ����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [out_data] = CDMA_RxDespread(input_data, sf, ovsf_No, sample_rate)

%% ������ʼ��
out_data = zeros(1, 2560*6/sf);  %ֻȡǰ10��ʱ϶
spreadLength =  sample_rate*sf; %#ok

%% ����ʵ��
%����OVSF��Ƶ��

%%%%%%%%%%%%%%% student code %%%%%%%%%%%%%%%%%%%%%%%
%SF = 4

%SF = 8 


%SF = 16

%SF = 32

%SF = 64

%SF = 128

%SF = 256

%SF = 512

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%�������Ҫ��OVSF��
%%%%%%%%%%%%%%% student code %%%%%%%%%%%%%%%%%%%%%%%
switch sf
    case 4
        ovsf_code = 
    case 8
        ovsf_code = 
    case 16
        ovsf_code =         
    case 32
        ovsf_code = 
    case 64
        ovsf_code = 
    case 128
        ovsf_code = 
    case 256
        ovsf_code =; 
    case 512
        ovsf_code = 
    otherwise
        fprintf('error:����mfOvsfCodeGenerate�Ĳ���sf�������\n');  
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ovsfCodeSample = zeros(1, sf*sample_rate);
for n = 1:sf
    for m = 1:sample_rate
        ovsfCodeSample((n-1)*sample_rate + m) = ovsf_code(n);
    end
end

%����
spreadLength =  sample_rate*sf;
for data_num=1:2560*6/sf
    for n=1:spreadLength
        out_data(data_num)=out_data(data_num)+input_data(1, (data_num-1)*spreadLength+n)/ovsfCodeSample(n);
    end
end

end
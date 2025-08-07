%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            mfTxSpreading.m
%  Description:         ����ת�������Ա仯����Ƶ�����ݸ�����
%  Reference:           3GPP TS 25.213, 5.1 Spreading
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter
%           out_data	���������Ƶ������ 
%       Input Parameter
%           input_data	�������Ƶ������
%           sf          ȡֵ��Χ4��8������512
%           ovsf_No     ��Ƶ��ţ�ȡֵ��Χ0~sf-1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:           2017-12-1
%       Author:         david.lee
%       Version:        1.0 
%       Modification:   ����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [out_data] = CDMA_TxSpreading(input_datai,input_dataq, sf, ovsf_No)

%% ������ʼ��
input_num = length(input_datai);
ovsf_code = zeros(1, sf);   
out_data = zeros(1, input_num*sf);
%����OVSF��Ƶ��

%%%%%%%%%%%%%%% student code %%%%%%%%%%%%%%%%%%%%%%%
%����SF��4~512��ȫ��OVSF��Ƶ��
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
   
    
    
    otherwise
        fprintf('error:����mfOvsfCodeGenerate�Ĳ���sf�������\n');  
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%��Ƶ


end
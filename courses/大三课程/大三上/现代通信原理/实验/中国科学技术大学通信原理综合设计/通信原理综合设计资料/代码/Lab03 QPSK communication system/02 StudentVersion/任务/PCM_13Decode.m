%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            PCM_13Decode.m
%  Description:         PCM 13������������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter
%           outData     �������Ƶ����������
%       Input Parameter
%           inputData	��������bit������

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:           2018-5-17
%       Author:         tony liu
%       Version:        1.0 
%       Modification:   ����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  [outData] = PCM_13Decode( inputData )

n=length(inputData);
code_bits_len=8; % ʹ��13���߱��룬һ�������Ӧ8bit����

outData=zeros(1,n/code_bits_len);  %8λPCM���� �Ľ������ ��ʼ����8λ��PCM���� �������8λ��

MM=zeros(1,code_bits_len); %  8λPCM��������� ��ʼ��  


%%%%%������գ�
%��������ƽR��ע�ⵥλ�Ƿ��ء���Χ��[-1,1]֮�䡣



%%%%�������.

end
end

%%%%%%%%������END%%%%%%%%%%%%%
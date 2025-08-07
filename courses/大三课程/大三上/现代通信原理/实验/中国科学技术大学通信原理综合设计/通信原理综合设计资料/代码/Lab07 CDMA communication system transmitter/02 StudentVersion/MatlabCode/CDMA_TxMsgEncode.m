%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            CDMA_TxMsgEncode.m
%  Description:         ����Դ����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Input Parameter
%           char_msg    ��������
%           bit_len     ����bit����
%           ch_cap      ����ַ�����
%       Output Parameter
%           bit_msg     ���������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:           2018-8-8
%       Author:         tony.liu
%       Version:        1.0 
%       Modification:   ����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [bit_msg] = CDMA_TxMsgEncode(char_msg,ch_bit_len,ch_cap)

bit_msg = zeros(1,ch_bit_len);

if length(char_msg)>ch_cap
    disp('WANNING,������Դ����ϵͳ�������,�Զ���ȡ��Ч����');
    char_msg=char_msg(1,1:ch_cap);%�Զ���ȡ
end

for num = 1:length(char_msg)
    input_data1(1,8*(num-1)+1:8*num)=de2bi(abs(char_msg(num)),8,'left-msb'); %��ÿ���ַ�ת��λ8λ���λ������2������,����ASCII�����ֻ֧��Ӣ�ģ�
end

len_bit=length(input_data1);
len_msg1=de2bi(len_bit,16,'left-msb');          %CRC����ǰ16λ������Ч���ݵĳ��ȣ����ڽ��ն�ʶ��
bit_msg1=[len_msg1,input_data1];
len=length(bit_msg1);
bit_msg(1,1:len) = bit_msg1;

end
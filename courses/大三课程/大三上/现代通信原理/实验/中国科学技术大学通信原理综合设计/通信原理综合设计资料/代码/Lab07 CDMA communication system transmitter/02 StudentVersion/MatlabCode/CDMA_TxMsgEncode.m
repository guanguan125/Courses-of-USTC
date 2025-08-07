%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            CDMA_TxMsgEncode.m
%  Description:         数据源编码
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Input Parameter
%           char_msg    输入数据
%           bit_len     传输bit长度
%           ch_cap      最大字符长度
%       Output Parameter
%           bit_msg     编码后数据
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:           2018-8-8
%       Author:         tony.liu
%       Version:        1.0 
%       Modification:   初稿
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [bit_msg] = CDMA_TxMsgEncode(char_msg,ch_bit_len,ch_cap)

bit_msg = zeros(1,ch_bit_len);

if length(char_msg)>ch_cap
    disp('WANNING,发送信源超过系统最大容量,自动截取有效长度');
    char_msg=char_msg(1,1:ch_cap);%自动截取
end

for num = 1:length(char_msg)
    input_data1(1,8*(num-1)+1:8*num)=de2bi(abs(char_msg(num)),8,'left-msb'); %将每个字符转换位8位最高位在左侧的2进制数,对照ASCII码表，（只支持英文）
end

len_bit=length(input_data1);
len_msg1=de2bi(len_bit,16,'left-msb');          %CRC比特前16位放置有效数据的长度，便于接收端识别
bit_msg1=[len_msg1,input_data1];
len=length(bit_msg1);
bit_msg(1,1:len) = bit_msg1;

end
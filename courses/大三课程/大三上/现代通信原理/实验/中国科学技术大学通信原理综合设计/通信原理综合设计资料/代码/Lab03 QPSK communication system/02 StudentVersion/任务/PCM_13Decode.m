%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            PCM_13Decode.m
%  Description:         PCM 13折线语音解码
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter
%           outData     解码后音频或语音数据
%       Input Parameter
%           inputData	输入编码后bit流数据

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:           2018-5-17
%       Author:         tony liu
%       Version:        1.0 
%       Modification:   初稿
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  [outData] = PCM_13Decode( inputData )

n=length(inputData);
code_bits_len=8; % 使用13折线编码，一个样点对应8bit编码

outData=zeros(1,n/code_bits_len);  %8位PCM编码 的解码输出 初始化（8位是PCM编码 编码后是8位）

MM=zeros(1,code_bits_len); %  8位PCM码比特数据 初始化  


%%%%%以下填空：
%输出译码电平R，注意单位是伏特。范围在[-1,1]之间。



%%%%以上填空.

end
end

%%%%%%%%程序框架END%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   FileName      : ASK_DeSync.m
%   Description   : 搜索帧头的位置
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Function List :
%       out_data = ASK_DeSync(input_data,SendSig,UpSampleRate,code_model,Preamble,PreambleLen)
%   Parameter List:       
%       Output Parameter
%           output_data	  经ASK调制后的信号
%       Input Parameter
%           input_data	  滤波后信号
%           UpSampleRate  一个码元周期内样点数
%           bitLen            信源数据一帧的长度
%           n                     汉明码的码组长度
%           crc_num        CRC校验码的码长
%           code_model  信道编码方式   0代表汉明码  1代表循环码
%           Preamble      同步码
%           PreambleLen  同步码的长度
%   History
%       1. Date        : 2022-2-28
%           Author      : LHX
%           Version     : 2.0
%           Modification: 第二版
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function output_data = ASK_Sync(input_data,UpSampleRate,bitLen,n,crc_num,code_model,Preamble,PreambleLen)
%同步码转为极性码的计算


%编码后比特长度计算


end

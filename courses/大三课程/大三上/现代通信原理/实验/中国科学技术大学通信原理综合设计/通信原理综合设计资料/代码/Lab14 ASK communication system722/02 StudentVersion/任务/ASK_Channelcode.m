%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  File Name: ASK_Channelcode.m
%  Description: 汉明码与循环码的编码
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Function List :
%           Channel_Bit = ASK_Channelcode(CRC_Bit,code_model,Gx,n,k)
%  Parameter List:
%      Input Parameter:
%           CRC_Bit:  加入CRC之后的比特数据
%           codemodel:选择编码方式 
%           Gx    循环码的生成多项式，[1,0,1,1]、[1,1,0,1]为（7,4）循环码优选多项式，有1位检错能力
%           n       汉明码编码的码组长度，n与k可选（12，8）或者（7，4）
%           k       汉明码编码的信息位
%      Output Parameter:
%          Channel_Bit      信道编码后数据
%   History
%       1. Date        : 2022-2-28
%           Author      : LHX
%           Version     : 2.0
%           Modification: 第二版
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Channel_Bit = ASK_Channelcode(CRC_Bit,code_model,Gx,n,k)
      %%%%%%%%%%%%%%% student code %%%%%%%%%%%%%%%%%%%%%%%      

    
    

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
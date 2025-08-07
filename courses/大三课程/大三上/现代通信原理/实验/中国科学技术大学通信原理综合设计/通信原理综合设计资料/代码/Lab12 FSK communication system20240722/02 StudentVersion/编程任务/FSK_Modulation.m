%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FlieName:FSK_Modulation.m
%  Description:FSK调制（对加同步码后数据反向处理生成两路信号，分别进行脉冲成型和载波调制并对两路信号相加得到FSK信号）
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Function List :
%           [SendSig1_i,SendSig2_i,SendSig] =FSK_Modulation(Fs,data,UpSampleRate,FreqCarrier1,FreqCarrier2)
%  Parameter List:
%     Output Parameter
%           SendSig1_i             与载波1相乘的信号
%           SendSig2_i             与载波2相乘的信号
%           SendSig                  相加后的信号
%     Input Parameter
%           Fs                          采样率  
%           data                       加入同步码后的比特数据
%           UpSampleRate    单位码元的样点数
%           FreqCarrier1        载波1频率
%           FreqCarrier2        载波2频率
%   History
%       1. Date        : 2022-1-10
%           Author      : LHX
%           Version     : 2.0
%           Modification: 第二版
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [SendSig1_i,SendSig2_i,SendSig] =FSK_Modulation(Fs,data,UpSampleRate,FreqCarrier1,FreqCarrier2)

%% 反相器
%%%%以下填空：
	                                  %由data数据生成data2；0变换成1，1变换成0
%%%%以上填空：
 
 %% 上采样
   %%%%以下填空：
 %利用zeros函数，生成一个码元周期内的样点数UpSampleRate*data长度的全0矩阵  
     
          %同上
          
 %上采样，将每个码元的数值赋值到UpSampleRate长度中
     
%%%%以上填空：



%%  产生载波1和载波2

%%%%以下填空：



%%%%以上填空：


%% 乘法器1和乘法器2
%%%%以下填空：
                                    % 调制信号1 ，基带信号1 * 载波1 


                                    % 调制信号2 ，基带信号2 * 载波2 

%%%%以上填空：
%% 加法器
%%%%以下填空：



%%%%以上填空：
end

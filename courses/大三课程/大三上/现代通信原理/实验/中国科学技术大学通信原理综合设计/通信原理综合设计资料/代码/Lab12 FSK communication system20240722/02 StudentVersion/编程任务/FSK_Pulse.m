%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            FSK_Pulse.m
%  Description:         产生定时脉冲（观察定时脉冲与码元之间的定时关系）
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Function List :
%           [samplePulse] = FSK_Pulse(RecvSig,pos,UpSampleRate)
%  Parameter List:       
%       Output Parameter
%           samplePulse     产生的脉冲信号
%       Input Parameter
%           RecvSig             从信道中接收到的信号
%           pos                     同步码的初试位置
%           UpSampleRate 一个码元周期内的样点数
%   History
%       1. Date        : 2022-1-10
%           Author      : LHX
%           Version     : 2.0
%           Modification: 第二版
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [samplePulse] = FSK_Pulse(RecvSig,pos,UpSampleRate)

%初始化30720长度的数组

%%%%以下填空：
              


% 增加一个for循环，从pos位置开始，获得samplePulse。抽样位置上（间隔为UpSampleRate），samplePulse数值置为1
%%%%以上填空：

end


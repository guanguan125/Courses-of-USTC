%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            GetVoiceData.m
%  Description:         读语音文件，获取语音数据
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter
%           voiceData	语音数据
%           Fs          采样率
%       Input Parameter
%           filePath	语音文件路径
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:           2018-6-19
%       Author:         LiuDong
%       Version:        1.0 
%       Modification:   初稿
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [voiceData,Fs] = GetVoiceData(filePath)

% [y,Fs,bits]=wavread(filePath);  % 根据输入的语音文件路径，读取语音文件，返回语音数据
[y,Fs]=audioread(filePath);  % 根据输入的语音文件路径，读取语音文件，返回语音数据
y=y';                           % 语音数是按列排列，对语音数据进行转置
voiceData=y(1,:);                    % 语音数据包含左右双声道，只取一个声道数据做后续处理

end
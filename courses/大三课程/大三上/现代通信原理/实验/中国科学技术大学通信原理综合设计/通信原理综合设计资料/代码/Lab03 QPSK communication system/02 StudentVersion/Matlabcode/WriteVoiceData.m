%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            WriteVoiceData.m
%  Description:         语音数据写入WAV文件
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter

%       Input Parameter
%           filePath	语音文件路径
%           intput_data	写入数据
%           sampleVal	采样率
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:           2018-6-19
%       Author:         LiuDong
%       Version:        1.0 
%       Modification:   初稿
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [input_data] = WriteVoiceData(filePath, input_data, sampleVal)


writeData=[ input_data; input_data]'; %复制声道1数据到声道2，并转置

audiowrite(filePath,writeData,sampleVal);

end
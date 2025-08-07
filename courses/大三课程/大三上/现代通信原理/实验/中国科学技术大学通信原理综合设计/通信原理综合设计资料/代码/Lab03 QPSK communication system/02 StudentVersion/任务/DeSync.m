%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            DeSync.m
%  Description:         搜索同步码
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter
%           outData     调制后数据
%           modScCorr 相关峰波形
%       Input Parameter
%           inputData	输入待调制映射bit流
%           c                  同步码
%           sample_rate  一个码元周期内的样点数
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:           2018-05-25
%       Author:         LiuDong
%       Version:        1.0 
%       Modification:   初稿
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [outData,findscNo,modScCorr] = DeSync(inputData,c,sample_rate)

%%时隙同步
%利用参考信号进行相关运算

%同步码上采样


%滑动同步



%找相关峰最大值


end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            mfPSCGenerate.m
%  Description:         生成主同步码
%  Reference:           3GPP TS 25.213, 5.2.3 Synchronisation codes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter
%           PSC         生成的主同步码
%       Input Parameter
%           无
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:           2017-12-1
%       Author:         david.lee
%       Version:        1.0 
%       Modification:   初稿
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [PSC] = mfPSCGenerate()   

%% 变量初始化
PSC = zeros(1, 256);    %#ok 
a=[1, 1, 1, 1, 1, 1, -1, -1, 1, -1, 1, -1, 1, -1, -1, 1];    %意义同3GPP TS 25.213 5.2.3.1中a

%% 功能实现
%生成主同步码
PSC=(1+1i)*[a, a, a, -a, -a, a, -a, -a, a, a, a, -a, a, -a, a, a];

end

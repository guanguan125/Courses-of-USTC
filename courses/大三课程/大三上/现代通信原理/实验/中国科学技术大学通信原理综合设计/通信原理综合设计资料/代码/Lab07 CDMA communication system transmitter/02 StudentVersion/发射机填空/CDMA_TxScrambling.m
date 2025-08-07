%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            mfTxScrambling.m
%  Description:         加扰
%  Reference:           3GPP TS 25.213, 5.2.2 Scrambling code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter
%           out_data        输出经过加扰的数据 
%       Input Parameter
%           input_data      输入待加扰的数据
%           group_num       扰码组号，取值范围1~64
%           scramble_num	扰码号，取值范围1~8
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:           2017-12-1
%       Author:         david.lee
%       Version:        1.0 
%       Modification:   初稿
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function out_data = CDMA_TxScrambling(input_data, group_num, scramble_num)

%% 变量初始化
input_num = length(input_data);
x = zeros(1,262143);        %意义同3GPP TS 25.213 5.2.2中x
y = zeros(1,262143);        %意义同3GPP TS 25.213 5.2.2中y
zn = zeros(8, 207872);      %#ok 意义同3GPP TS 25.213 5.2.2中Zn
S = zeros(8,38400);         %某个扰码中的8个下行扰码，意义同3GPP TS 25.213 5.2.2中Sdl,n
out_data = zeros(1,input_num);  

%% 功能实现
%%生成扰码
for n = 1:18
    x(n) = 0;
    y(n) = 1;
end
x(1) = 1;
for n = 1:262125  %i=0,…, -20
    %%%%%%%%%%%%%%% student code %%%%%%%%%%%%%%%%%%%%%%%
    x(n + 18) =                                 %
   
    y(n + 18) =                                  %
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
zn = zeros(8,207872);                            %某扰码组中的8个主扰码207872 = 131072 + 38400
    %%%%%%%%%%%%%%% student code %%%%%%%%%%%%%%%%%%%%%%%
for k = 1:8  
    n =                                             %第group_num辅扰码集中的扰码序列序号
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for m = 1:207872
        zn(k,m) = x(m + n) + y(m);                                %第group_num个扰码组中的8个主扰码bit
    end
end
zn = (-2)*mod(zn,2) + 1;
    %%%%%%%%%%%%%%% student code %%%%%%%%%%%%%%%%%%%%%%%
for n = 1:8
    for m = 1:38400
        S(n,m) =                    %第group_num个扰码组中的8个主扰码                                
    end
end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 加扰
  %%%%%%%%%%%%%%% student code %%%%%%%%%%%%%%%%%%%%%%%
out_data =                        %输入数据*主扰码（主扰码取scramble_num行数据）
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            mfRxDemodulate.m
%  Description:         使用参考相位的方法解调（时频同步）
%  Reference:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter
%           out_data	输出经过解调的数据 
%           temp_data   纠正频偏后的数据，主要为观察星座图
%       Input Parameter
%           input_data	输入待解调的数据
%           pich_data   作为参考信号的导频信号数据
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:           2017-12-1
%       Author:         david.lee
%       Version:        1.0 
%       Modification:   初稿
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [out_data, temp_data] = CDMA_RxDemodulate(input_data, pich_data)  

%% 参数初始化
out_data = zeros(1, length(input_data)*2);
%使参考数据长度和数据长度一致
ref_data = zeros(1, length(input_data));
if length(input_data) < length(pich_data)
    n = length(pich_data)/length(input_data);
    for m = 1:length(input_data)
        ref_data(m) =  pich_data(m*n);
    end   
elseif length(input_data) > length(pich_data)
    n = length(input_data)/length(pich_data);
    for m = 1:length(input_data)
        ref_data(m) =  pich_data(ceil(m/n));
    end
else 
    ref_data =  pich_data;
end

%% 功能实现
%以PCPICH数据的相位作为参考，补偿频偏导致的相位偏差
temp_data = input_data.*exp(-1i*angle(ref_data));
%%%%%%%%%%%%%%% student code %%%%%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

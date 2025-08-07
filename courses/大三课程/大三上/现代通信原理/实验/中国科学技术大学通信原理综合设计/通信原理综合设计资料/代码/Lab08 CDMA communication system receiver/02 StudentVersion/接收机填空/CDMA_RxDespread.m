%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            mfRxDespread.m
%  Description:         解扩
%  Reference:           3GPP TS 25.213, 5.1 Spreading
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter
%           out_data	输出经过解扩的数据 
%       Input Parameter
%           input_data	输入待解扩的数据
%           sf          取值范围4、8、…、512
%           ovsf_No     扩频码号，取值范围0~sf-1
%           sample_rate 采样率
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:           2017-12-1
%       Author:         david.lee
%       Version:        1.0 
%       Modification:   初稿
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [out_data] = CDMA_RxDespread(input_data, sf, ovsf_No, sample_rate)

%% 变量初始化
out_data = zeros(1, 2560*6/sf);  %只取前10个时隙
spreadLength =  sample_rate*sf; %#ok

%% 功能实现
%生成OVSF扩频码

%%%%%%%%%%%%%%% student code %%%%%%%%%%%%%%%%%%%%%%%
%SF = 4

%SF = 8 


%SF = 16

%SF = 32

%SF = 64

%SF = 128

%SF = 256

%SF = 512

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%输出所需要的OVSF码
%%%%%%%%%%%%%%% student code %%%%%%%%%%%%%%%%%%%%%%%
switch sf
    case 4
        ovsf_code = 
    case 8
        ovsf_code = 
    case 16
        ovsf_code =         
    case 32
        ovsf_code = 
    case 64
        ovsf_code = 
    case 128
        ovsf_code = 
    case 256
        ovsf_code =; 
    case 512
        ovsf_code = 
    otherwise
        fprintf('error:函数mfOvsfCodeGenerate的参数sf输入错误\n');  
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ovsfCodeSample = zeros(1, sf*sample_rate);
for n = 1:sf
    for m = 1:sample_rate
        ovsfCodeSample((n-1)*sample_rate + m) = ovsf_code(n);
    end
end

%解扩
spreadLength =  sample_rate*sf;
for data_num=1:2560*6/sf
    for n=1:spreadLength
        out_data(data_num)=out_data(data_num)+input_data(1, (data_num-1)*spreadLength+n)/ovsfCodeSample(n);
    end
end

end
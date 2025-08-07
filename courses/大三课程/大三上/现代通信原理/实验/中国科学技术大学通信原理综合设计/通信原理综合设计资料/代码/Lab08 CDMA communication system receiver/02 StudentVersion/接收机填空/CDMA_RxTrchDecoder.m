%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            mfRxTrchDecoder.m
%  Description:         传输信道译码器
%  Reference:           3GPP TS 25.212, 4.2.3 Channel coding
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter
%           out_data	输出经过信道译码后的数据 
%       Input Parameter
%           input_data	输入待译码的数据
%           coder_type  编码器类型，0表示不编码，1表示1/2卷积码，2表示1/3卷积码
%                       3表示Turbo码              
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:           2017-12-12
%       Author:         david.lee
%       Version:        1.0 
%       Modification:   初稿
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [out_data] = CDMA_RxTrchDecoder(input_data, coder_type)

%% 功能实现
switch coder_type
%%%%%%%%%%%%%%% student code %%%%%%%%%%%%%%%%%%%%%%%
    
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 3
        fprintf('error:函数mfRxTrchDecoder的参数coder_type=3暂不支持\n');
    otherwise
        fprintf('error:函数mfRxTrchDecoder的参数coder_type输入错误\n');
end    

end
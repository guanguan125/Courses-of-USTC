%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            mfTxSpreading.m
%  Description:         串并转换、极性变化、扩频、数据复数化
%  Reference:           3GPP TS 25.213, 5.1 Spreading
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter
%           out_data	输出经过扩频的数据 
%       Input Parameter
%           input_data	输入待扩频的数据
%           sf          取值范围4、8、…、512
%           ovsf_No     扩频码号，取值范围0~sf-1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:           2017-12-1
%       Author:         david.lee
%       Version:        1.0 
%       Modification:   初稿
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [out_data] = CDMA_TxSpreading(input_datai,input_dataq, sf, ovsf_No)

%% 变量初始化
input_num = length(input_datai);
ovsf_code = zeros(1, sf);   
out_data = zeros(1, input_num*sf);
%生成OVSF扩频码

%%%%%%%%%%%%%%% student code %%%%%%%%%%%%%%%%%%%%%%%
%生成SF从4~512的全部OVSF扩频码
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
   
    
    
    otherwise
        fprintf('error:函数mfOvsfCodeGenerate的参数sf输入错误\n');  
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%扩频


end
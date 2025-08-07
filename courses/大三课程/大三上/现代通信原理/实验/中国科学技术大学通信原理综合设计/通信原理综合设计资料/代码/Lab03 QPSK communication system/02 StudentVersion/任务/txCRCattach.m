%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            txCRCattach.m
%  Description:         添加CRC校验码
%  Reference:           3GPP TS 25.212, 4.2.1 CRC attachment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter
%           out_data	输出带CRC比特的数据，即在输入比特后添加相应的CRC比特 
%       Input Parameter
%           input_data	输入待添加CRC比特的数据
%           crc_num     待添加的CRC比特数,默认固定为8
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:           2017-12-1
%       Author:         david.lee
%       Version:        1.0 
%       Modification:   初稿
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [out_data] = txCRCattach(input_data, crc_num)

input_num = length(input_data);
%% 变量初始化


%% 功能实现
switch crc_num
    case 8
        %生成多项式 gD = D8+D7+D4+D3+D1+1
     
%%%%%%%%%%%%%%% student code %%%%%%%%%%%%%%%%%%%%%%%
% task: 进行CRC的添加
           





        
    otherwise
        fprintf('error:函数mfTxCRCattach的参数crc_num输入错误\n');
end    

end
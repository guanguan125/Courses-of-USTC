%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            mfRxCRC.m
%  Description:         CRC校验
%  Reference:           3GPP TS 25.212, 4.2.1 CRC attachment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter
%           CRC_flag	为1表示CRC校验正确，为0表示不正确 
%       Input Parameter
%           input_data	输入待添加CRC比特的数据
%           crc_num     待添加的CRC比特数,取值范围24、16、12、8或0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:           2017-12-12
%       Author:         david.lee
%       Version:        1.0 
%       Modification:   初稿
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [CRC_flag] = CDMA_RxCRC(input_data, crc_num)
input_num=length(input_data);
%% 变量初始化
crcBit = zeros(1, crc_num);
regOut = zeros(1, crc_num);         %#ok移位寄存器初始化
oldCRC = zeros(1, crc_num);         %#ok原CRC

%% 功能实现
input_num = input_num - crc_num;
switch crc_num
	case 0
        CRC_flag = 1;
    case 8
        %%%%%%%%%%%%%%% student code %%%%%%%%%%%%%%%%%%%%%%%
        %生成多项式 gD = D8+D7+D4+D3+D1+1
      
        
        
        
    case 12
        
        
        
        
    case 16
        
        %生成多项式 gD = D16+D12+D5+1
        
         
        
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
    case 24
        oldCRC = input_data(1, input_num+1:input_num+crc_num);
         %生成多项式 gD = D24+D23+D6+D5+D1+1
        for num = 1:input_num;
            regOut = crcBit;            %shift bits
            crcBit(24) = xor(regOut(23), xor(regOut(24), input_data(num)));
            crcBit(23) = regOut(22);
            crcBit(22) = regOut(21);
            crcBit(21) = regOut(20);
            crcBit(20) = regOut(19);
            crcBit(19) = regOut(18);
            crcBit(18) = regOut(17);
            crcBit(17) = regOut(16);
            crcBit(16) = regOut(15);	
            crcBit(15) = regOut(14);
            crcBit(14) = regOut(13);
            crcBit(13) = regOut(12);
            crcBit(12) = regOut(11);
            crcBit(11) = regOut(10);
            crcBit(10) = regOut(9);
            crcBit(9)  = regOut(8);
            crcBit(8)  = regOut(7);
            crcBit(7)  = xor(regOut(6), xor(regOut(24), input_data(num)));
            crcBit(6)  = xor(regOut(5), xor(regOut(24), input_data(num)));
            crcBit(5)  = regOut(4);
            crcBit(4)  = regOut(3);
            crcBit(3)  = regOut(2);
            crcBit(2)  = xor(regOut(1), xor(regOut(16), input_data(num)));
            crcBit(1)  = xor(regOut(24), input_data(num)); 
        end 
         if oldCRC == crcBit
            CRC_flag = 1;
            disp('CRC OK!\n');
        else
            CRC_flag = 0;
            disp('CRC err!\n');
        end       
    otherwise
        disp('error:函数mfRxCRC的参数crc_num输入错误\n');
end    

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            txCRCattach.m
%  Description:         ���CRCУ����
%  Reference:           3GPP TS 25.212, 4.2.1 CRC attachment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter
%           out_data	�����CRC���ص����ݣ�����������غ������Ӧ��CRC���� 
%       Input Parameter
%           input_data	��������CRC���ص�����
%           crc_num     ����ӵ�CRC������,Ĭ�Ϲ̶�Ϊ8
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:           2017-12-1
%       Author:         david.lee
%       Version:        1.0 
%       Modification:   ����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [out_data] = txCRCattach(input_data, crc_num)

input_num = length(input_data);
%% ������ʼ��


%% ����ʵ��
switch crc_num
    case 8
        %���ɶ���ʽ gD = D8+D7+D4+D3+D1+1
     
%%%%%%%%%%%%%%% student code %%%%%%%%%%%%%%%%%%%%%%%
% task: ����CRC�����
           





        
    otherwise
        fprintf('error:����mfTxCRCattach�Ĳ���crc_num�������\n');
end    

end
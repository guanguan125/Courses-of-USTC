%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            mfRxTrchDecoder.m
%  Description:         �����ŵ�������
%  Reference:           3GPP TS 25.212, 4.2.3 Channel coding
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter
%           out_data	��������ŵ����������� 
%       Input Parameter
%           input_data	��������������
%           coder_type  ���������ͣ�0��ʾ�����룬1��ʾ1/2����룬2��ʾ1/3�����
%                       3��ʾTurbo��              
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:           2017-12-12
%       Author:         david.lee
%       Version:        1.0 
%       Modification:   ����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [out_data] = CDMA_RxTrchDecoder(input_data, coder_type)

%% ����ʵ��
switch coder_type
%%%%%%%%%%%%%%% student code %%%%%%%%%%%%%%%%%%%%%%%
    
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 3
        fprintf('error:����mfRxTrchDecoder�Ĳ���coder_type=3�ݲ�֧��\n');
    otherwise
        fprintf('error:����mfRxTrchDecoder�Ĳ���coder_type�������\n');
end    

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   FileName      : ASK_DeSync.m
%   Description   : ����֡ͷ��λ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Function List :
%       out_data = ASK_DeSync(input_data,SendSig,UpSampleRate,code_model,Preamble,PreambleLen)
%   Parameter List:       
%       Output Parameter
%           output_data	  ��ASK���ƺ���ź�
%       Input Parameter
%           input_data	  �˲����ź�
%           UpSampleRate  һ����Ԫ������������
%           bitLen            ��Դ����һ֡�ĳ���
%           n                     ����������鳤��
%           crc_num        CRCУ������볤
%           code_model  �ŵ����뷽ʽ   0��������  1����ѭ����
%           Preamble      ͬ����
%           PreambleLen  ͬ����ĳ���
%   History
%       1. Date        : 2022-2-28
%           Author      : LHX
%           Version     : 2.0
%           Modification: �ڶ���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function output_data = ASK_Sync(input_data,UpSampleRate,bitLen,n,crc_num,code_model,Preamble,PreambleLen)
%ͬ����תΪ������ļ���


%�������س��ȼ���


end

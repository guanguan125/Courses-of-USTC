%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  File Name: ASK_Channelcode.m
%  Description: ��������ѭ����ı���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Function List :
%           Channel_Bit = ASK_Channelcode(CRC_Bit,code_model,Gx,n,k)
%  Parameter List:
%      Input Parameter:
%           CRC_Bit:  ����CRC֮��ı�������
%           codemodel:ѡ����뷽ʽ 
%           Gx    ѭ��������ɶ���ʽ��[1,0,1,1]��[1,1,0,1]Ϊ��7,4��ѭ������ѡ����ʽ����1λ�������
%           n       �������������鳤�ȣ�n��k��ѡ��12��8�����ߣ�7��4��
%           k       ������������Ϣλ
%      Output Parameter:
%          Channel_Bit      �ŵ����������
%   History
%       1. Date        : 2022-2-28
%           Author      : LHX
%           Version     : 2.0
%           Modification: �ڶ���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Channel_Bit = ASK_Channelcode(CRC_Bit,code_model,Gx,n,k)
      %%%%%%%%%%%%%%% student code %%%%%%%%%%%%%%%%%%%%%%%      

    
    

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
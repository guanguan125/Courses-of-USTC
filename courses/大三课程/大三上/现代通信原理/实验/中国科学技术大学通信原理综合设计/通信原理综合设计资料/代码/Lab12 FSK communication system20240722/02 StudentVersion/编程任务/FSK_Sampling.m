%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName: FSK_Sampling.m
%  Description: ����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Function List :
%         RecvSymbolSampled = FSK_Sampling(pos,UpSampleRate,MsgLen,RecvFskDemod,PreambleLen)
%  Parameter List:
%     Output Parameter:
%        RecvSymbolSampled:      ����������
%     Input Parameter:
%        pos                                      ֡ͷ��λ��
%        UpSampleRate                  һ����Ԫ�����ڵ�������
%        MsgLen                              ��Դ���س���
%        RecvFskDemod                ���ȱȽϺ��ź�
%        PreambleLen                     ͬ���볤��
%   History
%       1. Date        : 2022-2-14
%           Author      : LHX
%           Version     : 2.0
%           Modification: �ڶ���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function RecvSymbolSampled = FSK_Sampling(pos,UpSampleRate,MsgLen,RecvFskDemod,PreambleLen)

%%%%������գ�
	                                % ��MsgLen�����ŵ���������ݳ���
                                    % ����RecvFskDemod���γ���֡�ź�

                                  % ������δȥͬ���룩��%pos��֡ͷ��λ�ã�ÿ��UpSampleRate�����Ƚ��г���
%%%%������գ�
end
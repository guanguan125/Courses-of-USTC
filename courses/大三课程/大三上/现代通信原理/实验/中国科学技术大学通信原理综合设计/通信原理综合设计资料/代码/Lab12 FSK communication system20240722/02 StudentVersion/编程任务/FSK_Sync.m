%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FlieName: FSK_Sync.m
%  Description: ����ͬ����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Function List :
%         [RecvCorr,pos] = FSK_Sync(RecvFskDemod,UpSampleRate,Preamble)
%  Parameter List: 
%      Output Parameter
%         RecvCorr                  ͬ������ؽ��
%         pos                            ���ֵ��λ��
%      Input Parameter
%         RecvFskDemod      ���ȱȽϺ���ź�
%         UpSampleRate       һ����Ԫ�����ڵ�������
%         Preamble                 ͬ����
%   History
%       1. Date        : 2022-1-14
%           Author      : LHX
%           Version     : 2.0
%           Modification: �ڶ���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [RecvCorr,pos] = FSK_Sync(RecvFskDemod,UpSampleRate,Preamble)

 %%%%������գ�
                                  %��ͬ�����Ϊ������(1���1��0���-1)
%%%%������գ�
                                  %�����������
 
	                                   % ͬ������ؽ��RecvCorr��һ������RecvCorr���ÿ��ֵ������RecvCorr�����ֵ
%%%%������գ�

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:FSK_Convcode.m
%  Description: �������
%   Function List :
%            [output_data] = FSK_Convcode(CoderConstraint,input_data,Gx)
%  Parameter List:
%     Output Patameter
%            output_data         ��������ı�������
%     Input Parameter
%           CoderConstraint  ������Լ������
%           input_data             ���ɵ������������
%           Gx                          ���������ɾ���
%   History
%       1. Date        : 2022-1-10
%           Author      : LHX
%           Version     : 2.0
%           Modification: �ڶ���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [out_data] = FSK_Convcode(K,input_data,Gx)
%%%%������գ�
                       %���ú���poly2trellis����������ʽת����MATLAB��trellis������ʽ,
                       %ʵ���������ɶ���ʽ����Ϊ[171,133], �˽���171-������111 1001���˽���133-������101 1011.

                       % ��β����, ����Ϣ�Ľ�β��� Լ�����ȼ�1����

                       %  ���ÿ⺯�������� ���ɾ����  
%%%%������գ�
end
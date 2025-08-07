%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            MatchFiltering
%  Description:         ƥ���˲�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter
%           outData     �˲�������
%       Input Parameter
%           inputData	��ƥ���˲�����
%           sample_rate �ϲ����ʣ�ÿ������sample_rate������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:           2021-01-06
%       Author:         LiuDong
%       Version:        1.0 
%       Modification:   ����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ out_data ] = MatchFiltering( input_data,sample_rate )

%% �������� �˲���
% Rolloff = 1;  %����ϵ��
% FilterSymbolLen = 10; %�˲�������
% filterDef=fdesign.pulseshaping(sample_rate,'Square Root Raised Cosine','Nsym,Beta',FilterSymbolLen,Rolloff);
% myFilter = design(filterDef);
% out_data = conv(input_data,myFilter.Numerator,'same');
                %�˲���ϵ��
                Beta = 0.2;    % Filter rolloff factor
                N = 80;        % Filter order (must be even). The length of the impulse response is N+1.
                %���ɸ������ҹ����˲���
                h  = fdesign.pulseshaping(sample_rate,'Square Root Raised Cosine','N,Beta',N,Beta);  
                Hd = design(h);
                rrcFilter = Hd.Numerator;
                %�˲�.
                out_data = upfirdn(input_data, rrcFilter);

end


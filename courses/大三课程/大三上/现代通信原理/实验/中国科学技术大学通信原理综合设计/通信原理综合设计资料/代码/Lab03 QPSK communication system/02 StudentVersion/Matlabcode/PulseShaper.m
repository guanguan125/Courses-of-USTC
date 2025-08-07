%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            PulseShaper.m
%  Description:         �������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter
%           out_data	������� 
%       Input Parameter
%           input_data      ������ϲ�������
%           sample_rate     ÿ���������������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% History
%    1. Date:           2018-06-20
%       Author:         LiuDong
%       Version:        1.0 
% Remarks
%     ����ͨ���У�ʵ�ʷ�������ź��Ǹ�����ɢ��ֵ����ͨ�������˲�����ĳ�����������
%     ƥ���˲�����Ϊ��ʹ���ڳ���ʱ���������󡣵����˳����˲����ø��������˲���
%     ���ն�ͬ���ø��������˲���ƥ���˲�ʱ�����ܹ�ʹ�ó���ʱ���������ߣ����ܹ��ڴ����ŵ������������š�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [out_data] = PulseShaper (input_data, sample_rate)

% %�������� �˲���
% Rolloff=1;  % ����ϵ����Ĭ�Ϲ̶�
% FilterSymbolLen = 10;    % �˲�������
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
            %��ֵ���˲�.
            out_data = upfirdn(input_data, rrcFilter);

end
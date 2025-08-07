%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            mfRxSCSearch.m
%  Description:         ��ĳһ����������Ѱ������
%  Reference: 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter
%           findscNo    �ҵ��������
%           findsc      �ҵ�������
%                   
%       Input Parameter
%           rxData      ��������
%           sampleRate  ������
%           scGroupNo   �������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:           2017-12-1
%       Author:         david.lee
%       Version:        1.0 
%       Modification:   ����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [findscNo,findsc] = CDMA_RxSCSearch(rxData,sampleRate,scGroupNo)   



%%
%%�������������x���к�y����
%x sequence
x = zeros(1, 177663);
x(1) = 1;                                                        %��ֵΪx (0)=1, x(1)= x(2)=...= x (16)= x (17)=0
for i = 1:177645                                                 %Sn(i) = Zn(i) + j*Zn((i+131072)ģ (218-1)), i=0,1,��,38399,���i=177645���㹻��
%%%%%%%%%%%%%%% student code %%%%%%%%%%%%%%%%%%%%%%%
    x(i+18) =                                  %�ݹ鶨��Ϊx(i+18) =x(i+7) + x(i)ģ 2, i=0,��,2^18-20

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%y sequence
y = ones(1, 169472);                                              %��ֵΪy(0)=y(1)= �� =y(16)= y(17)=1
for i = 1:169454
%%%%%%%%%%%%%%% student code %%%%%%%%%%%%%%%%%%%%%%%
    y(i+18) =          %�ݹ鶨��Ϊy(i+18) = y(i+10)+y(i+7)+y(i+5)+y(i)  ģ 2, i=0,��, 2^18-20

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%�����������ͬʱ�������
z = zeros(8, 38400);
z1 = zeros(8, 38400);
s = zeros(8, 38400);
sc = zeros(8, 38400*sampleRate);
scCorrelation = zeros(1, 8);
for scNo = 1:8
    n = 16*8*(scGroupNo-1) + 16*(scNo-1);

    %z(n) sequence
    for i = 1:38400                          %1��38400������                    
        z(scNo, i) = xor(x(i+n),y(i));                    %zn(i) = x((i+n) modulo (2^18 - 1)) + y(i) modulo 2, i=0,��, 2^18-2 
        z1(scNo, i) = xor(x(i+131072+n),y(i+131072));            %131073��169472������
        if z(scNo, i) == 0
            z(scNo, i) = 1;
        else
            z(scNo, i) = -1;
        end
        if z1(scNo, i) == 0
            z1(scNo, i) = 1;
        else
            z1(scNo, i) = -1;
        end
        s(scNo, i) = z(scNo, i)+1i*z1(scNo, i);                     
        for m = 1:sampleRate
            sc(scNo, (i-1)*sampleRate+m) = s(scNo, i);                %�������ʽ����ظ�
        end
    end
    temp = rxData(256*sampleRate+1:2560*sampleRate);
    %�������
     scCorrelation(scNo) = sum(temp./sc(scNo, 256*sampleRate+1:2560*sampleRate));
end
%%
%%Ѱ������
%%%%%%%%%%%%%%% student code %%%%%%%%%%%%%%%%%%%%%%%
modScCorr =                     %�������ȡ����ֵ
findscNo =                      %ȡ�������ȡ����ֵ�������ֵ����λ��

findsc =                          %��׼��WCDMϵͳһ֡��15��ʱ϶����ϵͳֻ����ǰ6��ʱ϶�����ֻȡ38400�������ǰ2560*6��
                                 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
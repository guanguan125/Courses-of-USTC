%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            mfRxSCSearch.m
%  Description:         在某一个扰码组内寻找扰码
%  Reference: 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter
%           findscNo    找到的扰码号
%           findsc      找到的扰码
%                   
%       Input Parameter
%           rxData      输入数据
%           sampleRate  采样率
%           scGroupNo   扰码组号
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:           2017-12-1
%       Author:         david.lee
%       Version:        1.0 
%       Modification:   初稿
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [findscNo,findsc] = CDMA_RxSCSearch(rxData,sampleRate,scGroupNo)   



%%
%%生成下行扰码的x序列和y序列
%x sequence
x = zeros(1, 177663);
x(1) = 1;                                                        %初值为x (0)=1, x(1)= x(2)=...= x (16)= x (17)=0
for i = 1:177645                                                 %Sn(i) = Zn(i) + j*Zn((i+131072)模 (218-1)), i=0,1,…,38399,因此i=177645就足够了
%%%%%%%%%%%%%%% student code %%%%%%%%%%%%%%%%%%%%%%%
    x(i+18) =                                  %递归定义为x(i+18) =x(i+7) + x(i)模 2, i=0,…,2^18-20

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%y sequence
y = ones(1, 169472);                                              %初值为y(0)=y(1)= … =y(16)= y(17)=1
for i = 1:169454
%%%%%%%%%%%%%%% student code %%%%%%%%%%%%%%%%%%%%%%%
    y(i+18) =          %递归定义为y(i+18) = y(i+10)+y(i+7)+y(i+5)+y(i)  模 2, i=0,…, 2^18-20

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%在生成扰码的同时进行相关
z = zeros(8, 38400);
z1 = zeros(8, 38400);
s = zeros(8, 38400);
sc = zeros(8, 38400*sampleRate);
scCorrelation = zeros(1, 8);
for scNo = 1:8
    n = 16*8*(scGroupNo-1) + 16*(scNo-1);

    %z(n) sequence
    for i = 1:38400                          %1到38400个码字                    
        z(scNo, i) = xor(x(i+n),y(i));                    %zn(i) = x((i+n) modulo (2^18 - 1)) + y(i) modulo 2, i=0,…, 2^18-2 
        z1(scNo, i) = xor(x(i+131072+n),y(i+131072));            %131073到169472个码字
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
            sc(scNo, (i-1)*sampleRate+m) = s(scNo, i);                %按采样率进行重复
        end
    end
    temp = rxData(256*sampleRate+1:2560*sampleRate);
    %扰码相关
     scCorrelation(scNo) = sum(temp./sc(scNo, 256*sampleRate+1:2560*sampleRate));
end
%%
%%寻找扰码
%%%%%%%%%%%%%%% student code %%%%%%%%%%%%%%%%%%%%%%%
modScCorr =                     %扰码相关取绝对值
findscNo =                      %取扰码相关取绝对值数据最大值所在位置

findsc =                          %标准的WCDM系统一帧有15个时隙，本系统只保留前6个时隙，因此只取38400个扰码的前2560*6个
                                 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
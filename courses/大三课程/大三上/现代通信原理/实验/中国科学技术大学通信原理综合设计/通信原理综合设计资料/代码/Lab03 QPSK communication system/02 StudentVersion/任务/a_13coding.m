%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            a_13coding.m
%  Description:         PCM 13折线语音编码
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter
%           a13_moddata 编码后的bit流数据
%       Input Parameter
%           x           输入语音信号抽样后的数据
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:           2018-5-17
%       Author:         tony liu
%       Version:        1.0 
%       Modification:   初稿
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  [ a13_moddata ] = a_13coding( x )
n=length(x);
a13_moddata=zeros(1,n*8); % 输出数据初始化，编码使用的是13折线编码，一个样点使用8bit编码
for m=1:n
    Is=x(1,m);
    if Is>1||Is<-1,error('input must within [-1,1]'),end
    Is=round(Is*2048);  % Is 为 输入数据第m样点，放大2048，按照非均匀量化规则量化编码
    C=zeros(1,8);  % 第m样点编码后bit 初始化 
    if Is>0
        C(1)=1 ;  %判断抽样值的正负  
    end
    
    % the polarity determins C(1)
    abIs=abs(Is);   %取绝对值 ， 极性由第一位编码确定，数值大小 由后七位编码确定
%%%%以下填空：
%产生C(2:8)，即3位段落码和4位段内码。
   







%%%%以上填空：

    
    end
end
%%%%%%%%程序框架END%%%%%%%%%%%%%
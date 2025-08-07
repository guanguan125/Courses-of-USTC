%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            addcp.m
%  Description:         加CP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter
%           output	 加CP后数据
%       Input Parameter
%           input	  调制后数据        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:          2010-06-20
%       Author:         zzk
%       Version:        1.0 
%       Modification:   初稿
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function output = addcp(input)
symnum =14;  %一个子帧为14个符号
u = 29; %ZC的根序列
N = 157; %第一个符号的CP为160，,10以内的质数为157
start =1;
output =zeros(1,30720);
pssdata = zeros(1,N);

for ii = 1:symnum
    if((1==ii)|| (8==ii))
       %符号1和符号8添加CP，CP长度为160
       tempsymdata = input(1,(ii-1)*2048+1:ii*2048);
       tempcpdata = tempsymdata(1,1889:2048);
       tail = start+2048+160 -1;
       output(1,start:tail) = [tempcpdata,tempsymdata];
       start = tail +1;     
    else
       %其它符号添加CP，CP长度为144
       tempsymdata = input(1,(ii-1)*2048+1:ii*2048);
       tempcpdata = tempsymdata(1,1905:2048);
       tail = start+2048+144 -1;
       output(1,start:tail) = [tempcpdata,tempsymdata];
       start = tail +1;   
       
    end
end
% output = output*30;

% %生成同步码
% for n=1:N
%     pssdata(n) = exp(-1j*pi*u*(n-1)*n/N);
% end
% % ifftpssdata = ifft(pssdata);
% pssdata = pssdata/120;
% 
% output(1,1:N) = pssdata;
    
end
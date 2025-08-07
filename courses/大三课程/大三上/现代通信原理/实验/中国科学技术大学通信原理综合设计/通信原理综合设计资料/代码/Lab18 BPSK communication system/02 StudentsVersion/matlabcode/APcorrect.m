%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            APcorrect.m
%  Description:         信道估计与信道均衡
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter
%           outData     调制后数据
%       Input Parameter
%           inputData	同步后的数据
%           c                  同步码
%           sample_rate  一个码元周期内的样点数
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:           2018-05-25
%       Author:         LiuDong
%       Version:        1.0 
%       Modification:   初稿
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function outData=APcorrect(inputData,c,EN_AP)

% %由同步码生成参考信号


%%

rx_c_mod_data=inputData(1,1:30);
len_rx_c_mod=length(rx_c_mod_data);
 if EN_AP==1
c_mod_data= -c*2+1;   %映射，0 1映射为-1 1
ang=angle(c_mod_data)-angle(rx_c_mod_data);%计算相位偏转

len_data=length(inputData(1,len_rx_c_mod+1:end));  %截取参考信号后的所有数据
%相位纠正过程
ref_ang=zeros(1,len_data);
if len_data<len_rx_c_mod           %判断截取参考信号后的数据长度与参考信号长度
    n=floor(len_rx_c_mod/len_data);     
    for m=1:len_data
        ref_ang(m)=ang(m*n);            %计算每个信号的偏转值
    end
elseif len_data>len_rx_c_mod  
    n=len_data/len_rx_c_mod;
    for m=1:len_data
        ref_ang(m)=ang(ceil(m/n));     %计算每个信号的偏转值
    end
end
ref_A=sqrt(2)/(sum(abs(rx_c_mod_data))/10);     %计算系数
outData=inputData(1,len_rx_c_mod+1:end).*exp(1i*ref_ang)*ref_A;%相位纠正
 else
    outData= inputData(1,len_rx_c_mod+1:end);
 end

end
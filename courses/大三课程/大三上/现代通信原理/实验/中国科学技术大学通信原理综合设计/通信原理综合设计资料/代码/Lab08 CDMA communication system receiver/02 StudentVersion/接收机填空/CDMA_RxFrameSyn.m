%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            mfRxFrameSyn.m
%  Description:         通过对连续4个时隙的前256chips进行SSC相关，获得扰码组号和时隙号
%  Reference:           3GPP TS 25.211, 5.3.3.5 Synchronisation Channel (SCH)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter
%           search_flag     相关峰是否明显,0表示未搜索到相关峰，1表示搜索到相关峰
%           group_No        辅同步码组号，也即扰码组号
%           timeslot_No     输入数据第一个时隙的时隙号  
%           rx_data         一个完整帧数据
%       Input Parameter
%           input_data      输入数据
%           sample_rate     采样率
%           timeslot_star   输入数据第一个时隙开始的点数
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:           2017-12-1
%       Author:         david.lee
%       Version:        1.0 
%       Modification:   初稿
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [search_flag, group_No, timeslot_No,rx_data] = CDMA_RxFrameSyn(input_data, sample_rate, timeslot_star)

%% 变量初始化
% Allocation of SSCs for secondary SCH
                                                                                
% Group 63	9	12	10	15	13	14	9	14	15	11	11	13	12	16	10
Group=[ 
    1     1     2     8     9    10    1     1     2      8     9    10    
    1     1     5    16     7     3    1     1     5     16     7     3    
    1     2     1    15     5     5    1     2     1     15     5     5    
    1     2     3     1     8     6    1     2     3      1     8     6    
    1     2    16     6     6    11    1     2    16      6     6    11    
    1     3     4     7     4     1    1     3     4      7     4     1    
    1     4    11     3     4    10    1     4    11      3     4    10    
    1     5     6     6    14     9    1     5     6      6    14     9    
    1     6    10    10     4    11    1     6    10     10     4    11    
    1     6    13     2    14     2    1     6    13      2    14     2    
    1     7     8     5     7     2    1     7     8      5     7     2    
    1     7    10     9    16     7    1     7    10      9    16     7    
    1     8    12     9     9     4    1     8    12      9     9     4    
    1     8    14    10    14     1    1     8    14     10    14     1    
    1     9     2    15    15    16    1     9     2     15    15    16    
    1     9    15     6    16     2    1     9    15      6    16     2    
    1    10     9    11    15     7    1    10     9     11    15     7    
    1    11    14     4    13     2    1    11    14      4    13     2    
    1    12    12    13    14     7    1    12    12     13    14     7    
    1    12    15     5     4    14    1    12    15      5     4    14    
    1    15     4     3     7     6    1    15     4      3     7     6    
    1    16     3    12    11     9    1    16     3     12    11     9    
    2     2     5    10    16    11    2     2     5     10    16    11    
    2     2    12     3    15     5    2     2    12      3    15     5    
    2     3     6    16    12    16    2     3     6     16    12    16    
    2     3     8     2     9    15    2     3     8      2     9    15    
    2     4     7     9     5     4    2     4     7      9     5     4    
    2     4    13    12    12     7    2     4    13     12    12     7    
    2     5     9     9     3    12    2     5     9      9     3    12    
    2     5    11     7     2    11    2     5    11      7     2    11    
    2     6     2    13     3     3    2     6     2     13     3     3    
    2     6     9     7     7    16    2     6     9      7     7    16    
    2     7    12    15     2    12    2     7    12     15     2    12    
    2     7    14    16     5     9    2     7    14     16     5     9    
    2     8     5    12     5     2    2     8     5     12     5     2    
    2     9    13     4     2    13    2     9    13      4     2    13    
    2    10     3     2    13    16    2    10     3      2    13    16    
    2    11    15     3    11     6    2    11    15      3    11     6    
    2    16     4     5    16    14    2    16     4      5    16    14    
    3     3     4     6    11    12    3     3     4      6    11    12    
    3     3     6     5    16     9    3     3     6      5    16     9    
    3     4     5    14     4     6    3     4     5     14     4     6    
    3     4     9    16    10     4    3     4     9     16    10     4    
    3     4    16    10     5    10    3     4    16     10     5    10    
    3     5    12    11    14     5    3     5    12     11    14     5    
    3     6     4    10     6     5    3     6     4     10     6     5    
    3     7     8     8    16    11    3     7     8      8    16    11    
    3     7    16    11     4    15    3     7    16     11     4    15    
    3     8     7    15     4     8    3     8     7     15     4     8    
    3     8    15     4    16     4    3     8    15      4    16     4    
    3    10    10    15    16     5    3    10    10     15    16     5    
    3    13    11     5     4    12    3    13    11      5     4    12    
    3    14     7     9    14    10    3    14     7      9    14    10    
    5     5     8    14    16    13    5     5     8     14    16    13    
    5     6    11     7    10     8    5     6    11      7    10     8    
    5     6    13     8    13     5    5     6    13      8    13     5    
    5     7     9    10     7    11    5     7     9     10     7    11    
    5     9     6     8    10     9    5     9     6      8    10     9    
    5    10    10    12     8    11    5    10    10     12     8    11    
    5    10    12     6     5    12    5    10    12      6     5    12    
    5    13    15    15    14     8    5    13    15     15    14     8    
    9    10    13    10    11    15    9    10    13     10    11    15    
    9    11    12    15    12     9    9    11    12     15    12     9    
    9    12    10    15    13    14    9    12    10     15    13    14    
];

group_No=0;

%% 功能实现
%生成辅同步码
%z sequence
%%%%%%%%%%%%%%% student code %%%%%%%%%%%%%%%%%%%%%%%
x =                  %意义同3GPP TS 25.213 5.2.3.1中x
b =                  %意义同3GPP TS 25.213 5.2.3.1中b
z =                  %意义同3GPP TS 25.213 5.2.3.1中z
%Hadamard sequences
H0=1;




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
m=[0,16,32,48,64,80,96,112,128,144,160,176,192,208,224,240];  %意义同3GPP TS 25.213 5.2.3.1中m = 16×( k – 1) 
h=zeros(16,256);
for n=1:16
    h(n,1:256)=H8(m(n)+1,1:256);
end   
%Secondary Synchronization Codes
SSC=zeros(16,256);
for n=1:16
    SSC(n,1:256)=(1+1i)*z.*h(n,1:256);
end
SSC_sample=zeros(16,256*sample_rate);
for n=1:16
    for code_num=1:256
        for sample_num=1:sample_rate
            SSC_sample(n,(code_num-1)*sample_rate+sample_num)=SSC(n,code_num);
        end
    end
end

%辅同步码相关
timeslot_num=2560*sample_rate;
SCH_num=256*sample_rate;
SSC_No=zeros(1,8);
for num=1:6
    star=timeslot_star+(num-1)*timeslot_num;
    Rx_data=input_data(star:star+SCH_num-1);
    SSC_correlation=zeros(1,16);
    %%%%%%%%%%%%%%% student code %%%%%%%%%%%%%%%%%%%%%%%
    for SSC_num=1:16
        for n=1:SCH_num
            SSC_correlation(SSC_num)=
        end
    end

    mod_SSC_corr=                     ;%SSC_correlation取绝对值
    SSC_No(num)=                       %mod_SSC_corr最大值所在位置
    
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

%根据相关值确认辅同步码组号及第一个时隙时隙号
for m=1:64
    for n=0:5
        max_val=0;
        for nn=1:6
            if SSC_No(nn)==Group(m,n+nn)
                max_val=max_val+1;
                if max_val>5    %6个时隙中有5个的同步码一致即认为找到了帧同步
                    group_No=m;
                    timeslot_No=n+1;
                    search_flag= 1;
                    break;
                end
            end
        end
    end
end
if group_No==0 
    search_flag=0;
    timeslot_No=0;
else
    search_flag=1;
end

firstTimeslotNo=timeslot_No;

 

if search_flag == 1
    %%%%%%%%%%%%%%% student code %%%%%%%%%%%%%%%%%%%%%%%
%%如果检索到一个同步的时隙，在帧中的时隙号为1，则时隙头也是帧头
if firstTimeslotNo == 1
    frameStart =                   %时隙开始位置=帧开始位置
else
    %否则，根据在帧中的时隙号进行移位，取一个完整帧
    frameStart =            %根据在帧中的时隙号进行移位，取一个完整帧
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rx_data = input_data(1, frameStart: frameStart+2560*6*sample_rate-1);
else
    rx_data = 0;
end




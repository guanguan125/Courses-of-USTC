%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            mfRxTimeslotSyn.m
%  Description:         通过PSC滑动相关获得时隙同步
%  Reference:           3GPP TS 25.211, 5.3.3.5 Synchronisation Channel (SCH)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter
%           search_flag     相关峰是否明显,0表示未搜索到相关峰，1表示搜索到相关峰
%           timeslot_star	时隙开始的点数
%           mod_PSC_corr    主同步码相关结果，用于绘制相关峰图像          
%       Input Parameter
%           input_data      输入数据
%           sample_rate     采样率
%           corr_length     滑动相关长度
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:           2017-12-1
%       Author:         david.lee
%       Version:        1.0 
%       Modification:   初稿
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [search_flag, timeslot_star, mod_PSC_corr] = CDMA_RxTimeslotSyn(input_data,sample_rate,corr_length)   

%% 功能实现
%生成主同步码
%%%%%%%%%%%%%%% student code %%%%%%%%%%%%%%%%%%%%%%%
a=                    %意义同3GPP TS 25.213 5.2.2中a
PSC=                  %%意义同3GPP TS 25.213 5.2.3.1中Cpsc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PSC_data=256*sample_rate;
PSC_sample=zeros(1,PSC_data);
for code_num=1:256
    for sample_num=1:sample_rate
        PSC_sample((code_num-1)*sample_rate+sample_num)=PSC(code_num);
    end
end

%主同步码相关
PSC_correlation=zeros(1,corr_length);
%%%%%%%%%%%%%%% student code %%%%%%%%%%%%%%%%%%%%%%%
for data_num=1:corr_length;
    for n=1:PSC_data
        PSC_correlation(data_num)=
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mod_PSC_corr=abs(PSC_correlation);

%判断相关峰是否明显
%%%%%%%%%%%%%%% student code %%%%%%%%%%%%%%%%%%%%%%%
             %取mod_PSC_corr最大值所在位置

             
             
%mod_PSC_corr最大值与mod_PSC_corr减去mod_PSC_corr最大值后的平均值的两倍进行比较，判断是否搜索到相关峰


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
end

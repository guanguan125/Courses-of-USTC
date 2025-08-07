%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            mfRxTimeslotSyn.m
%  Description:         ͨ��PSC������ػ��ʱ϶ͬ��
%  Reference:           3GPP TS 25.211, 5.3.3.5 Synchronisation Channel (SCH)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter
%           search_flag     ��ط��Ƿ�����,0��ʾδ��������ط壬1��ʾ��������ط�
%           timeslot_star	ʱ϶��ʼ�ĵ���
%           mod_PSC_corr    ��ͬ������ؽ�������ڻ�����ط�ͼ��          
%       Input Parameter
%           input_data      ��������
%           sample_rate     ������
%           corr_length     ������س���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:           2017-12-1
%       Author:         david.lee
%       Version:        1.0 
%       Modification:   ����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [search_flag, timeslot_star, mod_PSC_corr] = CDMA_RxTimeslotSyn(input_data,sample_rate,corr_length)   

%% ����ʵ��
%������ͬ����
%%%%%%%%%%%%%%% student code %%%%%%%%%%%%%%%%%%%%%%%
a=                    %����ͬ3GPP TS 25.213 5.2.2��a
PSC=                  %%����ͬ3GPP TS 25.213 5.2.3.1��Cpsc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PSC_data=256*sample_rate;
PSC_sample=zeros(1,PSC_data);
for code_num=1:256
    for sample_num=1:sample_rate
        PSC_sample((code_num-1)*sample_rate+sample_num)=PSC(code_num);
    end
end

%��ͬ�������
PSC_correlation=zeros(1,corr_length);
%%%%%%%%%%%%%%% student code %%%%%%%%%%%%%%%%%%%%%%%
for data_num=1:corr_length;
    for n=1:PSC_data
        PSC_correlation(data_num)=
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mod_PSC_corr=abs(PSC_correlation);

%�ж���ط��Ƿ�����
%%%%%%%%%%%%%%% student code %%%%%%%%%%%%%%%%%%%%%%%
             %ȡmod_PSC_corr���ֵ����λ��

             
             
%mod_PSC_corr���ֵ��mod_PSC_corr��ȥmod_PSC_corr���ֵ���ƽ��ֵ���������бȽϣ��ж��Ƿ���������ط�


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
end

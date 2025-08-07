function [ rxmodify,timestart,corrdata] = synchronization ( rxData,prb_num,rbstart,UL_subframe_num,cellid)
%同步

% 同步数据计算
pssdata = GenPss(prb_num,rbstart,UL_subframe_num,cellid);

% 同步 （相关峰计算） 自适应滤波
pssdata_len=2048;% 同步码长度 1024~2048

pssdata=pssdata(1:pssdata_len);

% corrlen=12969 ;% 同步码相关长度1024~ 29696  12969 30576 
% corrlen= 12737;% 6737+6000
corrlen= 29696;
[searchflag,timestart,corrdata] = LTECorrFun(rxData,corrlen,pssdata);%自适应滤波
timestart;
% timestart =6339;

%根据测试结果进行组帧
rxmodify = LTEFram(rxData,timestart);

end


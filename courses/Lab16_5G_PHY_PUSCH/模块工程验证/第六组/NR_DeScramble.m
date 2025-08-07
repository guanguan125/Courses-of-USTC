%% 解扰
%% 包含解扰、解码块级联
function rm_data = NR_DeScramble(demoddata,vrb_num,qm,ue_index,cellid,C,rm_len)
%% 解扰
% descrambledata  = DeScramble_5G(demoddata,prb_num,Qm,ue_index,cellid);
% 输出参数：  
% rm_data：解码块级联后的输出数据  
% 输入参数：  
% demoddata：解调后的输出数据  
% vrb_num：UE的RB个数 
% Qm：调制方式。2：QPSK  4:16QAM  6:64QAM  8:256QAM 
% ue_index：UE的索引 
% cellid：小区ID 
% C ：传输块分割的码块数 
% rm_len：速率匹配后的长度
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% student code %%%%%%%%%%%%%%%%%%%%%%%%%%
out = DeScramble_5G(demoddata,vrb_num,qm,ue_index,cellid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% end %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 解码块级联
E = rm_len;
descrambledata = out;
% deccbc_data = DeCdblkConcate_5G(C,descrambledata,rm_len);
rm_data = zeros(C,E(C));
temp = 1;
for r = 1:C
    rm_data(r,1:E(r))= descrambledata(temp:(temp + E(r) - 1));
    temp = temp + E(r);
end
end
%% 解扰
%% 包含解扰、解码块级联
function rm_data = NR_DeScramble(demoddata,vrb_num,qm,ue_index,cellid,C,rm_len)

%% 解扰
% descrambledata  = DeScramble_5G(demoddata,prb_num,Qm,ue_index,cellid);
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% student code %%%%%%%%%%%%%%%%%%%%%%%%%%


 
 
 
 

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
%% ÀŸ¬ ∆•≈‰
function [ rmdata,rmlen ] = NR_RateMatch(coded_data,I_LBRM,vnum,Qm,C,Nsym_slot,DMRS_symbol,prb_num,rvid,LDPC_base_graph,Zc )

G = 12*prb_num*(Nsym_slot-DMRS_symbol)*Qm;
Er_low = vnum*Qm*floor(G/(vnum*Qm*C));
Er_high = vnum*Qm*ceil(G/(vnum*Qm*C));
rmdata = zeros(C,Er_high);
for k=1:C
    if(C == k)
      [rmdata(k,1:Er_high),rmlen(k)] =  RateMatchFun_5G(coded_data(k,:),I_LBRM,vnum,Qm,C,Nsym_slot,DMRS_symbol,prb_num,rvid,LDPC_base_graph,Zc,k);
    else
      [rmdata(k,1:Er_low),rmlen(k)] = RateMatchFun_5G(coded_data(k,:),I_LBRM,vnum,Qm,C,Nsym_slot,DMRS_symbol,prb_num,rvid,LDPC_base_graph,Zc,k);  
    end
    
end

end


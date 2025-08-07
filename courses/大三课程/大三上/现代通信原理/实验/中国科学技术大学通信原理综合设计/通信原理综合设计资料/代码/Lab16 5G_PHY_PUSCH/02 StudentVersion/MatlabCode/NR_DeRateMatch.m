function out = NR_DeRateMatch( deccbc_data,vnum,Qm,C,Nsym_slot,DMRS_symbol,prb_num,rvid,LDPC_base_graph,Zc,null_pos,coded_data,EN_LDPC)

for k=1:C
    out(k,:) =  DeRateMatch_5G(deccbc_data(k,:),vnum,Qm,C,Nsym_slot,DMRS_symbol,prb_num,rvid,LDPC_base_graph,Zc,null_pos,coded_data,k,EN_LDPC);
end

end
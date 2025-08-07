function  out = NR_LDPC_Decode_opti(dermdata,C,Z_c,EN_LDPC,cdblkseg_data,LDPC_base_graph)

[coded_data,H] = NR_LDPC_Encode_opt(cdblkseg_data,LDPC_base_graph,C,EN_LDPC);
for k =1:C
    if(EN_LDPC)
       inputdecode = dermdata(k,:)';       
       ldpc_dec = comm.LDPCDecoder(H);
       dermdata_extended = [zeros(2*Z_c, 1); inputdecode];
       decodeout = step(ldpc_dec, dermdata_extended);
       out(k,:) = decodeout';
    else
        inputdata = dermdata(k,:);
        decodedata = inputdata(1,1:22*Z_c);
         out(k,:) = decodedata;
    end
end
out=double(out);
end
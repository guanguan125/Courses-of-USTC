%% LDPC±àÂë
function [coded_data,H] = NR_LDPC_Encode_opt(cdblkseg_data,LDPC_base_graph,C,EN_LDPC)

out=zeros(C,3*length(cdblkseg_data(1,:)));
for k =1:C
    codeinput = cdblkseg_data(k,:)';
    if(EN_LDPC==1)
        [codeout,H,Z_c,encoded_bits_original] = ldpc_encode_optimized(codeinput,LDPC_base_graph);
%         codeout=uint8(codeout);
%         H=uint8(H);
        
        out(k,:) = codeout';
    else
        len =length(codeinput);
        tempcodeout = zeros(1,3*len);
        tempcodeout(1,1:len) = codeinput;
        out(k,:) = tempcodeout;
        H = 0;
    end
     
  
end

coded_data=double(out);
end
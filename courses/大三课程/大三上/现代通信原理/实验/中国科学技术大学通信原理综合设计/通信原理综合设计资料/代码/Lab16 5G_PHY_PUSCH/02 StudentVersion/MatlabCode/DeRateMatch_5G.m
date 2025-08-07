function out = DeRateMatch_5G( deiw_data,vnum,Qm,C,Nsym_slot,DMRS_symbol,prb_num,rvid,LDPC_base_graph,Zc,null_pos,coded_data,index,EN_LDPC)

%bit选择功能
KTable=[0,0;
        17,13;
        33,25;
        56,43];
% if(0==I_LBRM)
%     Ncb = length(Info_data);
% else
%     Nref = length(Info_data);
%     Ncb = min(length(Info_data),Nref);
% end
Ncb = 66*Zc; %解速率匹配后的长度
% if(6144<K_p)
%     Ncb = (K_p+8)*3;
% else
%     Ncb = (K_p+4)*3;
% end

%记录打掉的位置
dicbuffer = zeros(1,Ncb);
G = 12*prb_num*(Nsym_slot-DMRS_symbol)*Qm;
% Er = vnum*Qm*floor(G/(vnum*Qm*C));

Gp = G/(vnum*Qm);
gamma=mod(Gp,C);

if(index<=C-gamma)
  Er = vnum*Qm*floor(G/(vnum*Qm*C));
else
  Er = vnum*Qm*ceil(G/(vnum*Qm*C));
end

%解bit交织
% symnum = Er/Qm;
% for j = 1:Qm
%     for i = 1:symnum
%         tempdata((i-1)+(j-1)*symnum+1) = deccbc_data((i-1)*Qm+j-1+1);
%     end
% end
tempdata = deiw_data;

%解bit选择
if(1==LDPC_base_graph)
    ktemp = KTable(rvid+1,1);
    k0 = floor(ktemp*Ncb/(66*Zc))*Zc;
else
    ktemp = KTable(rvid+1,2);
    k0 = floor(ktemp*Ncb/(50*Zc))*Zc;
end

k =1;
j = 0;

% while(k < Er+1)
%     indextmp = mod(k0+j,Ncb)+1;
%     if(ismember(indextmp,null_pos))
%     else
%       out(indextmp) = tempdata(k);
%       dicbuffer(indextmp) = 1; %记录没有被打掉的位置 
%       k = k+1;
%     end
%     j = j +1;
% end
% 
% diffpos = find(dicbuffer==0);
% len = length(diffpos);
% for i = 1:len
% %     out(diffpos(i)) = 2;   %设置被打掉的数据为2，可以根据译码性能修改
%    out(diffpos(i)) = coded_data(index,diffpos(i));
% %    out(diffpos(i)) = 0.5;
% end

while(k < Er+1)
    indextmp = mod(k0+j,Ncb)+1;
    if(ismember(indextmp,null_pos))
    else
        tempp = tempdata(k);
        if(EN_LDPC)
            out(indextmp) = 1 -2*tempp;
        else
            out(indextmp) = tempp;
        end
      
      dicbuffer(indextmp) = 1; %记录没有被打掉的位置 
      k = k+1;
    end
    j = j +1;
end

diffpos = find(dicbuffer==0);
len = length(diffpos);
for i = 1:len
%     out(diffpos(i)) = 2;   %设置被打掉的数据为2，可以根据译码性能修改
%    out(diffpos(i)) = coded_data(index,diffpos(i));
    tempdiff = coded_data(index,diffpos(i));
%    out(diffpos(i)) = 0;
    if(EN_LDPC)
        out(diffpos(i)) = 1-2*tempdiff;
    else
        out(diffpos(i)) = tempdiff;
    end
   
end


end


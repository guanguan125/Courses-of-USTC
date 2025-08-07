function [out]  = GenTimeData_5G(fredata,Nsym_slot,Nu)
%GENTIMEDATA_5G 此处显示有关此函数的摘要
%   此处显示详细说明
nfft = Nu;
start =1;
for iii=1:Nsym_slot
    %端口0，符号iii
%     tmpdata=[inputdata(iii,(half+1):total),zeros(1,(nfft-total)),inputdata(iii,1:half)];
    tmpdata=fredata(iii,:);
    ifftdata = ifft(tmpdata,Nu);
    tail = start+nfft-1;
    out([start:tail]) =ifftdata([1:nfft]);      
    start = tail+1;
end
end


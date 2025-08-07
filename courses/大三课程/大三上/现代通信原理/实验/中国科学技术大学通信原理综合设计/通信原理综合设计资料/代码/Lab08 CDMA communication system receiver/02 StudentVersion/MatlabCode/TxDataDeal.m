%20180227£¬Àîçâ²âÊÔ¿ÉÓÃ

function dataIQ=TxDataDeal(TxdataI,TxdataQ)

mlength=2*length(TxdataI);
dataIQ(1,1:2:mlength-1)=TxdataI(:);
dataIQ(1,2:2:mlength)=TxdataQ(:);

dataIQ = dataIQ.*(2047/max(dataIQ));

dataIQ=fix(dataIQ);

for n = 1 : mlength
        if dataIQ(n) > 2047
          dataIQ(n) = 2047;
        elseif  dataIQ(n) < 0
          dataIQ(n) = 4096 + dataIQ(n);
        end
end

dataIQ(1,1:2:mlength-1) = dataIQ(1,1:2:mlength).*16;
dataIQ(1,2:2:mlength) = fix(dataIQ(1,2:2:mlength)./256) + rem(dataIQ(1,2:2:mlength),256).*256; 
dataIQ = uint16(dataIQ); 
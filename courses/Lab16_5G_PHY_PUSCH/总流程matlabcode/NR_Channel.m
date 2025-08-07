function rxdata = NR_Channel(txdata,SNR,rfflag,EN_NOISE,EN_BUTSRINTER,EN_FREOFFSET,EN_TIMEOFFSET,EN_Mutipath,mutitimeoffset,mutifreoffset,mutiamp,mutiphaseoffset,lenburstinter,freoffset,timeoffset,recant,txantnum,txindex,atte_factor,pcip,xsrpip)
%使能射频
SNR =10^(SNR/10); %信号和噪声的功率的比值，不是db值
if(rfflag)
    rxdata =  OFDM_RFLoopback_1ant(txdata,recant,txantnum,txindex,pcip,xsrpip);
else
        if(EN_BUTSRINTER)
        txdata = burstinterference(txdata,lenburstinter);
        end
    if(EN_FREOFFSET)
        txdata = genfreoffset(txdata,freoffset);
    end
    if(EN_TIMEOFFSET)
        txdata = gentimeoffset(txdata,timeoffset);
    end
    
    if(EN_Mutipath)
        txdata = genmutipath(txdata,mutiamp,mutitimeoffset,mutifreoffset,mutiphaseoffset);
    end
    
    
    if(EN_NOISE)
        rxdata = addawgndnoise(txdata,SNR); 
%     elseif(EN_BUTSRINTER)
%         rxdata = burstinterference(txdata,lenburstinter);
%     elseif(EN_FREOFFSET)
%         rxdata = genfreoffset(txdata,freoffset);
%     elseif(EN_TIMEOFFSET)
%         rxdata = gentimeoffset(txdata,timeoffset);
    else
        rxdata = txdata;
    end
    
    rxdata = rxdata*atte_factor;
    
end
end
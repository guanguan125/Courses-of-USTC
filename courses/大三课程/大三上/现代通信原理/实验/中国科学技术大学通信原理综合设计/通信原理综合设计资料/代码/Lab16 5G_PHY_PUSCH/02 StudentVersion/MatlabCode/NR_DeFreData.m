%% OFDM解调
%% 包含去CP、OFDM解调
function out = NR_DeFreData( input,Nsym_slot,Nu,EN_TIMEOFFSETCP,timeoffsetCP) 

%% 多径CP时延

% EN_TIMEOFFSETCP = 1;  %CP多径时延时延开关，1:on， 0：off
% timeoffsetCP =150;    %CP多径时间延迟采样点,输入范围100~200
T=timeoffsetCP;
 if(EN_TIMEOFFSETCP)
%         txdata = gentimeoffset(txdata,timeoffsetCP);
        input = [  zeros(1,T)  input(1,1:end-T) ];
    end


%% 去CP
symnum =14;  %一个子帧为14个符号

start =1;
output =zeros(1,2048*14);

for ii = 1:symnum
     if((1==ii)|| (8==ii))   %CP长度为160
         start = start+160;
         tail = start+2048-1;
         output(1,(ii-1)*2048+1:ii*2048) = input(start:tail);  
         start = tail+1;
     else    %cp长度为144
         start = start+144;
         tail = start+2048-1;
         output(1,(ii-1)*2048+1:ii*2048) = input(start:tail);  
         start = tail+1;
         
     end
end

timedata = output;
%% OFDM 解调
nfft = Nu;
start =1;

out = zeros(1,Nu*Nsym_slot);

for(iii=1:Nsym_slot)
        
    tmpdata = timedata((iii-1)*nfft+1:iii*nfft);
    fftdata = fft(tmpdata,nfft);
    tail = start+nfft-1;
    out([start:tail]) =fftdata([1:nfft]);      
    start = tail+1;   
end


end


function out = DeRemap_5G( defredata,Nsym_slot,Nu,prb_num ) 

nfft = Nu;
half = prb_num*12/2;
total = prb_num*12;
start =1;

out = zeros(Nsym_slot,1200);

for(iii=1:Nsym_slot)
        
    fftout = defredata((iii-1)*nfft+1:iii*nfft);
    out(iii,start:total) = [fftout((nfft-half+1):nfft),fftout(1:half)];
       
end


end


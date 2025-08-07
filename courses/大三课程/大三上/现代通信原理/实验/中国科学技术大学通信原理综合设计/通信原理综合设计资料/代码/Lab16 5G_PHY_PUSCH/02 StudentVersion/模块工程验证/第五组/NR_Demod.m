function outdemod = NR_Demod(moddata,qm)
d1 = 1/sqrt(10);  %16QAM的归一化因子
d2 = 1/sqrt(42);  %64QAM的归一化因子
d3 = 1/sqrt(170); %256QAM的归一化因子
[row,colo] = size(moddata);
start =1;
for(jjj =1:row)
    tail =start+colo-1;
    moddatatmp(start:tail) = moddata(jjj,:);
    start = tail+1;
end
realdata = real(moddatatmp);  % I路
imagedata = imag(moddatatmp); % Q路
len = length(moddatatmp);
switch qm
    case 2    %QPSK 硬解调
        for(iii=1:len)
            if(realdata(iii)>0)
                outdemod(2*(iii-1)+1) = 0;
            else
                outdemod(2*(iii-1)+1) = 1;
            end
            if(imagedata(iii)>0)
                outdemod(2*(iii-1)+2) = 0;
            else
                outdemod(2*(iii-1)+2) = 1;
            end
        end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% student code %%%%%%%%%%%%%%%%%%%%%%%%%%
    case 4   %16QAM 硬解调
      
        
    case 6  %64QAM 硬解调
          
         
     case 8  %256QAM 硬解调
       

 
 
 
 
 
 
 
 
 
 
 
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% end %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function outdemod = NR_Demod(moddata,qm)
d1 = 1/sqrt(10);  %16QAM�Ĺ�һ������
d2 = 1/sqrt(42);  %64QAM�Ĺ�һ������
d3 = 1/sqrt(170); %256QAM�Ĺ�һ������
[row,colo] = size(moddata);
start =1;
for(jjj =1:row)
    tail =start+colo-1;
    moddatatmp(start:tail) = moddata(jjj,:);
    start = tail+1;
end
realdata = real(moddatatmp);  % I·
imagedata = imag(moddatatmp); % Q·
len = length(moddatatmp);
switch qm
    case 2    %QPSK Ӳ���
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
    case 4   %16QAM Ӳ���
      
        
    case 6  %64QAM Ӳ���
          
         
     case 8  %256QAM Ӳ���
       

 
 
 
 
 
 
 
 
 
 
 
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% end %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% ½»Ö¯
function Output = NR_Interweave( ratematchdata,Er,Qm,C,EN_INTERWEAVER)

if(EN_INTERWEAVER)
    for k=1:C
    inputdate = ratematchdata(k,:);
    symnum = Er(k)/Qm;
    for j = 1:symnum
       for i = 1:Qm
          outtemp( (i-1)+(j-1)*Qm+1) = inputdate((i-1)*symnum+j-1+1);
       end
    end
    Output(k,:) = outtemp;
    end
else
    
    Output = ratematchdata;
end


end
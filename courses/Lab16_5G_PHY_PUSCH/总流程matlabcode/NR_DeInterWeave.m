function Output=NR_DeInterWeave(deccbc_data,Er,Qm,C,EN_INTERWEAVER)

if(EN_INTERWEAVER)
    for k=1:C
    inputdate = deccbc_data(k,:);
    symnum = Er(k)/Qm;
    for j = 1:Qm
       for i = 1:symnum
          outtemp((i-1)+(j-1)*symnum+1) = inputdate((i-1)*Qm+j-1+1);
       end
    end
    Output(k,:) = outtemp;
    end
else
    Output = deccbc_data;
end


end
function [rsout,l1,l2] = NR_RS_Gen( TransformPrcode_en,cellid,nslotnum,beltaDMRS,UL_DMRS_Config_type,Frist_DMRS_L0,Second_DMRS_L,prb_num )

tempdata = 1/(2^0.5);
symlen = prb_num*12; %子载波的长度
rsout = zeros(2,symlen);

% TransformPrcode_en =1;

if(0 == TransformPrcode_en)
%计算2个导频符号的位置，由L0+L'计算获得，
l1 = Frist_DMRS_L0 +0;
l2 = Second_DMRS_L+1;

scramblelen = 2*symlen;
cinitl1 = mod((2^17*(14*nslotnum+l1+1)*(2*cellid+1)+2*cellid+0),2^31);
cinitl2 = mod((2^17*(14*nslotnum+l2+1)*(2*cellid+1)+2*cellid+0),2^31);

NC = 1600;
lenx=NC+scramblelen-31;

%第一个导频符号的数据产生
x1=zeros(1,31); x1(1)=1;
for(iii=1:31)    
    x2(iii)=mod(cinitl1,2);
    cinitl1=floor(cinitl1/2);
end

for(iii=1:lenx)
    x1(iii+31)=xor(x1(iii+3),x1(iii));
    temp = x2(iii+3)+x2(iii+2)+x2(iii+1)+x2(iii);
    x2(iii+31)=mod(temp,2);
end
for(iii=1:scramblelen)
    temp = x1(iii+NC)+x2(iii+NC);
    scrambit(iii) = mod(temp,2);
end

for k = 1:symlen
    r(k) = tempdata*(1-2*scrambit(2*(k-1)+1))+j*tempdata*(1-2*scrambit(2*k));
end

%一个antport p=1000,k'=0,l'=0,detal = 0,wf(k')=1,wt(l')=1
% for k= 1:2:symlen
%    rsout(1,k) = beltaDMRS*r((k-1)/2+1);
% end

for k= 1:symlen
   rsout(1,k) = beltaDMRS*r(k);
end

%第二个导频符号的数据产生
x1=zeros(1,31); x1(1)=1;
for(iii=1:31)    
    x2(iii)=mod(cinitl2,2);
    cinitl2=floor(cinitl2/2);
end

for(iii=1:lenx)
    x1(iii+31)=xor(x1(iii+3),x1(iii));
    temp = x2(iii+3)+x2(iii+2)+x2(iii+1)+x2(iii);
    x2(iii+31)=mod(temp,2);
end
for(iii=1:scramblelen)
    temp = x1(iii+NC)+x2(iii+NC);
    scrambit(iii) = mod(temp,2);
end

for k = 1:symlen
    r(k) = tempdata*(1-2*scrambit(2*(k-1)+1))+j*tempdata*(1-2*scrambit(2*k));
end

%一个antport p=1000,k'=0,l'=0,detal = 0,wf(k')=1,wt(l')=1
% for k= 1:2:symlen
%    rsout(2,k) = beltaDMRS*r((k-1)/2+1);
% end

for k= 1:symlen
   rsout(2,k) = beltaDMRS*r(k);
end

else
    [rsout(1,:),rs_local_slot1] = pusch_rs_gen(prb_num,0,0,2*nslotnum,cellid,0,0,0,3);
    [rsout(2,:),rs_local_slot2] = pusch_rs_gen(prb_num,0,0,2*nslotnum+1,cellid,0,0,0,3);
    %根据Low-PAPR序列来产生
end

end


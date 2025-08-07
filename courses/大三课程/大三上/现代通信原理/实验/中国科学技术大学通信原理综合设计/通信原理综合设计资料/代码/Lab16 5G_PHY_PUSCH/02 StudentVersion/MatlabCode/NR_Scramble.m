%% 加扰
%% 包含码块级联、加扰
function out = NR_Scramble(C,iw_data,rm_len,vrb_num,qm,ue_index,cellid)

%% 码块级联
Info_data = iw_data;
data_len = rm_len;

k=0;
for i=1:C
    len = data_len(i);
    output(k+1:k+len) = Info_data(i,1:len);
    k = k+len;
end
pusch_coding_bit = output;

%% 加扰
bit_len = vrb_num*12*12*qm;
cinit=ue_index*(2^15)+cellid;

NC = 1600;
lenx=NC+bit_len-31;

x1=zeros(1,31); x1(1)=1;
for(iii=1:31)    
    x2(iii)=mod(cinit,2);
    cinit=floor(cinit/2);
end

for(iii=1:lenx)
    x1(iii+31)=xor(x1(iii+3),x1(iii));
    temp = x2(iii+3)+x2(iii+2)+x2(iii+1)+x2(iii);
    x2(iii+31)=mod(temp,2);
end
for(iii=1:bit_len)
    temp = x1(iii+NC)+x2(iii+NC);
    scrambit(iii) = mod(temp,2);
end

 for(kkk=1:bit_len)
    out(kkk) = xor(scrambit(kkk),pusch_coding_bit(kkk));
 end
 
 out=double(out);
end
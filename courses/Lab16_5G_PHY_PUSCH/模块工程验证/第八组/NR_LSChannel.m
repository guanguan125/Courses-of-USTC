
%% 包含信道估计、信道均衡
function [outdata,slotlschanneldata] = NR_LSChannel( deremapdata,TransformPrcode_en,cellid,nslotnum,beltaDMRS,UL_DMRS_Config_type,Frist_DMRS_L0,Second_DMRS_L,prb_num,EN_CHES,DMRS_symbol,Nsym_slot)

%% 信道估计
if(EN_CHES)
    %计算导频数据
   rsdata = NR_RS_Gen(TransformPrcode_en,cellid,nslotnum,beltaDMRS,UL_DMRS_Config_type,Frist_DMRS_L0,Second_DMRS_L,prb_num);
   scnum = 12*prb_num;

   %计算2个导频符号的位置，由L0+L'计算获得，
   l1 = Frist_DMRS_L0 +0;
   l2 = Second_DMRS_L+1;

   %matlab没有符号0
   rs_station0 = l1+1;
   rs_station1 = l2+1;

   %获取2个导频的频域数据
   rs0fredata = deremapdata(rs_station0,1:scnum);
   rs1fredata = deremapdata(rs_station1,1:scnum);

   for(iii = 1:scnum)
      if(0 == rsdata(1,iii))   %检测除数为0的情况
          out(1,iii) = 1;
          out(2,iii) = 1;
      else
          out(1,iii) = rs0fredata(iii)/rsdata(1,iii);
          out(2,iii) = rs1fredata(iii)/rsdata(2,iii);
      end

   end
else
    scnum = 12*prb_num;
    out = ones(2,scnum);
end
slotlschanneldata = out;
%% 信道均衡
start=1;
start1 =1;
datasymbol = 0;
carry_len = prb_num*12;
halfsymbol = Nsym_slot/2;
slotsymbol = Nsym_slot-DMRS_symbol;
% outdata = zeros(slotsymbol,1200);

tail1 = start1+carry_len-1;
if(2 ==DMRS_symbol)
  %计算2个导频符号的位置，由L0+L'计算获得，
  rsl1 = Frist_DMRS_L0 +0;
  rsl2 = Second_DMRS_L+1;
  
  %matlab没有符号0
  rs_station0 = rsl1+1;
  rs_station1 = rsl2+1;
else
  rsl1 = Frist_DMRS_L0 +0;
   %matlab没有符号0
  rs_station0 = rsl1+1;
  rs_station1 = 20;  %一个slot的符号不会超过20，不进行资源分配
end

 for(iii=1:halfsymbol)  %前面一半符号的处理，用一个导频符号的信道估计值
     if(iii == rs_station0)  %第一个导频符号跳过
        continue; 
     end
     datasymbol = datasymbol+1;
      tail = start+carry_len-1;
    outdata(start:tail) = deremapdata(iii,start1:tail1)./slotlschanneldata(1,start1:tail1); 
    start = tail+1;
 end
 
  for(iii=(halfsymbol+1):Nsym_slot)  %后面一半符号的处理，用二个导频符号的信道估计值
     if(iii == rs_station1)  %第二个导频符号跳过
        continue; 
     end
     datasymbol = datasymbol+1;
      tail = start+carry_len-1;
%       outdata(datasymbol,start:tail) = deremapdata(iii,start1:tail1)./slotlschanneldata(2,start1:tail1); 
      outdata(start:tail) = deremapdata(iii,start1:tail1)./slotlschanneldata(2,start1:tail1);   
      start = tail+1;
 end

end

%% 信道估计与均衡
%% 包含信道估计、信道均衡
function [outdata,slotlschanneldata] = NR_LSChannel( deremapdata,TransformPrcode_en,cellid,nslotnum,beltaDMRS,UL_DMRS_Config_type,Frist_DMRS_L0,Second_DMRS_L,prb_num,EN_CHES,DMRS_symbol,Nsym_slot)

%% 信道估计
if(EN_CHES)
    %计算导频数据
   rsdata = NR_RS_Gen(TransformPrcode_en,cellid,nslotnum,beltaDMRS,UL_DMRS_Config_type,Frist_DMRS_L0,Second_DMRS_L,prb_num);
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% student code %%%%%%%%%%%%%%%%%%%%%%%%%%  
   
  
 
 
 
 

%% 信道均衡






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% end %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end


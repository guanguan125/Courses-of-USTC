%% �ŵ����������
%% �����ŵ����ơ��ŵ�����
function [outdata,slotlschanneldata] = NR_LSChannel( deremapdata,TransformPrcode_en,cellid,nslotnum,beltaDMRS,UL_DMRS_Config_type,Frist_DMRS_L0,Second_DMRS_L,prb_num,EN_CHES,DMRS_symbol,Nsym_slot)

%% �ŵ�����
if(EN_CHES)
    %���㵼Ƶ����
   rsdata = NR_RS_Gen(TransformPrcode_en,cellid,nslotnum,beltaDMRS,UL_DMRS_Config_type,Frist_DMRS_L0,Second_DMRS_L,prb_num);
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% student code %%%%%%%%%%%%%%%%%%%%%%%%%%  
   
  
 
 
 
 

%% �ŵ�����






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% end %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end


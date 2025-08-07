function outdata = GenPss(prb_num,rbstart,UL_subframe_num,cellid)
fredata3 = zeros(1,1200);
outdata = zeros(1,2048);
startpos = rbstart*12+1;

[rsdata,rslocaldata] = pusch_rs_gen(prb_num,0,0,2*UL_subframe_num,cellid,0,0,0,3);

fredata3(1,startpos:(startpos+prb_num*12-1)) = rsdata;

outdata =[fredata3(601:1200),zeros(1,848),fredata3(1:600)];


end
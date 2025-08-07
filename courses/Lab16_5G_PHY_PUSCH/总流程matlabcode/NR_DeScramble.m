%% 解扰
%% 包含解扰、解码块级联
function rm_data = NR_DeScramble(demoddata,vrb_num,qm,ue_index,cellid,C,rm_len)
%% 解扰
% descrambledata  = DeScramble_5G(demoddata,prb_num,Qm,ue_index,cellid);
% 输出参数：  
% rm_data：解码块级联后的输出数据  
% 输入参数：  
% demoddata：解调后的输出数据  
% vrb_num：UE的RB个数 
% Qm：调制方式。2：QPSK  4:16QAM  6:64QAM  8:256QAM 
% ue_index：UE的索引 
% cellid：小区ID 
% C ：传输块分割的码块数 
% rm_len：速率匹配后的长度
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% student code %%%%%%%%%%%%%%%%%%%%%%%%%%
out = DeScramble_5G(demoddata,vrb_num,qm,ue_index,cellid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% end %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 解码块级联
E = rm_len;
descrambledata = out;
% deccbc_data = DeCdblkConcate_5G(C,descrambledata,rm_len);
rm_data = zeros(C,E(C));
temp = 1;
for r = 1:C
    rm_data(r,1:E(r))= descrambledata(temp:(temp + E(r) - 1));
    temp = temp + E(r);
end
end

function [descrambledata] = DeScramble_5G(demoddata,vrb_num,qm,ue_index,cellid)
totallen = vrb_num * 12 * 12 * qm;%我需求输出的长度
cinit = ue_index * ( 2 ^ 15 ) + cellid;
NC = 1600;
setlen= NC +totallen - 31;%我需要生成的x1x2长度（需求长度+增强随机性变量-已有长度）


x1 = zeros( 1, 31 );
x1( 1 ) = 1;

for ( i = 1:31 )
    x2( i ) = mod( cinit, 2 );
    cinit = floor( cinit / 2 );
end 

for ( i = 1:setlen )
    x1( i + 31 ) = xor( x1( i + 3 ), x1( i ) );
    x2( i + 31 ) =xor(xor(x2(i+3),x2(i+2)),xor(x2(i+1),x2(i)));
end 
for ( i = 1:totallen )
    
    scrambit( i ) = xor(x1( i + NC ) , x2( i + NC ));%后半部分
    
end 

for ( i = 1:totallen )
    descrambledata( i ) = xor( scrambit(i ), demoddata( i) );%b+c）mod2
end
end

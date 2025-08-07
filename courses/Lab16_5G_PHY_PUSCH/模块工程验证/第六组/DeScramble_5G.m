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


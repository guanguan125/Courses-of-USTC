%% 解预编码
%% 包含解预编码、解传输预编码、解层映射
function outdata = NR_DePrecode( CodebookTransform_en, TPMIindex,equdata,Antportnum,transformprcode_en,Nsym_slot,DMRS_symbol,prb_num,vnum)
%% 解预编码
temp = 1/(2^0.5);
vnum2table = [1,0;
              0,1;
              1,1;
              1,-1;
              1,j;
              1,-j];

if(0 == CodebookTransform_en)
    output = equdata;
else
    %如果只有一层，W=1
    if(1 == Antportnum)
       output = inputdata; 
    else
        if(2 == Antportnum)
            PreMatrix  = (temp*vnum2table(TPMIindex+1,:))';
            output = equdata/PreMatrix;  %预编码时乘以预编码矩阵，解预编码时除以预编码矩阵
        else
          %处理4天线端口
        end
    end
end
deprecodedata = output;
%% 解传输预编码
% function out = DeTransformProcode_5G( transformprcode_en,deprecodedata,Nsym_slot,DMRS_symbol,prb_num )
nsymnum = Nsym_slot - DMRS_symbol;
carry_len = prb_num*12;
start =1;
out = deprecodedata;

if(0 == transformprcode_en)
    out = deprecodedata;
else
    %解传输预编码只是对第一层的所有符号进行IDFT变化,其它层的数据不进行变化。
    tempdata = deprecodedata(1,:)*sqrt(carry_len);
    for k =1:nsymnum
         tail = start+carry_len-1;
%          dftout = fft(tempdata([start:tail]),carry_len)/sqrt(carry_len);
%          out(1,start:tail) = dftout;
           fftout = ifft(tempdata(start:tail),carry_len);
           out(1,start:tail) = fftout;
          start =tail+1;        
    end
end
detransformprecodedata = out;
%% 解层映射
%计算每层的数据长度
len = length(detransformprecodedata(1,:));

%将多层的数据合成一路数据，便于后面的解调
for ii = 1:len
    for jj = 1:vnum
        outdata((ii-1)*vnum+jj) = detransformprecodedata(jj,ii);
    end
    
end
end


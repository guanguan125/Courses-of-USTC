%% 加CRC
%% 包含加CRC、码块分割
function [p,C,Zc,K,K_p,Out_data,F] = NR_crc24a(c,LDPC_base_graph,i_ls)

%% 加CRC
% 功能：以校验多项式为除数的多项式除。计算24位crc,得到校验二进制校验数组p
% 输入：
%      c：需要进行CRC校验的信息
% 输出：
%      p：进行CRC校验的校验位，由低位到高位排列
%  
%校验多项式为：
%      gCRC24A(D) = [D24 + D23 + D18 + D17 + D14 + D11 + D10 + D7 + D6 + D5 + D4 + D3 + D + 1] 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% student code %%%%%%%%%%%%%%%%%%%%%%%%%%
p = crc24a(c);
result = CRC_attach(c,24,0);
Info_data=result;
% polynomial = [1 1 0 0 0 0 1 1 0 0 1 0 0 1 1 0 0 1 1 1 1 1 0 1 1];%定义检验多项式
% %进行异或运算
% lpol= length(polynomial);
% data_dec=c;%用于输入
% lnum=length(data_dec);
% data=[data_dec,zeros(1,lpol-1)];
% lpol= length(polynomial);
% n=find(data==1,1);
% while n<=lnum
% for i=1:lpol
%     if polynomial(i)==data(n+i-1)
%         data(n+i-1)=0;
%     else
%         data(n+i-1)=1;
%     end
% end
% n=find(data==1,1);
% end
% %拼接计算结果并显示
% p = data(lnum+1:end);
% 
% disp('The p is')
% disp(num2str(p))
% result=[data_dec,data(lnum+1:end)];
% disp('The transform result is')
% disp(num2str(result))
% %进行结果校验
% result2=result;
% n=find(result2==1,1);
% while n<lnum+lpol-1
% for i=1:lpol
%     if polynomial(i)==result2(n+i-1)
%         result2(n+i-1)=0;
%     else
%         result2(n+i-1)=1;
%     end
% end
% n=find(result2==1,1);
% end
% disp('The CRC result is')
% disp(num2str(result2))
% Info_data=result;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% end %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 码块分割
%[ C,Zc,K,K_p,Out_data,F] = Cdblk_seg_5G( Info_data,LDPC_base_graph,i_ls )
% ZTable = [2, 4, 8, 16, 32, 64, 128, 256;
%           3, 6, 12, 24, 48, 96, 192, 384;
%           5, 10, 20, 40, 80, 160, 320,0;
%           7, 14, 28, 56, 112, 224, 0, 0 ;
%           9, 18, 36, 72, 144, 288, 0, 0;
%           11, 22, 44, 88, 176, 352, 0, 0;
%           13, 26, 52, 104, 208, 0, 0, 0;
%           15, 30, 60, 120, 240, 0, 0, 0];
%LDPC的移位值
 ZTable = [2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,18,20,22,24,26,28,30,32,36,40,44,48,52,56,60,64,72,80,88,96,104,112,120,128,144,160,176,192,208,224,240,256,288,320,352,384];
 
 Info_len = length(Info_data);    
 if(1 == LDPC_base_graph)
    Kcb = 8448;%码块分割的最大bit数
    Kb = 22;
else
   Kcb = 3840; 
   if(Info_len > 640)
       Kb = 10;
   elseif(Info_len >560)
       Kb = 9;
   elseif(Info_len > 192)
       Kb = 8;
   else
       Kb = 6;
   end
end

if(Info_len<=Kcb)
    L = 0;    % CRC add length euqal to 0, No CRC should be add
    C = 1;   % only one code block;
    Bt = Info_len; % the length is equal to the input length after code block segment function
else
    L = 24; %CRC add lenth equal to 24 CRC should be added 
    C = ceil(Info_len/(Kcb-L)); % code block number after code block segment
    Bt = Info_len + C*L;  % the total length after code block segment
end

K_p = Bt/C;
% ZTable_index = ZTable(i_ls+1,:);
ZTable_index = ZTable;

i =1;
while(Kb*ZTable_index(i)<K_p)
    i = i+1;
end
Zc = ZTable_index(i);

if(1 == LDPC_base_graph)
    K = 22*Zc;
else
    K = 10*Zc;
end

F = K- K_p;
Out_data = zeros(C, K);

if(C == 1)   % only one block, total block length is Info_len, no CRC add.
    Out_data(1,1:K_p) = Info_data; 
    Out_data(1,K_p+1:K) = 2*ones(1,F);  %在后面添加NULL，此处NULL用2代替
else
    k = 1;
    s = 1;
    for r = 1:C
%         if (r<Cm+1)
%             Kr = Km-L;
%         else
%             Kr = Kp-L;
%         end
        Kr = K_p-L;
        while k<Kr+1
            Out_data(r,k) = Info_data(1,s);
            k = k+1;
            s = s+1;
        end
        k = 1;
        Out_data(r,1:Kr+L) = CRC_attach(Out_data(r,1:Kr),24,1);
%         Out_data(r,K_p+1:K) = 2*ones(1,F);  %在后面添加NULL，此处NULL用2代替
        Out_data(r,K_p+1:K) = 0;  %在后面添加NULL，此处NULL用2代替
    end
end

end

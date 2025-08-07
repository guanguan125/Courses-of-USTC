clc
clear

%输入想要转化的数据
data1=input('Please input the num U want to transform:');
 
%将十进制数转化成二进制数输出
dec=[];
i=1;
while(data1)
    if mod(data1,2)
     dec=[1,dec];
    else
     dec=[0,dec];
    end
    data1=(data1-mod(data1,2))./2;
end
disp('The below is your num in binary system')
display(num2str(dec))
 
% 校验多项式CRC-24

%      gCRC24A(D) = [D24 + D23 + D18 + D17 + D14 + D11 + D10 + D7 + D6 + D5 + D4 + D3 + D + 1] 
polynomial = [1 1 0 0 0 0 1 1 0 0 1 0 0 1 1 0 0 1 1 1 1 1 0 1 1];%定义检验多项式
%进行异或运算
lpol= length(polynomial);
data_dec=dec;
lnum=length(data_dec);
data=[data_dec,zeros(1,lpol-1)];
lpol= length(polynomial);
n=find(data==1,1);
while n<=lnum
for i=1:lpol
    if polynomial(i)==data(n+i-1)
        data(n+i-1)=0;
    else
        data(n+i-1)=1;
    end
end
n=find(data==1,1);
end
 
%拼接计算结果并显示
result=[data_dec,data(lnum+1:end)];
disp('The polynomial used to CRC is X^16+X^15+X^2+1')
disp('The transform result is')
disp(num2str(result))
 
%进行结果校验
result2=result;
n=find(result2==1,1);
while n<lnum+lpol-1
for i=1:lpol
    if polynomial(i)==result2(n+i-1)
        result2(n+i-1)=0;
    else
        result2(n+i-1)=1;
    end
end
n=find(result2==1,1);
end
disp('The CRC result is')
disp(num2str(result2))
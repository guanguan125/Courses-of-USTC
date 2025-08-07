function [char_msg]=CDMA_RxMsgDecode(bit_msg)

len1=bit_msg(1,1:16);
len=bi2de(len1,'left-msb');
bit_msg1=bit_msg(1,17:17+len-1);

for num = 1:len/8
      char_msg(num)=char(bi2de(bit_msg1(1,(num-1)*8+1:num*8),'left-msb'));  
end
                
end
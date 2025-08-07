%20171218，李玮测试可用

function [getIQ] = GetIQ(soltNo,freqDiv,packNum,packSize,solotSwitch,contSwitch)

%soltNo	采集时隙号
%freqDiv	采集速率分频值
%packNum	UDP包数量
%packSize	UDP包大小
%solotSwitch	连续时隙采集开关
%contSwitch	 连续采集开关

soltNo=dec2hex(soltNo);

freqDivL=(mod(freqDiv,256));
freqDivH=(freqDiv-freqDivL)/256;
freqDivL=dec2hex(freqDivL);
freqDivH=dec2hex(freqDivH);

packNumL=(mod(packNum,256));
packNumH=(packNum-packNumL)/256;
packNumL=dec2hex(packNumL);
packNumH=dec2hex(packNumH);

packSizeL=(mod(packSize,256));
packSizeH=(packSize-packSizeL)/256;
packSizeL=dec2hex(packSizeL);
packSizeH=dec2hex(packSizeH);

solotSwitch=dec2hex(solotSwitch);
contSwitch=dec2hex(contSwitch);

getIQ  = uint8(hex2dec({'00','00','99','bb','66',soltNo,freqDivH,freqDivL,packNumH,packNumL,packSizeH,packSizeL,'00',solotSwitch,'00',contSwitch,'00','00','00','00'}));




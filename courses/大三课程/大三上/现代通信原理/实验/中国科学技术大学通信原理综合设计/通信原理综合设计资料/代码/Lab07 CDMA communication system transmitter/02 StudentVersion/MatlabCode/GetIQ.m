%20171218��������Կ���

function [getIQ] = GetIQ(soltNo,freqDiv,packNum,packSize,solotSwitch,contSwitch)

%soltNo	�ɼ�ʱ϶��
%freqDiv	�ɼ����ʷ�Ƶֵ
%packNum	UDP������
%packSize	UDP����С
%solotSwitch	����ʱ϶�ɼ�����
%contSwitch	 �����ɼ�����

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




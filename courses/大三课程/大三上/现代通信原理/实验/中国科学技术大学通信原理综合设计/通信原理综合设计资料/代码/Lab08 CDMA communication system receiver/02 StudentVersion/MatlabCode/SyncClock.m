%20180227��������Կ���

function [syncClock] = SyncClock(syncChoice,clcChoice)

%syncChoice	������ͬ��ѡ��
%clcChoice	����ʱ��ѡ��
syncChoice=dec2hex(syncChoice);
clcChoice=dec2hex(clcChoice);
syncClock = uint8(hex2dec({'00','00','99','bb',  '69','00','00',syncChoice,'00','00','00',clcChoice, '00','00','00','00','00','00','00','00'}));
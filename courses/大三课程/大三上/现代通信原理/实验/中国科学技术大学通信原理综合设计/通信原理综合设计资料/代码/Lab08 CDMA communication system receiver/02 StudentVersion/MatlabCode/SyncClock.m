%20180227，李玮测试可用

function [syncClock] = SyncClock(syncChoice,clcChoice)

%syncChoice	上下行同步选择
%clcChoice	工作时钟选择
syncChoice=dec2hex(syncChoice);
clcChoice=dec2hex(clcChoice);
syncClock = uint8(hex2dec({'00','00','99','bb',  '69','00','00',syncChoice,'00','00','00',clcChoice, '00','00','00','00','00','00','00','00'}));
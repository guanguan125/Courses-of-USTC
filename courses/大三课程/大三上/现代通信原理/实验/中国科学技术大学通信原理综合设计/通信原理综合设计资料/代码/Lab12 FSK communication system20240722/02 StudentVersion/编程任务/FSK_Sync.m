%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FlieName: FSK_Sync.m
%  Description: 搜索同步码
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Function List :
%         [RecvCorr,pos] = FSK_Sync(RecvFskDemod,UpSampleRate,Preamble)
%  Parameter List: 
%      Output Parameter
%         RecvCorr                  同步码相关结果
%         pos                            峰峰值的位置
%      Input Parameter
%         RecvFskDemod      幅度比较后的信号
%         UpSampleRate       一个码元周期内的样点数
%         Preamble                 同步码
%   History
%       1. Date        : 2022-1-14
%           Author      : LHX
%           Version     : 2.0
%           Modification: 第二版
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [RecvCorr,pos] = FSK_Sync(RecvFskDemod,UpSampleRate,Preamble)

 %%%%以下填空：
                                  %将同步码变为极性码(1变成1，0变成-1)
%%%%以上填空：
                                  %滑动相关运算
 
	                                   % 同步码相关结果RecvCorr归一化，令RecvCorr里的每个值都除以RecvCorr的最大值
%%%%以上填空：

end
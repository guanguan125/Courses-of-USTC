%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName: FSK_Sampling.m
%  Description: 抽样
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Function List :
%         RecvSymbolSampled = FSK_Sampling(pos,UpSampleRate,MsgLen,RecvFskDemod,PreambleLen)
%  Parameter List:
%     Output Parameter:
%        RecvSymbolSampled:      抽样后数据
%     Input Parameter:
%        pos                                      帧头的位置
%        UpSampleRate                  一个码元周期内的样点数
%        MsgLen                              信源比特长度
%        RecvFskDemod                幅度比较后信号
%        PreambleLen                     同步码长度
%   History
%       1. Date        : 2022-2-14
%           Author      : LHX
%           Version     : 2.0
%           Modification: 第二版
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function RecvSymbolSampled = FSK_Sampling(pos,UpSampleRate,MsgLen,RecvFskDemod,PreambleLen)

%%%%以下填空：
	                                % 由MsgLen计算信道编码后数据长度
                                    % 复制RecvFskDemod，形成两帧信号

                                  % 抽样（未去同步码），%pos是帧头的位置，每隔UpSampleRate个长度进行抽样
%%%%以上填空：
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:FSK_Convcode.m
%  Description: 卷积编码
%   Function List :
%            [output_data] = FSK_Convcode(CoderConstraint,input_data,Gx)
%  Parameter List:
%     Output Patameter
%            output_data         卷积编码后的比特数据
%     Input Parameter
%           CoderConstraint  卷积码的约束长度
%           input_data             生成的随机比特数据
%           Gx                          卷积码的生成矩阵
%   History
%       1. Date        : 2022-1-10
%           Author      : LHX
%           Version     : 2.0
%           Modification: 第二版
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [out_data] = FSK_Convcode(K,input_data,Gx)
%%%%以下填空：
                       %利用函数poly2trellis将卷积码多项式转换成MATLAB的trellis网格表达式,
                       %实验卷积码生成多项式矩阵为[171,133], 八进制171-二进制111 1001，八进制133-二进制101 1011.

                       % 结尾处理, 在消息的结尾添加 约束长度减1个零

                       %  调用库函数网格码 生成卷积码  
%%%%以上填空：
end
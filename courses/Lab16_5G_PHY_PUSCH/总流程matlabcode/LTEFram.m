function output = LTEFram(input,timestart)

pos = 6737;  %第一个导频符号的位置（160+2048*3+144*3+1=6737）
if (timestart <=pos)  % 说明采样点延迟了，需要左移动
    leftpos = pos - timestart;
    output = [input(1,(30720-leftpos+1):30720),input(1,1:(30720-leftpos))];   
else  %说明采样点提前了，需要右移动
    rightpos = timestart - pos;
    output = [input(1,rightpos+1:30720),input(1,1:rightpos)];
end

end
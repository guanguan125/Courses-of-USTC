function tbsize = calc_tbsize(module_type,prb_num)
% 设置prb_num为100或者50，module_type为QPSK、16QAM、64QAM和256QAM4种情况，共计8种情况

switch module_type
    case 1
        if prb_num==50
            tbsize = 8456; %根据公式计算得到
        else
            tbsize = 16896; %根据公式计算得到
        end
    case 2
        if prb_num==50
            tbsize = 10504; %根据公式计算得到
        else
            tbsize = 21000; %根据公式计算得到
        end
    case 3
        if prb_num==50
            tbsize = 19464; %根据公式计算得到
        else
            tbsize = 38936; %根据公式计算得到
        end
    case 4
        if prb_num==50
            tbsize = 37896; %根据公式计算得到
        else
            tbsize = 75792; %根据公式计算得到
        end
    case 5
        disp('module type is worng' );
end
end
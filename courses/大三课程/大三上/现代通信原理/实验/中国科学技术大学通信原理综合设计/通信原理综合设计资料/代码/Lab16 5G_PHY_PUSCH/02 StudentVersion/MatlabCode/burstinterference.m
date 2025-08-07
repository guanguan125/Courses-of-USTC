function out = burstinterference(inputdata,lenburst)

len = length(inputdata);
burstdata = zeros(1,len);
temp = abs(inputdata).^2;
signal_power = mean(temp);
noise_power = signal_power*10;
% noise_power = signal_power/100;
% noise_power = signal_power/10;
% noise_power =0.00;
temp1 = rand(1,lenburst)+j*rand(1,lenburst);
temp2 = sqrt(noise_power);
temp3 = temp1*temp2;
burstdata(1,1:lenburst) = temp3;
% out = inputdata + sqrt(noise_power)*(rand(1,len)+j*rand(1,len));
out = inputdata  + burstdata;
end
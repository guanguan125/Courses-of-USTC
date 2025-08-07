function devVal=mfFreqDev(pichData)
	pich_angle = angle(pichData);
            pich_xc = pich_angle(5:end-5)-pich_angle(6:end-4);
            for m = 1:length(pich_xc)
                if pich_xc(m) > 2*pi
                    pich_xc(m) = pich_xc(m) - 2*pi;
                elseif pich_xc(m) < -2*pi
                    pich_xc(m) = pich_xc(m) + 2*pi;    
                end
            end
	devVal=(median(pich_xc)*7.68*1000)/(pi);
end
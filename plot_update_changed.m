%%%%%%%%%%%%%%%%%%%%%%%%%%%%%update changed
%disp('Plotting update changed')
fileID = fopen(strcat(testDir,'update_changed.txt'));
C = textscan(fileID,'%*s %u64 %*s %*s %*s %*s %*s %*s %s %*s');
fclose(fileID);
if length(C{1}) ~= 0
    time = C{1};
    vcpu_ = C{2};
    vcpu=0;
    for i = 1:length(vcpu_)  
        s2 = vcpu_{i};
        vcpu_{i} = s2(end-1:end);
        v = hex2dec(sprintf('%s', vcpu_{i}));
        vcpu(i) = v;
    end

    ms = ticks_to_ms(time);
    plot(ms,vcpu,'^b')

    for i = 1:length(ms)
        h = text(ms(i),vcpu(i)+0.03,'update');
        set(h,'Clipping','on')
    end
end
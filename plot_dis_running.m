%%%%%%%%%%%%%%%%%%%%%%%%%%%%%dis_running job points
%disp('Plotting dis running job points')
fileID = fopen(strcat(testDir,'dis_running.txt'));
C = textscan(fileID,'%*s %u64 %*s %s %*s %*s %*s %*s %s %*s %*s %s %*s %*s %s %*s');
fclose(fileID);
time = C{1};
ms = ticks_to_ms(time);
vcpu_ = C{3};
vcpu = 0;
if length(time) ~= 0
    for i = 1:length(vcpu_)  
        s2 = vcpu_{i};
        vcpu_{i} = s2(end-2:end-1);
        v = hex2dec(sprintf('%s', vcpu_{i}));
        vcpu(i) = v;
    end

    plot(ms,vcpu,'og')
    for i = 1:length(ms)
        h=text(ms(i),vcpu(i)-0.2,'dis running job');
        set(h,'Clipping','on')
    end
end
disable_running = length(time);
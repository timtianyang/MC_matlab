%%%%%%%%%%%%%%%%%%%%%%%%%%%%%unrunnable points
%disp('Plotting unrunnable points')
fileID =fopen(strcat(testDir,'unrunnable.txt'));
C = textscan(fileID,'%*s %u64 %*s %*s %*s');
fclose(fileID);
time = C{1};
ms = ticks_to_ms(time);
mcr = 0*ms - 10.6;
if length(time) ~= 0
    plot(ms,mcr,'or')
    for i = 1:length(ms)
        h=text(ms(i),-10.6,'unrunnable');
        set(h,'Clipping','on')
    end
end
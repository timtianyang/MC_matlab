%%%%%%%%%%%%%%%%%%%%%%%%%%%%%MCR points
%disp('Plotting MCR points')
fileID =fopen(strcat(testDir,'mcr.txt'));
C = textscan(fileID,'%*s %u64 %*s %*s %*s');
fclose(fileID);
time = C{1};
ms = ticks_to_ms(time);
mcr = 0*ms - 10.6;
plot(ms,mcr,'or')
for i = 1:length(ms)
    h=text(ms(i),-10.6,'MCR');
    set(h,'Clipping','on')
end
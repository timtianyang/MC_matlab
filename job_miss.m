%%%%%%%%%%%%%%
%calculate job miss during MC
fileID = fopen(strcat(testDir,'burn.txt'));
C = textscan(fileID,'%*s %u64 %*s %*s %*s %*s %*s %*s %*s %*s %*s %*s %*s %*s %*s %*s %s %*s');
fclose(fileID);
time = C{1};
miss_ms = ticks_to_ms(time);
miss = C{2};
for i = 1:length(miss_ms)
   if miss_ms(i) > mcr && miss_ms(i) <= end_point3 && str2double(miss(i)) ~=0
    plot(miss_ms(i),-1,'r*')
   end       
end
return


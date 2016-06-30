%%%%%%%%%%%%%%%%%%%%%%%%%%%%%vcpu enable points
%disp('Plotting vcpu enable')
fileID = fopen(strcat(testDir,'vcpu_enable.txt'));
C = textscan(fileID,'%*s %u64 %*s %*s %*s %*s %*s %*s %s %*s');
fclose(fileID);
time = C{1};
vcpu__ = C{2};
vcpu=0;
for i = 1:length(vcpu__)  
    s2 = vcpu__{i};
    vcpu__{i} = s2(end-1:end);
    v = hex2dec(sprintf('%s', vcpu__{i}));
    vcpu(i) = v;
end


ms = ticks_to_ms(time);
plot(ms,vcpu,'db')

for i = 1:length(ms)
    h = text(ms(i),vcpu(i)-0.03,'enable');
    set(h,'Clipping','on')
end
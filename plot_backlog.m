%%%%%%%%%%%%%%%%%%%%%%%%%%%%%backlog points
%disp('Plotting baklog points')
fileID = fopen(strcat(testDir,'backlog.txt'));
C = textscan(fileID,'%*s %u64 %*s %*s %*s %*s %*s %*s %s %*s %s %*s %s %*s %s %*s %s %*s');
fclose(fileID);
time = C{1};
ms = ticks_to_ms(time);
vcpu__ = C{2};
oldnew = C{5};
runq_len = C{3};
thr = C{4};
comp = C{6};
vcpu = 0;
if length(time) ~= 0
    for i = 1:length(vcpu__)  
        s2 = vcpu__{i};
        vcpu__{i} = s2(end-1:end);
        v = hex2dec(sprintf('%s', vcpu__{i}));
        vcpu(i) = v;
    end


    for i = 1:length(ms)
        plot(ms(i),vcpu(i),'sb')
        label = strcat('backlog satisfied ',num2str(runq_len{i}),getCompString(comp{i}),num2str(thr{i}));
        h=text(ms(i),vcpu(i)+0.2,label);
        set(h,'Clipping','on')
    end
end
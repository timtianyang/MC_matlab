%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%disp('Plotting release time')
fileID = fopen(strcat(testDir,'release_job.txt'));
C = textscan(fileID,'%*s %u64 %*s %s %*s %*s %*s %*s %s %*s %*s %*s %*s %*s %*s %*s');
fclose(fileID);

time = C{1};
%delta = C{2};
vcpu_ = C{3};
vcpu = 0;

for i = 1:length(time)
%    s1 = delta{i};
    s2 = vcpu_{i};
    %delta{i} = s1(1:end-1);
    vcpu_{i} = s2(end-2:end-1);
    v = hex2dec(sprintf('%s', vcpu_{i}));
    vcpu(i) = v;
end

ms = ticks_to_ms(time);

for i = 1:length(vcpu)
    color = getVcpuColor(vcpu(i),nr_vcpu);
    plot(ms(i),vcpu(i),'Color',color,'Marker','*')
            
end

ylabel('vcpu#')

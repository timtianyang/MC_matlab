%%%%%%%%%%%%%%%%%%%%%%%%%%%%%queued jobs at MCR
%disp('Plotting queue jobs')
fileID = fopen(strcat(testDir,'job_queued.txt'));
C = textscan(fileID,'%*s %u64 %*s %*s %*s %*s %*s %*s %s %*s %*s %s %*s %*s %s %*s %*s %s %*s');
fclose(fileID);
if length(C{1}) ~= 0
    time = C{1};
    ms = ticks_to_ms(time);
    vcpu__ = C{2};
    deadline = C{4};
    mode = C{5};
    vcpu=0;
    %deadline_start = hex2dec(deadline{1}(3:end-1));
    for i = 1:length(vcpu__)  
        s2 = vcpu__{i};
        vcpu__{i} = s2(end-2:end-1);
        v = sscanf(sprintf('%s ', vcpu__{i}), '%d');

        vcpu(i) = v;
        deadline{i} = deadline{i}(3:end-1);
        deadline{i} = hex2dec(deadline{i});
        if deadline{i}<0
             deadline{i} = 0;
        else
             deadline{i} =  double(deadline{i})/1000000; %deadline in ms
        end
    end
  
    for i = 1:length(vcpu)
        pos = [ms(i) + i - 1,-10.5 , 1, 1];
        color = getVcpuColor(vcpu(i),nr_vcpu);
        rectangle('Position',pos,'FaceColor',color);
        label = strcat('v',int2str(vcpu(i)),' m',num2str(mode{i}),[char(10) 'd'],num2str(deadline{i}));
        h = text(ms(i) + i - 1,-10 ,label);
        set(h,'Clipping','on')
    end
end
buffer_size = length(vcpu);


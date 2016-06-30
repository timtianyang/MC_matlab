function release_new = find_release_new(testDir,nr_vcpu,mc_time)
    fileID = fopen(strcat(testDir,'release_job.txt'));
    C = textscan(fileID,'%*s %u64 %*s %s %*s %*s %*s %*s %s %*s %*s %*s %*s %*s %*s %*s');
    fclose(fileID);

    time = C{1};
    delta = C{2};
    vcpu_ = C{3};
    vcpu = 0;

    
    for i = 1:length(delta)
        s1 = delta{i};
        s2 = vcpu_{i};
        %delta{i} = s1(1:end-1);
        vcpu_{i} = s2(end-2:end-1);
        v = hex2dec(sprintf('%s', vcpu_{i}));
        vcpu(i) = v;
    end

    ms = ticks_to_ms(time);
    
    
    release_new = zeros(nr_vcpu,1);
   
   
    for i=1:length(vcpu)
        
       
        if release_new(vcpu(i)+1) == 0 && ms(i) > mc_time
           
            release_new(vcpu(i)+1) = ms(i);
        end
    end
    
    
end
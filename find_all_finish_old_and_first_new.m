function [all_finish_old_and_first_new,end_point3] = find_all_finish_old_and_first_new(nr_vcpu,vcpu,ms,deadline,finish_old,mode,new_mode,old_mode,mcr,vcpu_type)
    all_finish_old_and_first_new = zeros(nr_vcpu,1);
    
    %find the time the first job in the new mode is finished
    for i=1:nr_vcpu
        t = ms(vcpu == i-1);
        if (strcmp(vcpu_type(i),'old') ~= 1) %skip for old vcpus.
            v = vcpu(vcpu == i-1);
            d = deadline(vcpu == i-1);
            m = mode(vcpu == i-1);
            index = find(m == new_mode(i),1); %find the first job running in the new mode
            while d(index) == d(index+1)%check if preemption happened or not
                disp(strcat(['find_all_finish_old job preempted, vcpu:',num2str(i-1)]))
                index = index+1;
            end
            timeIndex = find(ms == t(index),1); %find the time of this running job in all sched times
            all_finish_old_and_first_new(i) = ms(timeIndex+1);
            
        else
            disp(strcat('skipping an old vcpu',num2str(i-1)))
        end
    end
    
   %find the max between finish_old and finish_new
   all_finish_old_and_first_new = max(all_finish_old_and_first_new,finish_old);
   end_point3 = max(all_finish_old_and_first_new);
    
end
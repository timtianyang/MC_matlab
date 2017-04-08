clear; clc;hold on
%unix('./transfer');
benchmark_only=0;

totalTest = 1000;
testNum = 0;
%endpoint 1: the average delay when finishing old jobs for each vcpu.
%sometimes the mcr happens after all old jobs are finished so the actual
%number of valid numbers may vary. Do the check to filter out negative
%values:q
average_finish_old_delay = 0; %max 64

%endpoint 2: the average delay when releasing the first new job for each vcpu.
%sometimes the vcpu might not have new jobs so the actual
%number of valid numbers may vary. Do the check to filter out negative
%values
average_release_new_delay = 0;

%endpoint 3: the average delay when finishing all oldjobs for all vcpu and
%finishing the first new job for all vcpu. It is a single point for a
%protocol. Simply take the average of all runs.
average_end_point3_delay = 0;
finish_old_valid_run = 0;
release_new_valid_run = 0;

%used to plot delays on _every_ vcpu. if the delay doesnt exist, pad with
%zero. assume max vcpu numer is 64
endpoint1trend = 0; %first new job release
endpoint2trend = 0; %all old jobs finished
endpoint3trend = 0; %first new jobs of this vcpu have been finished

maxendpoint1 = zeros(1,totalTest);
maxendpoint2 = zeros(1,totalTest);
maxendpoint3 = zeros(1,totalTest);

%these records average over all tests
schedule_time = zeros(1,totalTest); %time spent in the schedule function
context_time = zeros(1,totalTest);
schedule_time_no_idle = zeros(1,totalTest); %time spent in the schedule function
context_time_no_idle = zeros(1,totalTest);
repl_time = zeros(1,totalTest);
mc_time = zeros(1,totalTest); %time spent in mc logic(not including passing)

%protocol wise tracing
total_disable_not_running = 0;
total_disable_running = 0;
total_buffer_size = 0;

printTestDetail = 0;


while testNum<totalTest
    testDir = strcat('async_period/16vcpu/test',int2str(testNum),'/');
    
    %%%%%%%%%%%%%%%%%this block does micro-benchmark
    xen_bench
    
    %sum the average of all tests and find another average
    schedule_time(testNum + 1) = avg_sched_overhead;
    context_time(testNum + 1) = avg_context_overhead;
    schedule_time_no_idle(testNum + 1) = sub_idle_avg_sched_overhead;
    context_time_no_idle(testNum + 1) = sub_idle_avg_context_overhead;
    repl_time(testNum + 1) = avg_repl_overhead;
    mc_time(testNum + 1) = avg_mc_overhead;
    %%%%%%%%%%%%%%%%%%
    
    
    if (benchmark_only==0)
        fig = figure(1);
        ylim([-20 20])
        set(fig, 'Position', get(0, 'Screensize'));
        
        parse_mode_change_info
        
        plot_sched
        
        
        plot_release
        
        plot_dis_not_running
        
        plot_dis_running
        
        plot_backlog
        
        plot_mcr
        
        plot_unrunnable
        
        plot_cpu_enable
        
        plot_update_changed
        
        plot_queued_jobs
        
        % set(fig, 'Units', 'normalized', 'Position', [0,0,1,1]);
        %ylabel(strcat('test ',int2str(testNum)))
        
        
        %calculating the average
        %init all arrays
        if average_finish_old_delay == 0
            average_finish_old_delay = zeros(nr_vcpu,1);
            average_release_new_delay = zeros(nr_vcpu,1);
            average_end_point3_delay = zeros(nr_vcpu,1);
            finish_old_valid_run = zeros(nr_vcpu,1);
            release_new_valid_run = zeros(nr_vcpu,1);
        end
        %init trend arrays
        if endpoint1trend == 0
            endpoint1trend = zeros(nr_vcpu+1,totalTest);%plus one to include the protocol trend
            endpoint2trend = zeros(nr_vcpu+1,totalTest);
            endpoint3trend = zeros(nr_vcpu+1,totalTest);
        end
        
        max_release_new_delay = 0;
        max_finish_old_delay = 0;
        max_finish_old_and_first_new_delay = 0;
        
        for p=1:nr_vcpu
            if mcr_latency_finish_old(p)>=0
                average_finish_old_delay(p) = average_finish_old_delay(p) + mcr_latency_finish_old(p);
                finish_old_valid_run(p) = finish_old_valid_run(p)+1;
                endpoint2trend(p,testNum+1) = mcr_latency_finish_old(p);
                
                if max_finish_old_delay < mcr_latency_finish_old(p)
                    max_finish_old_delay = mcr_latency_finish_old(p);
                end
            end
            
            
            if mcr_latency_release_new(p)>=0
                average_release_new_delay(p) = average_release_new_delay(p) + mcr_latency_release_new(p);
                release_new_valid_run(p) = release_new_valid_run(p)+1;
                endpoint1trend(p,testNum+1) = mcr_latency_release_new(p);
                
                if max_release_new_delay < mcr_latency_release_new(p)
                    max_release_new_delay = mcr_latency_release_new(p);
                end
            end
            
            average_end_point3_delay(p) = average_end_point3_delay(p) + vcpu_endpoint3_latency(p);
            
            endpoint3trend(p,testNum+1) = vcpu_endpoint3_latency(p);%only want the latency from mcr
            
            if max_finish_old_and_first_new_delay < vcpu_endpoint3_latency(p)
                max_finish_old_and_first_new_delay = vcpu_endpoint3_latency(p);
            end
            %delay for each individual vcpu. end_point3_delay simply finds the
            %max in the array.
        end
        maxendpoint1(testNum + 1) = max_release_new_delay;
        maxendpoint2(testNum + 1) = max_finish_old_delay;
        maxendpoint3(testNum + 1) = max_finish_old_and_first_new_delay;
        
        
        
        %sum up all aborted jobs across all runs
        total_disable_not_running = total_disable_not_running + disable_not_running;
        total_disable_running = total_disable_running + disable_running;
        total_buffer_size = total_buffer_size + buffer_size;
        
        while testNum == 0
            w = waitforbuttonpress;
            if w ~= 0
                break;
            end
        end
    end
    
    testNum
    testNum = testNum+1;
    close all
    
    disp('+++++++++++++++++++++++')
    
end
fclose('all');

if ( benchmark_only == 0)
    %only use positive delay as valid run.
    average_finish_old_delay = average_finish_old_delay./finish_old_valid_run;
    average_release_new_delay = average_release_new_delay./release_new_valid_run;
    average_end_point3_delay = average_end_point3_delay./totalTest;
    
    average_disable_running = total_disable_running/totalTest
    average_disable_not_running = total_disable_not_running/totalTest
    average_total_buffer_size = total_buffer_size/totalTest
    
    disp('endpoints')
    for i=1:nr_vcpu
        if (isnan(average_finish_old_delay(i)))
            average_finish_old_delay(i)=0;
        end
        fprintf('%d & %f & %f & %f \\\\ \n', i-1, average_release_new_delay(i),average_finish_old_delay(i),average_end_point3_delay(i))
    end
    fprintf('\\hline\nmax & %f & %f & %f \\\\\n\\hline\n',max(average_release_new_delay),max(average_finish_old_delay),max(average_end_point3_delay));
end

average_schedule_time = mean(schedule_time);
max_schedule_time = max(schedule_time);
fprintf('schedule_time %.0f/%.0f\n',average_schedule_time,max_schedule_time);
fprintf('schedule_time_no_idle %.0f/%.0f\n',mean(schedule_time_no_idle),max(schedule_time_no_idle));
average_context_time = mean(context_time);
max_context_time = max(context_time);
fprintf('context_time %.0f/%.0f\n',average_context_time,max_context_time);
fprintf('context_time_no_idle %.0f/%.0f\n',mean(context_time_no_idle),max(context_time_no_idle));
average_repl_time = mean(repl_time);
max_repl_time = max(repl_time);
fprintf('repl_time %.0f/%.0f\n',average_repl_time,max_repl_time);
average_mc_time = mean(mc_time);
max_mc_time = max(mc_time);
fprintf('mc_time %.0f/%.0f\n',average_mc_time,max_mc_time);

if ( benchmark_only == 0)
    
    %plotting the endpoint trend
    x = 1:totalTest;
    
    
    figure(3)
    j = 0;
    for i=1:nr_vcpu
        j = j+1;
        subplot(nr_vcpu+1,3,j)
        plot(x,endpoint1trend(i:i,:),'-*');
        ylabel(sprintf('v%d\n%s',i-1,strjoin(vcpu_type(i))))
        if j==1
            title('endpoint1- first new job release')
        end
        j = j+1;
        subplot(nr_vcpu+1,3,j)
        plot(x,endpoint2trend(i:i,:),'-*');
        
        if j==2
            title('endpoint2- all old jobs finished')
        end
        j = j+1;
        subplot(nr_vcpu+1,3,j)
        plot(x,endpoint3trend(i:i,:),'-*');
        
        if j==3
            title('endpoint3- all old jobs and first new job finished')
        end
    end
    %here the last row is the max. Can be used to benchmark a protocol
    j = j+1;
    subplot(nr_vcpu+1, 3, j);
    plot(x, maxendpoint1,'-*');
    ylabel('max of all vcpu')
    j = j+1;
    subplot(nr_vcpu+1, 3, j);
    plot(x, maxendpoint2,'-*');
    j = j+1;
    subplot(nr_vcpu+1, 3, j);
    plot(x, maxendpoint3,'-*');
    
    
    %plot the micro bench mark fo all tests
    figure(4)
    subplot(2,2,1);
    plot(x,schedule_time,'-*');
    title('schedule overhead ns')
    subplot(2,2,2);
    plot(x,context_time,'-*');
    title('context overhead ns')
    subplot(2,2,3);
    plot(x,repl_time,'-*');
    title('repl overhead ns')
    subplot(2,2,4);
    plot(x,mc_time,'-*');
    title('mc logic overhead ns')
end
clear; clc;hold on
%unix('./transfer')



testNum = 0;
%endpoint 1: the average delay when finishing old jobs for each vcpu.
%sometimes the mcr happens after all old jobs are finished so the actual
%number of valid numbers may vary. Do the check to filter out negative
%values
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

while testNum<10
    
    testDir = strcat('modechange/test',int2str(testNum),'/');
    fig = figure(1);
    plot_sched


    plot_release

    plot_dis_not_running

    plot_dis_running

    plot_backlog

    plot_mcr

    plot_cpu_enable

    plot_update_changed

    plot_queued_jobs
    
    set(fig, 'Units', 'normalized', 'Position', [0,0,1,1]);
    ylabel(strcat('test ',int2str(testNum)))
    
    
    %calculating the average
    if average_finish_old_delay == 0
        average_finish_old_delay = zeros(nr_vcpu,1);
        average_release_new_delay = zeros(nr_vcpu,1);
        finish_old_valid_run = zeros(nr_vcpu,1);
        release_new_valid_run = zeros(nr_vcpu,1);
    end
    for p=1:nr_vcpu
        if mcr_latency_finish_old(p)>=0
            average_finish_old_delay(p) = average_finish_old_delay(p) + mcr_latency_finish_old(p);
            finish_old_valid_run(p) = finish_old_valid_run(p)+1;
        end
        if mcr_latency_release_new(p)>=0
            average_release_new_delay(p) = average_release_new_delay(p) + mcr_latency_release_new(p);
            release_new_valid_run(p) = release_new_valid_run(p)+1;
        end
    end
    
    average_end_point3_delay = average_end_point3_delay + end_point3_delay;
    
    %savefig(strcat(testDir,'plot.fig'))
%     while 1 == 1
%         w = waitforbuttonpress;
%         if w ~= 0
%             break;
%         end
%     end
    testNum = testNum+1;
    close all
end

%only use positive delay as valid run.
average_finish_old_delay = average_finish_old_delay./finish_old_valid_run
average_release_new_delay = average_release_new_delay./release_new_valid_run
average_end_point3_delay = average_end_point3_delay/testNum
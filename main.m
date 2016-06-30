clear; clc;hold on
%unix('/transfer')



testNum = 0;
average_finish_old_delay = 0; %max 64
average_release_new_delay = 0;

while testNum<50
    
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
    
    %set(fig, 'Units', 'normalized', 'Position', [0,0,1,1]);
    ylabel(strcat('test ',int2str(testNum)))
    
    
    %calculating the average
    if average_finish_old_delay == 0
        average_finish_old_delay = zeros(nr_vcpu,1);
        average_release_new_delay = zeros(nr_vcpu,1);
    end
    for p=1:nr_vcpu
        average_finish_old_delay(p) = average_finish_old_delay(p) + mcr_latency_finish_old(p);
        average_release_new_delay(p) = average_release_new_delay(p) + mcr_latency_release_new(p);
    end
    
    
    %w = waitforbuttonpress;
    testNum = testNum+1;
    close all
end
average_finish_old_delay = average_finish_old_delay/testNum
average_release_new_delay = average_release_new_delay/testNum
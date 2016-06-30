
clear; clc;hold on
unix('~/transfer')
fig = figure(1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Plotting release time')
fileID = fopen('modechange/release_job.txt');
C = textscan(fileID,'%*s %u64 %*s %s %*s %*s %*s %*s %s %*s %*s %*s %*s %*s %*s %*s');
fclose(fileID);

time = C{1};
start_release = time(1);
delta = C{2};
vcpu = C{3};
nr_vcpu = 0;
for i = 1:length(delta)
    s1 = delta{i};
    s2 = vcpu{i};
    %delta{i} = s1(1:end-1);
    vcpu{i} = s2(end-2:end-1);
    v = sscanf(sprintf('%s ', vcpu{i}), '%d') +1;
    if (nr_vcpu < v)
        nr_vcpu = v;
    end
    %time(i) = time(i) - start_release;
end


S = sprintf('%s ', vcpu{:});
vcpu = sscanf(S, '%d');
ms = ticks_to_ms(time);

for i = 1:length(vcpu)
    color = getVcpuColor(vcpu(i));
    plot(ms(i),vcpu(i),'Color',color,'Marker','*')
            
end

ylabel('vcpu#')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Plotting scheduling events')
fileID = fopen('modechange/schedule.txt');
C = textscan(fileID,'%*s %u64 %*s %s %*s %*s %*s %*s %s %*s %*s %s %*s %*s %*s %*s %*s %s %*s');
fclose(fileID);
time = C{1};
deadline = C{4};
deadline_start = hex2dec(deadline{1}(3:end-1));

start = time(1);
%delta = C{2};
vcpu = C{3};
%budget = C{4};
mode = C{5};
for i = 1:length(vcpu)  
    s2 = vcpu{i};
    deadline{i} = deadline{i}(3:end-1);
    deadline{i} = hex2dec(deadline{i});
    if deadline{i}<0
         deadline{i} = 0;
    else
         deadline{i} =  double(deadline{i}-deadline_start)/1000000; %deadline in ms
    end
    vcpu{i} = s2(end-2:end-1);
end
S = sprintf('%s ', vcpu{:});
vcpu = sscanf(S, '%d');
ms = ticks_to_ms(time);

for i = 1:(length(time) - 1)
   pos = [ms(i),-10.5, ms(i+1) - ms(i), 10];
   add_text = 1;
   color = getVcpuColor(vcpu(i));
   if color == [0 0 0]
           add_text = 0;
   end
   
   rectangle('Position',pos,'FaceColor',color);
   if add_text == 1
       label = strcat('v',int2str(vcpu(i)),' m',num2str(mode{i}),[char(10) 'd'],num2str(deadline{i}));
   	   h=text(ms(i),-5,label);
       set(h,'Clipping','on')
   end
end
title('circle-disable, diamand-enable, square-backlog, triangle-update, star-release')
xlabel('time in ms')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%dis_not_running job points
disp('Plotting dis not running job points')
fileID = fopen('modechange/dis_not_running.txt');
C = textscan(fileID,'%*s %u64 %*s %s %*s %*s %*s %*s %s %*s');
fclose(fileID);
time = C{1};
ms = ticks_to_ms(time);
vcpu = C{3};
for i = 1:length(vcpu)  
    s2 = vcpu{i};
    vcpu{i} = s2(end-1:end);
end
S = sprintf('%s ', vcpu{:});
vcpu = sscanf(S, '%d');    
plot(ms,vcpu,'ob')
for i = 1:length(ms)
    h=text(ms(i),vcpu(i)-0.2,'dis not running job');
    set(h,'Clipping','on')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%dis_running job points
disp('Plotting dis running job points')
fileID = fopen('modechange/dis_running.txt');
C = textscan(fileID,'%*s %u64 %*s %s %*s %*s %*s %*s %s %*s %*s %s %*s %*s %s %*s');
fclose(fileID);
time = C{1};
ms = ticks_to_ms(time);
vcpu = C{3};
for i = 1:length(vcpu)  
    s2 = vcpu{i};
    vcpu{i} = s2(end-2:end-1);
end
S = sprintf('%s ', vcpu{:});
vcpu = sscanf(S, '%d');  
plot(ms,vcpu,'og')
for i = 1:length(ms)
    h=text(ms(i),vcpu(i)-0.2,'dis running job');
    set(h,'Clipping','on')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%backlog points
disp('Plotting baklog points')
fileID = fopen('modechange/backlog.txt');
C = textscan(fileID,'%*s %u64 %*s %*s %*s %*s %*s %*s %s %*s %s %*s %s %*s %s %*s %s %*s');
fclose(fileID);
time = C{1};
ms = ticks_to_ms(time);
vcpu = C{2};
oldnew = C{5};
runq_len = C{3};
thr = C{4};
comp = C{6};

for i = 1:length(vcpu)  
    s2 = vcpu{i};
    vcpu{i} = s2(end-1:end);
end
S = sprintf('%s ', vcpu{:});
vcpu = sscanf(S, '%d');

for i = 1:length(ms)
    plot(ms(i),vcpu(i),'sb')
    label = strcat('backlog satisfied ',num2str(runq_len{i}),getCompString(comp{i}),num2str(thr{i}));
    h=text(ms(i),vcpu(i)+0.2,label);
    set(h,'Clipping','on')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%MCR points
disp('Plotting MCR points')
fileID = fopen('modechange/mcr.txt');
C = textscan(fileID,'%*s %u64 %*s %*s %*s');
fclose(fileID);
time = C{1};
ms = ticks_to_ms(time);
mcr = 0*ms - 10.6;
plot(ms,mcr,'or')
for i = 1:length(ms)
    h=text(ms(i),-10.6,'MCR');
    set(h,'Clipping','on')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%vcpu enable points
disp('Plotting vcpu enable')
fileID = fopen('modechange/vcpu_enable.txt');
C = textscan(fileID,'%*s %u64 %*s %*s %*s %*s %*s %*s %s %*s');
fclose(fileID);
time = C{1};
vcpu = C{2};
for i = 1:length(vcpu)  
    s2 = vcpu{i};
    vcpu{i} = s2(end-1:end);
end
S = sprintf('%s ', vcpu{:});
vcpu = sscanf(S, '%d'); 

ms = ticks_to_ms(time);
plot(ms,vcpu,'db')

for i = 1:length(ms)
    h = text(ms(i),vcpu(i)-0.03,'enable');
    set(h,'Clipping','on')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%update changed
disp('Plotting update changed')
fileID = fopen('modechange/update_changed.txt');
C = textscan(fileID,'%*s %u64 %*s %*s %*s %*s %*s %*s %s %*s');
fclose(fileID);
if length(C{1}) ~= 0
    time = C{1};
    vcpu = C{2};
    for i = 1:length(vcpu)  
        s2 = vcpu{i};
        vcpu{i} = s2(end-1:end);
    end
    S = sprintf('%s ', vcpu{:});
    vcpu = sscanf(S, '%d'); 

    ms = ticks_to_ms(time);
    plot(ms,vcpu,'^b')

    for i = 1:length(ms)
        h = text(ms(i),vcpu(i)+0.03,'update');
        set(h,'Clipping','on')
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%queued jobs at MCR
disp('Plotting queue jobs')
fileID = fopen('modechange/job_queued.txt');
C = textscan(fileID,'%*s %u64 %*s %*s %*s %*s %*s %*s %s %*s %*s %s %*s %*s %s %*s %*s %s %*s');
fclose(fileID);
if length(C{1}) ~= 0
    time = C{1};
    ms = ticks_to_ms(time);
    vcpu = C{2};
    deadline = C{4};
    mode = C{5};
    %deadline_start = hex2dec(deadline{1}(3:end-1));
    for i = 1:length(vcpu)  
        s2 = vcpu{i};
        vcpu{i} = s2(end-2:end-1);
        deadline{i} = deadline{i}(3:end-1);
        deadline{i} = hex2dec(deadline{i});
        if deadline{i}<0
             deadline{i} = 0;
        else
             deadline{i} =  double(deadline{i})/1000000; %deadline in ms
        end
    end
    S = sprintf('%s ', vcpu{:});
    vcpu = sscanf(S, '%d'); 
    for i = 1:length(vcpu)
        pos = [ms(i),-10.5 - i, 1, 1];
        color = getVcpuColor(vcpu(i));
        rectangle('Position',pos,'FaceColor',color);
        label = strcat('v',int2str(vcpu(i)),' m',num2str(mode{i}),[char(10) 'd'],num2str(deadline{i}));
        h = text(ms(i),-10 - i,label);
        set(h,'Clipping','on')
    end
end

set (fig, 'Units', 'normalized', 'Position', [0,0,1,1]);
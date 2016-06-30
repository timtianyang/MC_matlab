%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%disp('Plotting scheduling events')
fileID = fopen(strcat(testDir,'schedule.txt'));
C = textscan(fileID,'%*s %u64 %*s %s %*s %*s %*s %*s %s %*s %*s %s %*s %*s %*s %*s %*s %s %*s');
fclose(fileID);
time = C{1};
deadline = C{4};
deadline_start = hex2dec(deadline{1}(3:end-1));

start = time(1);
%delta = C{2};
vcpu_ = C{3};
%budget = C{4};
mode = C{5};
S = sprintf('%s ', mode{:});
mode = sscanf(S, '%d');

old_mode = 0; %assuming only the transition is traced
new_mode = 0;

nr_vcpu = 0;
vcpu=0;
for i = 1:length(vcpu_)  
    s2 = vcpu_{i};
    deadline{i} = deadline{i}(3:end-1);
    deadline{i} = hex2dec(deadline{i});
    if deadline{i}<0
         deadline{i} = 0;
    else
         deadline{i} =  double(deadline{i}-deadline_start)/1000000; %deadline in ms
    end
    
    vcpu_{i} =s2(end-2:end-1);
    
    v = hex2dec(sprintf('%s', vcpu_{i}));
    vcpu(i) = v;
    if v ~= 64
        if new_mode < mode(i)
            new_mode = mode(i);
        end
        if nr_vcpu < v
            nr_vcpu = v;
        end
        
    end
end
nr_vcpu = nr_vcpu+1;
old_mode= new_mode-1; %assume one transition only
idle_vcpu_id = 64;

ms = ticks_to_ms(time);

for i = 1:(length(time) - 1)
   pos = [ms(i),-10.5, ms(i+1) - ms(i), 10];
   add_text = 1;
   color = getVcpuColor(vcpu(i),nr_vcpu);
   if color == [0 0 0]
           add_text = 0;
   end
   
   rectangle('Position',pos,'FaceColor',color);
   if add_text == 1 && vcpu(i) ~= idle_vcpu_id 
       label = strcat('v',int2str(vcpu(i)),' m',int2str(mode(i)),[char(10) 'd'],num2str(deadline{i}));
   	   h=text(ms(i),-5,label);
       set(h,'Clipping','on')
   end
end
title('circle-disable, diamand-enable, square-backlog, triangle-update, star-release')
xlabel('time in ms')



%read the mcr file, assuming there is only one mcr
fileID = fopen(strcat(testDir,'mcr.txt'));
C = textscan(fileID,'%*s %u64 %*s %*s %*s');
fclose(fileID);
mcr_time = C{1};
mcr = ticks_to_ms(mcr_time);




%finding the endpoint of modechange
%two arrays representing two different types of endpoint
release_new = find_release_new(testDir,nr_vcpu,mcr);
finish_old = zeros(nr_vcpu,1);

%this loop can find the release new easily but need another loop
%to find finish_old
release_v = 0;



for i = 1:length(vcpu) 
    if (vcpu(i) ~= idle_vcpu_id )
        if (finish_old(vcpu(i)+1) < ms(i) && mode(i) == old_mode)
            finish_old(vcpu(i)+1) = ms(i);
        end
    end
end
for i = 1:length(vcpu)
    if (vcpu(i) ~= idle_vcpu_id )
        if(finish_old(vcpu(i)+1) == ms(i))
            finish_old(vcpu(i)+1) = ms(i+1);
        end
    end
end
hold on

%two arrays storing two different types of mcr duration calculated from
%previous arrays
mcr_latency_finish_old = zeros(nr_vcpu,1);
mcr_latency_release_new = zeros(nr_vcpu,1);


%actual loop that finds the diff and prints the texts
for i = 1:nr_vcpu
    
   if (release_new(i) ~= 0)
       label = strcat('v',int2str(i-1),[char(10) 'r'],'elease new');
       h=text(release_new(i),-11.8,label);
       set(h,'Clipping','on')
       mcr_latency_release_new(i) = release_new(i) - mcr(1);
       disp(strcat('v',int2str(i-1),' mcr_release_new delay=',' ', num2str(mcr_latency_release_new(i)),'ms'));
   end
   label = strcat('v',int2str(i-1),[char(10) 'f'],'nish old');
   h=text(finish_old(i),-12.6,label);
   set(h,'Clipping','on')
   
   mcr_latency_finish_old(i) = finish_old(i) - mcr(1);
   if ( mcr_latency_finish_old(i) >= 0)
    disp(strcat('v',int2str(i-1),' mcr_finish_old delay=',' ', num2str(mcr_latency_finish_old(i)),'ms'));
   end
end


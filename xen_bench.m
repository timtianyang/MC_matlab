fileID = fopen(strcat(testDir,'sched_time.txt'));
C = textscan(fileID,'%*s %*s %*s %*s %*s %*s %*s %*s %s %*s %*s %s %*s');
time_hex = C{2};
vcpu_ = C{1};
time_dec=zeros(length(time_hex) ,1);
vcpu=zeros(length(time_hex) ,1);

for i = 1:length(time_hex) 
    s2 = vcpu_{i};
    vcpu_{i} =s2(end-2:end-1);
    time_hex{i} = time_hex{i}(3:end);
    v = hex2dec(sprintf('%s', vcpu_{i}));
    vcpu(i) = v;
    
    d =  hex2dec(sprintf('%s', time_hex{i}));
    time_dec(i) = d;
end

avg_sched_overhead = sum(time_dec)/length(time_hex);
%fprintf('average sched overhead = %.0f ns\n',avg_sched_overhead);
idle_context = length(time_dec(vcpu==64));
sub_idle_avg_sched_overhead=avg_sched_overhead;
if ( idle_context ~=0 )
    sub_idle_avg_sched_overhead = (sum(time_dec) - sum(time_dec(vcpu==64)) ) / (length(time_dec) - idle_context);
    %fprintf('without %d idle_sched = %.0f\n', idle_context,sub_idle_avg_sched_overhead);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fileID = fopen(strcat(testDir,'context_time.txt'));
C = textscan(fileID,'%*s %*s %*s %*s %*s %*s %*s %*s %*s %*s %*s %s %*s %*s %*s %s %*s');
time_hex = C{1};
time_dec=zeros(length(time_hex) ,1);
vcpu_ = C{1};
vcpu=zeros(length(time_hex) ,1);

for i = 1:length(time_hex) 
    s2 = vcpu_{i};
    vcpu_{i} =s2(end-2:end-1);
    time_hex{i} = time_hex{i}(3:end);
    v = hex2dec(sprintf('%s', vcpu_{i}));
    vcpu(i) = v;
    
    time_hex{i} = time_hex{i}(3:end); 
    d =  hex2dec(sprintf('%s', time_hex{i}));
    time_dec(i) = d;
end

avg_context_overhead = sum(time_dec)/length(time_hex);
%fprintf('average context overhead = %.0f ns\n',avg_context_overhead);
idle_context = length(time_dec(vcpu==64));
sub_idle_avg_context_overhead=avg_context_overhead;
if ( idle_context ~=0 )
    sub_idle_avg_context_overhead = (sum(time_dec) - sum(time_dec(vcpu==64)) ) / (length(time_dec) - idle_context);
    %fprintf('without %d idle_context = %.0f\n', idle_context,sub_idle_avg_context_overhead);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fileID = fopen(strcat(testDir,'repl_time.txt'));
C = textscan(fileID,'%*s %*s %*s %*s %*s %*s %*s %*s %s %*s');
time_hex = C{1};
time_dec=zeros(length(time_hex) ,1);


for i = 1:length(time_hex) 
    time_hex{i} = time_hex{i}(3:end); 
    d =  hex2dec(sprintf('%s', time_hex{i}));
    time_dec(i) = d;
end

avg_repl_overhead = sum(time_dec)/length(time_hex);
%fprintf('average repl overhead = %.0f ns \n',avg_repl_overhead);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fileID = fopen(strcat(testDir,'mc_time.txt'));
C = textscan(fileID,'%*s %*s %*s %*s %*s %*s %*s %*s %s %*s');
time_hex = C{1};
time_dec=zeros(length(time_hex) ,1);


for i = 1:length(time_hex) 
    time_hex{i} = time_hex{i}(3:end); 
    d =  hex2dec(sprintf('%s', time_hex{i}));
    time_dec(i) = d;
end

avg_mc_overhead = sum(time_dec)/length(time_hex);
%fprintf('average mc overhead = %.0f ns \n',avg_mc_overhead);
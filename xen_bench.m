fileID = fopen(strcat(testDir,'sched_time.txt'));
C = textscan(fileID,'%*s %*s %*s %*s %*s %*s %*s %*s %*s %*s %*s %s %*s');
time_hex = C{1};
time_dec=zeros(length(time_hex) ,1);


for i = 1:length(time_hex) 
    time_hex{i} = time_hex{i}(3:end); 
    d =  hex2dec(sprintf('%s', time_hex{i}));
    time_dec(i) = d;
end

avg_sched_overhead = sum(time_dec)/length(time_hex);
disp(strcat('average sched overhead =',num2str(avg_sched_overhead),'ns'))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fileID = fopen(strcat(testDir,'context_time.txt'));
C = textscan(fileID,'%*s %*s %*s %*s %*s %*s %*s %*s %*s %*s %*s %s %*s %*s %*s %s %*s');
time_hex = C{1};
time_dec=zeros(length(time_hex) ,1);


for i = 1:length(time_hex) 
    time_hex{i} = time_hex{i}(3:end); 
    d =  hex2dec(sprintf('%s', time_hex{i}));
    time_dec(i) = d;
end

avg_context_overhead = sum(time_dec)/length(time_hex);
disp(strcat('average context switch overhead =',num2str(avg_context_overhead),'ns'))
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
disp(strcat('average repl overhead =',num2str(avg_repl_overhead),'ns'))
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
disp(strcat('average mc overhead =',num2str(avg_mc_overhead),'ns'))
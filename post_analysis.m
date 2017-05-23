clc
clear
close all

normalize=1;

data=load('../endpoints');
%format:    min_period
%           min_no_period
%           max_period
%           async_period
%           async_no_period

if normalize == 1
   data(21:4:40)= data(21:4:40)/12;
   data(22:4:40)= data(22:4:40)/6;
   data(23:4:40)= data(23:4:40)/3;
   data(24:4:40)= data(24:4:40)/1.5;
end


i=1;

%three endpoints, same proto, diff num of vcpu
min_period_release_new = data(1:4,1);
min_no_period_release_new = data(5:8,1);
max_period_release_new = data(9:12,1);
async_period_release_new = data(13:16,1);
async_no_period_release_new = data(17:20,1);

min_period_finish_old = data(1:4,2);
min_no_period_finish_old = data(5:8,2);
max_period_finish_old = data(9:12,2);
async_period_finish_old = data(13:16,2);
async_no_period_finish_old = data(17:20,2);

min_period_finish_new_old = data(1:4,3);
min_no_period_finish_new_old = data(5:8,3);
max_period_finish_new_old = data(9:12,3);
async_period_finish_new_old = data(13:16,3);
async_no_period_finish_new_old = data(17:20,3);

figure(i);i=i+1;
hold on
plot(min_period_release_new,'*-')
plot(min_period_finish_old,'*-')
plot(min_period_finish_new_old,'*-')
if normalize == 1
    title('minimal offset with periodicity protocol(finish old normalized)')
else
    title('minimal offset with periodicity protocol')
end
legend('release\_new','finish\_old','finish\_new\_old')
set(gca,'XTick',[1:4])
set(gca,'XTickLabel',{'4vcpu','8vcpu','16vcpu','32vcpu'})
ylabel('ms')

figure(i);i=i+1;
hold on
plot(min_no_period_release_new,'*-')
plot(min_no_period_finish_old,'*-')
plot(min_no_period_finish_new_old,'*-')


if normalize == 1
    title('minimal offset without periodicity protocol(finish old normalized)')
else
    title('minimal offset without periodicity protocol')
end

legend('release\_new','finish\_old','finish\_new\_old')
set(gca,'XTick',[1:4])
set(gca,'XTickLabel',{'4vcpu','8vcpu','16vcpu','32vcpu'})
ylabel('ms')

figure(i);i=i+1;
hold on
plot(max_period_release_new,'*-')
plot(max_period_finish_old,'*-')
plot(max_period_finish_new_old,'*-')

if normalize == 1
    title('maximum period offset protocol(finish old normalized)')
else
    title('maximum period offset protocol')
end

legend('release\_new','finish\_old','finish\_new\_old')
set(gca,'XTick',[1:4])
set(gca,'XTickLabel',{'4vcpu','8vcpu','16vcpu','32vcpu'})
ylabel('ms')

figure(i);i=i+1;
hold on
plot(async_period_release_new,'*-')
plot(async_period_finish_old,'*-')
plot(async_period_finish_new_old,'*-')

if normalize == 1
    title('async with periodicity protocol(finish old normalized)')
else
    title('async with periodicity protocol')
end
legend('release\_new','finish\_old','finish\_new\_old')
set(gca,'XTick',[1:4])
set(gca,'XTickLabel',{'4vcpu','8vcpu','16vcpu','32vcpu'})
ylabel('ms')

figure(i);i=i+1;
hold on
plot(async_no_period_release_new,'*-')
plot(async_no_period_finish_old,'*-')
plot(async_no_period_finish_new_old,'*-')

if normalize == 1
    title('async without periodicity protocol(finish old normalized)')
else
    title('async without periodicity protocol')
end
legend('release\_new','finish\_old','finish\_new\_old')
set(gca,'XTick',[1:4])
set(gca,'XTickLabel',{'4vcpu','8vcpu','16vcpu','32vcpu'})
ylabel('ms')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





%diff proto, same num of vcpu
v4_release_new = data(1:4:20);
v8_release_new = data(2:4:20);
v16_release_new = data(3:4:20);
v32_release_new = data(4:4:20);

v4_finish_old =data(21:4:40);
v8_finish_old = data(22:4:40);
v16_finish_old = data(23:4:40);
v32_finish_old = data(24:4:40);

v4_finish_new_old = data(41:4:60);
v8_finish_new_old = data(42:4:60);
v16_finish_new_old = data(43:4:60);
v32_finish_new_old = data(44:4:60);
return

figure(i);i=i+1;
hold on
plot(v4_release_new,'*-')
plot(v8_release_new,'*-')
plot(v16_release_new,'*-')
plot(v32_release_new,'*-')
title('release new')
legend('4vcpu','8vcpu','16vcpu','32vcpu')
set(gca,'XTick',[1:5])
set(gca,'XTickLabel',{'min\_offset\_period','min\_offset\_no\_period','max\_offset','async\_period','async\_no\_period'})
ylabel('ms')
ax = gca;
ax.XTickLabelRotation=15;

figure(i);i=i+1;
hold on
plot(v4_finish_old,'*-')
plot(v8_finish_old,'*-')
plot(v16_finish_old,'*-')
plot(v32_finish_old,'*-')
if normalize == 1
    title('finish old (normalized)')
else
    title('finish old')
end
legend('4vcpu','8vcpu','16vcpu','32vcpu')
set(gca,'XTickLabel',{})
set(gca,'XTick',[1:5])
set(gca,'XTickLabel',{'min\_offset\_period','min\_offset\_no\_period','max\_offset','async\_period','async\_no\_period'})
ylabel('ms')
ax = gca;
ax.XTickLabelRotation=15;

figure(i);i=i+1;
hold on
plot(v4_finish_new_old,'*-')
plot(v8_finish_new_old,'*-')
plot(v16_finish_new_old,'*-')
plot(v32_finish_new_old,'*-')
title('finish new and old')
legend('4vcpu','8vcpu','16vcpu','32vcpu')
set(gca,'XTick',[1:5])
set(gca,'XTickLabel',{'min\_offset\_period','min\_offset\_no\_period','max\_offset','async\_period','async\_no\_period'})
ylabel('ms')
ax = gca;
ax.XTickLabelRotation=15;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
return


bench=load('../schedule.txt');
bench_4vcpu=bench(1:4:12,1);bench_4vcpu(4)=547;%manually add two asyc protocols ran before
bench_8vcpu=bench(2:4:12,1);bench_8vcpu(4)=521;
bench_16vcpu=bench(3:4:12,1);bench_16vcpu(4)=385;
bench_32vcpu=bench(4:4:12,1);bench_32vcpu(4)=360;

bench_plot(1)=mean(bench_4vcpu);
bench_plot(2)=mean(bench_8vcpu);
bench_plot(3)=mean(bench_16vcpu);
bench_plot(4)=mean(bench_32vcpu);
figure(i);i=i+1;
plot(bench_plot,'*-')
set(gca,'XTick',[1:4])
set(gca,'XTickLabel',{'4vcpu','8vcpu','16vcpu','32vcpu'})
title('scheduling overhead in ns')

fprintf('scheduling overhead for 4vcpu is %.1f/%.1f\n',mean(bench_4vcpu),max(max(bench(1:4:12,1)),2226))
fprintf('scheduling overhead for 8vcpu is %.1f/%.1f\n',mean(bench_8vcpu),max(max(bench(2:4:12,1)),1162))
fprintf('scheduling overhead for 16vcpu is %.1f/%.1f\n',mean(bench_16vcpu),max(max(bench(3:4:12,1)),825))
fprintf('scheduling overhead for 32vcpu is %.1f/%.1f\n',mean(bench_32vcpu),max(max(bench(4:4:12,1)),724))

bench=load('../context.txt');
bench_4vcpu=bench(1:4:12,1);bench_4vcpu(4)=66.5;
bench_8vcpu=bench(2:4:12,1);bench_8vcpu(4)=47;
bench_16vcpu=bench(3:4:12,1);bench_16vcpu(4)=39;
bench_32vcpu=bench(4:4:12,1);bench_32vcpu(4)=33;

bench_plot(1)=mean(bench_4vcpu);
bench_plot(2)=mean(bench_8vcpu);
bench_plot(3)=mean(bench_16vcpu);
bench_plot(4)=mean(bench_32vcpu);
figure(i);i=i+1;
plot(bench_plot,'*-')
set(gca,'XTick',[1:4])
set(gca,'XTickLabel',{'4vcpu','8vcpu','16vcpu','32vcpu'})
title('context overhead in ns')
fprintf('context overhead for 4vcpu is %.1f/%.1f\n',mean(bench_4vcpu),max(max(bench(1:4:12,1)),113))
fprintf('context overhead for 8vcpu is %.1f/%.1f\n',mean(bench_8vcpu),max(max(bench(2:4:12,1)),75))
fprintf('context overhead for 16vcpu is %.1f/%.1f\n',mean(bench_16vcpu),max(max(bench(3:4:12,1)),439))
fprintf('context overhead for 32vcpu is %.1f/%.1f\n',mean(bench_32vcpu),max(max(bench(4:4:12,1)),149))

bench=load('../repl.txt');
bench_4vcpu=bench(1:4:12,1);bench_4vcpu(4)=1104;
bench_8vcpu=bench(2:4:12,1);bench_8vcpu(4)=1577;
bench_16vcpu=bench(3:4:12,1);bench_16vcpu(4)=1906;
bench_32vcpu=bench(4:4:12,1);bench_32vcpu(4)=3809;

bench_plot(1)=mean(bench_4vcpu);
bench_plot(2)=mean(bench_8vcpu);
bench_plot(3)=mean(bench_16vcpu);
bench_plot(4)=mean(bench_32vcpu);
figure(i);i=i+1;
plot(bench_plot,'*-')
set(gca,'XTick',[1:4])
set(gca,'XTickLabel',{'4vcpu','8vcpu','16vcpu','32vcpu'})
title('releasing overhead in ns')
fprintf('repl overhead for 4vcpu is %.1f/%.1f\n',mean(bench_4vcpu),max(max(bench(1:4:12,1)),4086))
fprintf('repl overhead for 8vcpu is %.1f/%.1f\n',mean(bench_8vcpu),max(max(bench(2:4:12,1)),5019))
fprintf('repl overhead for 16vcpu is %.1f/%.1f\n',mean(bench_16vcpu),max(max(bench(3:4:12,1)),5594))
fprintf('repl overhead for 32vcpu is %.1f/%.1f\n',mean(bench_32vcpu),max(max(bench(4:4:12,1)),5986))

bench=load('../mc.txt');
bench_4vcpu=bench(1:4:12,1);bench_4vcpu(4)=2197;
bench_8vcpu=bench(2:4:12,1);bench_8vcpu(4)=3523;
bench_16vcpu=bench(3:4:12,1);bench_16vcpu(4)=3868;
bench_32vcpu=bench(4:4:12,1);bench_32vcpu(4)=11927;

bench_plot(1)=mean(bench_4vcpu);
bench_plot(2)=mean(bench_8vcpu);
bench_plot(3)=mean(bench_16vcpu);
bench_plot(4)=mean(bench_32vcpu);
figure(i);i=i+1;
plot(bench_plot,'*-')
set(gca,'XTick',[1:4])
set(gca,'XTickLabel',{'4vcpu','8vcpu','16vcpu','32vcpu'})
title('modechange overhead in ns')
fprintf('mc overhead for 4vcpu is %.1f/%.1f\n',mean(bench_4vcpu),max(max(bench(1:4:12,1)),14573))
fprintf('mc overhead for 8vcpu is %.1f/%.1f\n',mean(bench_8vcpu),max(max(bench(2:4:12,1)),15908))
fprintf('mc overhead for 16vcpu is %.1f/%.1f\n',mean(bench_16vcpu),max(max(bench(3:4:12,1)),19178))
fprintf('mc overhead for 32vcpu is %.1f/%.1f\n',mean(bench_32vcpu),max(max(bench(4:4:12,1)),28424))










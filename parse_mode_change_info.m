fileID = fopen(strcat(testDir,'mode_change_info_matlab'));
C = textscan(fileID,'%d %s');
fclose(fileID);

nr_vcpu = length(C{1,1});
vcpu_type = C{1,2};
if printTestDetail == 0
    for i = 1 : nr_vcpu
       fprintf('v%d: %s ',i-1,strjoin(C{1,2}(i)))
    end
   
    printTestDetail = 1;
end
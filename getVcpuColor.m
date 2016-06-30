%assuming 4 - 64 vcpu
function color = getVcpuColor(vcpu_num, nr_vcpu)
    if (vcpu_num == 64)
        color = [1 1 1];
    else
        dev = 255/nr_vcpu;
        color = [dev*(nr_vcpu-vcpu_num) 255-dev*vcpu_num dev*vcpu_num]/255;
    end
end
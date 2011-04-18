#ifndef TWORKSPACE_UTILITIES_HPP
#define TWORKSPACE_UTILITIES_HPP

enum error_t
{
        SUCCESS,
        INVALID_PROCESSOR_ID
};

error_t set_active_processor(const int& cpu)
{
        size_t size = 0;
        int num_cpus = 4;
        cpu_set_t* mask = CPU_ALLOC(num_cpus);
        size = CPU_ALLOC_SIZE(num_cpus);
        CPU_ZERO_S(size, mask);
        CPU_SET_S(cpu, size, mask);
        pid_t pid  = 0;
        if(-1 == sched_setaffinity(pid, size, mask)) {
                return INVALID_PROCESSOR_ID;
        }
        return SUCCESS;
}

#endif // TWORKSPACE_UTILITIES_HPP

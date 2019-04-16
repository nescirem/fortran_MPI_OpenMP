    program openmp_helloworld
        use omp_lib
        implicit none
        integer                         :: num_threads,tid,num_procs

        !$omp parallel default(private) num_threads(4)
        num_threads = omp_get_num_threads ()
        tid = omp_get_thread_num ()
        num_procs = omp_get_num_threads ()

        print *, "thread",tid,"of",num_threads,"threads is alive in",num_procs,"processes"
        !$omp end parallel
        
    end program

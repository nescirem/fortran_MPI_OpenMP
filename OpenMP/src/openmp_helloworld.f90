!******************************************************************************
!
!  Licensing:
!
!    This code is distributed under the GNU GPLv3.0 license. 
!
!  Modified:
!
!    16 April 2019
!
!  Author:
!
!    Rui Zhang
!
    
    program openmp_helloworld
    
        use omp_lib
        use,intrinsic       :: iso_fortran_env,only: output_unit
        
        implicit none
        
        integer             :: num_threads,tid,num_procs

        !parallel start and set 4 threads
        !$omp parallel default(private) num_threads(4)
        num_threads = omp_get_num_threads()
        tid = omp_get_thread_num()
        num_procs = omp_get_num_threads()

        write ( output_unit,'(A,I2,A,I2,A,I2,A)' ) 'thread',tid,' of',num_threads,&
            ' threads is alive in',num_procs,' processes'
        !$omp end parallel
        
    end program

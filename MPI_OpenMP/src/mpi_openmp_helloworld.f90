!******************************************************************************
!
! Licensing:
!
!   This code is distributed under the GNU GPLv3.0 license. 
!
! Modified:
!
!   16 April 2019
!
! Author:
!
!   Rui Zhang
!
    
    program mpi_openmp_helloworld
    
        use omp_lib
        use,intrinsic       :: iso_fortran_env,only: error_unit,output_unit
        
        implicit none
        
        include 'mpif.h'
        !MPI relevant
        character(len=64)   :: p_name
        integer,parameter   :: root=0
        integer             :: pid,num_p,p_namelen,err
        integer             :: required,provided
        !OpenMP relevant
        integer             :: tid,num_threads
        

        !whether all threads are allowed to make MPI calls
        required = MPI_THREAD_MULTIPLE
        !-----------------------------------------------------------------------------------------------
        !   MPI_THREAD_SINGLE  | 0 | MPI进程仅由一个线程执行，即当前并行机构的MPI进程不支持多线程执行   |
        !  MPI_THREAD_FUNNELED | 1 | MPI进程可以由多个线程执行，但只有主线程能调用MPI函数               |
        ! MPI_THREAD_SERIALIZED| 2 | MPI进程可以由多个线程执行，各个线程能调用MPI函数但并不能同时调用   |
        !  MPI_THREAD_MULTIPLE | 3 | MPI进程可以由多个线程执行，各个线程能在任意时刻调用MPI函数         |
        !-----------------------------------------------------------------------------------------------
        
        !cheack thread safe mode
        call mpi_init_thread( required,provided,err )
        if ( provided<required ) then
            write( error_unit,'(A)' ) 'Required MPI thread safe mode is not supported.'
            stop
        endif
        
        call mpi_comm_rank( mpi_comm_world,pid,err )

        !pause for debug
        if ( pid==root ) pause
        call mpi_barrier( mpi_comm_world,err )
        
        call mpi_comm_size( mpi_comm_world,num_p,err )
        !$omp parallel default(private) shared(pid,num_p) num_threads(4)
        call mpi_get_processor_name( p_name,p_namelen,err )
        num_threads = omp_get_num_threads()
        tid = omp_get_thread_num()
        
        write ( output_unit,'(A,I2,A,I2,A,I2,A,I2,A,A)' ) 'Thread',tid,'of',num_threads,&
             ' threads is alive in process',pid,' of',num_p,' processes on ',p_name(1:p_namelen)
        !$omp end parallel
        
        call mpi_finalize( err )

    end program

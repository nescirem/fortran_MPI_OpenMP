!******************************************************************************
!
! Licensing:
!
!   This code is distributed under the MIT license. 
!
! Modified:
!
!   18 April 2019
!
! Author:
!
!   Nescirem
!
!==============================================================================
!
!>P test_all_mpi_omp
!   Entry point for the unified test of mpi and openmp hybird code.
!
!   Runs all the tests
!
    
    program test_all_mpi_omp
    
        !mpi unit
        use mpi_mod
        !output unit
        use,intrinsic       :: iso_fortran_env,only: error_unit,output_unit    
        !test unit
        use test_helloworld,    only: helloworld
        use test_thread_safe,   only: thread_safe
        !++

        implicit none

        !..
        integer             :: n_errors  !number of errors

        n_errors = 0
        
        !parse the command line 
        call cmd_parser
        !whether all threads are allowed to make MPI calls
        !-----------------------------------------------------------------------------------------------
        !   MPI_THREAD_SINGLE  | 0 | multi-thread is not supported in MPI process.                      |
        !  MPI_THREAD_FUNNELED | 1 | only main thread in each process can make MPI calls.               |
        ! MPI_THREAD_SERIALIZED| 2 | multiple threads may make MPI calls, but only one at a time.       |
        !  MPI_THREAD_MULTIPLE | 3 | multiple threads may call MPI, with no restrictions.               |
        !-----------------------------------------------------------------------------------------------
        
        !cheack thread safe mode
        call mpi_init_thread( required,provided,err )
        if ( provided<required ) then
            write( error_unit,'(A,I2,A)' ) 'Required MPI thread safe mode',required,' is not supported.'
            stop
        endif
        
        call mpi_comm_rank( mpi_comm_world,pid,err )

        myid = pid+1
        call mpi_comm_size( mpi_comm_world,num_p,err )

        if ( pid==root ) then
            pause
            write ( output_unit,'(A)' ) 'MPI TEST:'
        endif
    
        call mpi_barrier( mpi_comm_world,err )
        
        !..hello world
        call helloworld
        call mpi_barrier( mpi_comm_world,err )
        
        !..thread safe mode
        call thread_safe
        call mpi_barrier( mpi_comm_world,err )
        
        !..++
    
        call mpi_finalize( err )

    end program test_all_mpi_omp
!*****************************************************************************************

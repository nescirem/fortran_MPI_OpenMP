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
        !start parallel execution
        call mpi_start
        
        !..hello world
        call helloworld
        call mpi_barrier( mpi_comm_world,err )
        
        !..thread safe mode
        call thread_safe
        call mpi_barrier( mpi_comm_world,err )
        
        !..++
        
        !end parallel execution
        call mpi_end

    end program test_all_mpi_omp
!*****************************************************************************************

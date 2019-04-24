!******************************************************************************
!
! Licensing:
!
!   This code is distributed under the MIT license. 
!
! Modified:
!
!   22 April 2019
!
! Author:
!
!   Nescirem
!
!==============================================================================
!
!>M test_omphelloworld
!>  >S omphelloworld
!
    
    module test_omphelloworld
    
        use,intrinsic       :: iso_fortran_env, only: output_unit
            
        implicit none
        
        private
        public :: omphelloworld
        
    contains
    
        subroutine omphelloworld
        
        !openmp library
        use omp_lib
        
        implicit none
        
        integer             :: num_threads,tid,num_procs

        !parallel start and set 4 threads
        !$omp parallel default(private) num_threads(4)
        num_threads = omp_get_num_threads()
        tid = omp_get_thread_num()
        num_procs = omp_get_num_threads()

        write( output_unit,'(A,I2,A,I2,A,I2,A)' ) 'thread',tid,' of',num_threads,&
            ' threads is alive in',num_procs,' processes'
        !$omp end parallel
        
        end subroutine omphelloworld
    
    end module test_omphelloworld
!******************************************************************************

!******************************************************************************
#ifndef INTEGRATED_TESTS
    program test_omp_helloworld
        
        use test_omphelloworld , only: omphelloworld
        implicit none
        
        call omphelloworld
        
    end program test_omp_helloworld
#endif
!******************************************************************************

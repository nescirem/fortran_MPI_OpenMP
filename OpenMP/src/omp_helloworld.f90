!******************************************************************************
!
! Licensing:
!
!   This code is distributed under the GNU GPLv3.0 license. 
!
! Modified:
!
!   18 April 2019
!
! Author:
!
!   Rui Zhang
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

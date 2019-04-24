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
!>M test_helloworld
!>  >S mpiomphelloworld
!
    
    module test_helloworld
    
        use,intrinsic       :: iso_fortran_env, only: error_unit,output_unit
            
        implicit none
        
        private
        public :: helloworld
        
    contains
    
        subroutine helloworld
        
        use mpi_mod
        use omp_lib
        
        implicit none
        
        !OpenMP relevant
        integer             :: tid,num_threads
        
        call omp_set_num_threads( 4 )
        !$omp parallel default(private) shared(pid,num_p)
        call mpi_get_processor_name( p_name,p_namelen,err )
        num_threads = omp_get_num_threads()
        tid = omp_get_thread_num()
        
        write( output_unit,'(A,I2,A,I2,A,I2,A,I2,A,A)' ) 'Thread',tid,' of',num_threads,&
             ' threads is alive in process',pid,' of',num_p,' processes on ',p_name(1:p_namelen)
        !$omp end parallel
        

        end subroutine helloworld
    
    end module test_helloworld
!******************************************************************************

!******************************************************************************
#ifndef INTEGRATED_TESTS
    program test_mpiomp_helloworld

        use test_helloworld , only: helloworld
        implicit none

        !parse the command line
        call cmd_parser
        !start parallel execution
        call mpi_start

        call helloworld

        !end parallel execution
        call mpi_end

    end program test_mpiomp_helloworld
#endif
!******************************************************************************

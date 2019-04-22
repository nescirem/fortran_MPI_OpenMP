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
!>M test_mpihelloworld
!>  >S mpihelloworld
!
    
    module test_mpihelloworld
    
        use,intrinsic       :: iso_fortran_env, only: output_unit
            
        implicit none
        
        private
        public :: mpihelloworld
        
    contains
    
        subroutine mpihelloworld
        
        !mpi unit
        use mpi_mod
        
        implicit none

        !print each process id
        call mpi_comm_size( mpi_comm_world,num_p,err )
        call mpi_get_processor_name( p_name,p_namelen,err )
        write ( output_unit,'(A,I2,A,I2,A,A)' ) 'Hello world from process',pid,' of',num_p,&
            ' runing on ',p_name(1:p_namelen)
        
        end subroutine mpihelloworld
        
    end module test_mpihelloworld
!******************************************************************************

!******************************************************************************
#ifndef INTEGRATED_TESTS
    program test_mpi_helloworld
        
        use test_mpihelloworld , only: mpihelloworld
        implicit none
        integer :: n_errors
        
        n_errors = 0
        call mpihelloworld( n_errors )
        if ( n_errors /= 0 ) stop 1
        
    end program test_mpi_helloworld
#endif
!******************************************************************************

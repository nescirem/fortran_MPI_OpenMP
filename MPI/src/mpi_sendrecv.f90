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
!>M test_mpisendrecv
!>  >S mpisendrecvend
!
    
    module test_mpisendrecv
        
        implicit none
        
        private
        public :: mpisendrecv
        
    contains
    
        subroutine mpisendrecv( error_cnt )
    
        !mpi unit
        use mpi_mod
        
        implicit none
        
        integer                         :: i,recv_id,send_tag,recv_tag
        !test unit
        integer,intent(out)             :: error_cnt
        
        error_cnt = 0
        
        send_tag = 12+pid
        recv_tag = 12+myleft
        call mpi_sendrecv( pid,1,mpi_int,myright,send_tag,recv_id,1,mpi_int,myleft,recv_tag,mpi_comm_world,istat,err )
        
        if ( recv_id/=myleft ) error_cnt =error_cnt+1
        
        end subroutine mpisendrecv
        
    end module test_mpisendrecv
!******************************************************************************

!******************************************************************************
#ifndef INTEGRATED_TESTS
    program test_mpi_sendrecv

        use test_mpisendrecv , only: mpisendrecv
        implicit none
        integer :: n_errors

        n_errors = 0

        !start parallel execution
        call mpi_start

        call mpisend( n_errors )
        if ( n_errors /= 0 ) stop 1

        !end parallel execution
        call mpi_end

        end program test_mpi_sendrecv
#endif
!*****************************************************************************

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
!>M test_mpisend
!>  >S mpisend
!
!        [4,1,2]          [1,2,3,4]
!   sa = [3,2,4]     sb = [4,3,2,1]
!        [2,3,3]          [3,1,2,1]
!        [1,4,4]                   
!   
!  ------------------------------------------------------------------------
!                           ¡ý  send,recv,bcast   ¡ý
!  -------------------------------------------------------------------------------
! |     Process 0     |     Process 1     |     Process 2     |     Process 3     |
! |  r_sb = [1,4,3]   |  r_sb = [2,3,1]   |  r_sb = [3,2,2]   |  r_sb = [4,1,1]   |
! |       [4,1,2]     |       [4,1,2]     |       [4,1,2]     |       [4,1,2]     |
! |  sa = [3,2,4]     |  sa = [3,2,4]     |  sa = [3,2,4]     |  sa = [3,2,4]     |
! |       [2,3,3]     |       [2,3,3]     |       [2,3,3]     |       [2,3,3]     |
! |       [1,4,4]     |       [1,4,4]     |       [1,4,4]     |       [1,4,4]     |
! |r_sn=[14,23,23,32] |r_sn=[13,16,16,18] |r_sn=[18,21,18,28] |r_sn=[19,18,14,12] |
!  -------------------------------------------------------------------------------
!                             ¡ý    gather   ¡ý
!  ------------------------------------------------------------------------
!        [14,23,23,32]
!   sn = [13,16,16,18]
!        [18,21,18,28]
!        [19,18,14,12]
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
        call mpisend( n_errors )
        if ( n_errors /= 0 ) stop 1
        
    end program test_mpi_sendrecv
#endif
!******************************************************************************
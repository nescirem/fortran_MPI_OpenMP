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
!>M mpi_mod
!
    
    module mpi_mod
    
        implicit none
    
        include 'mpif.h'
    
        integer,parameter   :: root = 0
        integer             :: istat( mpi_status_size )
        integer             :: pid,num_p,p_namelen,err
        integer             :: myid,myleft,myright
        character(len=64)   :: p_name
    
    end module mpi_mod

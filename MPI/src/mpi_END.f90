!******************************************************************************
!
! Licensing:
!
!   This code is distributed under the MIT license. 
!
! Modified:
!
!   24 April 2019
!
! Author:
!
!   Nescirem
!
!==============================================================================
!
!>S mpi_end
!
!   Finalize parallel execution.
!
    
    subroutine mpi_end
        
        !mpi unit
        use mpi_mod,    only: err
        
        call mpi_finalize( err )
        
    end subroutine mpi_end

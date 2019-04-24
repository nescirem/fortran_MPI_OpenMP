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
!>S mpi_start
!
!   Initializes parallel execution.
!
    
    subroutine mpi_start

        !mpi unit
        use mpi_mod
        !output unit
        use,intrinsic       :: iso_fortran_env,only: error_unit,output_unit  

        call mpi_init( err )
        !get current processor number
        call mpi_comm_rank( mpi_comm_world,pid,err )
        !count in fortran style
        myid = pid+1
        !get number of processors
        call mpi_comm_size( mpi_comm_world,num_p,err )
    
        if ( num_p==1 ) then !If only one process is given, this test makes no sense
            num_p = 0
            myid = 0
            write ( error_unit,'(A)' ) &
                'Execute serially makes no sense.'
            call sleep( 2 )
            stop
        else !if( num_p/=1 ) !assign the neighbour id of each process
            num_slave = num_p-1
            if ( pid==root ) then
                myleft = num_slave
                myright = myid
            elseif ( pid==num_slave ) then
                myleft = pid-1
                myright = root
            else
                myleft = pid-1
                myright = myid
            endif
        endif
    
#if DEBUG
#warning DEBUG is defined 
        !only for debug
        if ( pid==root ) then
            pause
            write ( output_unit,'(A)' ) 'MPI TEST:'
        endif
        call mpi_barrier( mpi_comm_world,err )
#endif

    end subroutine mpi_start

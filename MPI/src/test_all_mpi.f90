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
!>P test_all_mpi
!   Entry point for the unified test of mpi.
!
!   Runs all the tests
!
    
    program test_all_mpi
    
        !mpi unit
        use mpi_mod
        !output unit
        use,intrinsic       :: iso_fortran_env,only: error_unit,output_unit    
        !test unit
        use test_mpihelloworld, only: mpihelloworld
        use test_mpiscatterv,   only: mpiscatterv
        use test_mpisend,       only: mpisend
        use test_mpisendrecv,   only: mpisendrecv
        !++

        implicit none

        integer :: n_errors  !number of errors

        n_errors = 0
    
        call mpi_init( err )
        call mpi_comm_rank( mpi_comm_world,pid,err )
        myid = pid+1
        call mpi_comm_size( mpi_comm_world,num_p,err )
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
        
        if ( num_p/=4 ) then
            write ( output_unit,'(A)' ) &
                'This program used exactly 4 processes, please use ''mpiexec -n 4 MPI.exe'' instead.'
            stop
        endif
        if ( pid==root ) then
            pause
            write ( output_unit,'(A)' ) 'MPI TEST:'
        endif
        call mpi_barrier( mpi_comm_world,err )
        
        !..helloworld
        call mpihelloworld
        call mpi_barrier( mpi_comm_world,err )
        
        !..mpi_scatterv..mpi_gatherv
        call mpiscatterv( n_errors )
        if ( pid==root ) then
            if ( n_errors/=0 ) then
                write ( error_unit,'(A,I2)' ) 'mpi_scatterv, mpi_gatherv :: error:',n_errors
            else
                write ( error_unit,'(A)' ) 'mpi_scatterv, mpi_gatherv :: Pass!'
            endif
        endif
        call mpi_barrier( mpi_comm_world,err )
        
        !..mpi_send..mpi_recv..mpi_bcast..mpi_gather
        call mpisend( n_errors )
        if ( pid==root ) then
            if ( n_errors/=0 ) then
                write ( error_unit,'(A,I2)' ) 'mpi_send, mpi_recv, mpi_bcast, mpi_gather :: error:',n_errors
            else
                write ( error_unit,'(A)' ) 'mpi_send, mpi_recv, mpi_bcast, mpi_gather :: Pass!'
            endif
        endif
        call mpi_barrier( mpi_comm_world,err )
        
        !..mpi_sendrecv
        call mpisendrecv( n_errors )
        if ( pid==root ) then
            if ( n_errors/=0 ) then
                write ( error_unit,'(A,I2)' ) 'mpi_sendrecv :: error:',n_errors
            else
                write ( error_unit,'(A)' ) 'mpi_sendrecv :: Pass!'
            endif
        endif
        call mpi_barrier( mpi_comm_world,err )
        
        !..++
        
        call mpi_finalize( err )

    end program test_all_mpi
!*****************************************************************************************

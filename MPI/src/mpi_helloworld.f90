!******************************************************************************
!
!  Licensing:
!
!    This code is distributed under the GNU GPLv3.0 license. 
!
!  Modified:
!
!    16 April 2019
!
!  Author:
!
!    Rui Zhang
!
    
    program mpi_helloworld
    
        use,intrinsic       :: iso_fortran_env,only: output_unit
        
        implicit none
        
        include 'mpif.h'
        character(len=64)   :: p_name
        integer,parameter   :: root=0
        integer             :: pid,num_p,p_namelen,err

        call mpi_init( err )
        call mpi_comm_rank( mpi_comm_world,pid,err )

        !pause for debug
        if ( pid==root ) pause
        call mpi_barrier( mpi_comm_world,err )

        !print each process id
        call mpi_comm_size( mpi_comm_world,num_p,err )
        call mpi_get_processor_name( p_name,p_namelen,err )
        write ( output_unit,'(A,I2,A,I2,A,A)' ) 'process',pid,' of',num_p,&
            ' is alive on ',p_name(1:p_namelen)
        
        call mpi_finalize( err )

    end program

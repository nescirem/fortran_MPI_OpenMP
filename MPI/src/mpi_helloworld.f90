    program mpi_helloworld
        implicit none
        include 'mpif.h'

        character(len=64)   :: p_name
        integer,parameter   :: root=0
        integer             :: pid, num_p, p_namelen, err

        call mpi_init( err )
        call mpi_comm_rank( mpi_comm_world,pid,err )

        if ( pid==root ) pause
        call mpi_barrier( mpi_comm_world,err )

        call mpi_comm_size( mpi_comm_world,num_p,err )
        call mpi_get_processor_name( p_name,p_namelen,err )
        print *, "process",pid,"   of",num_p,"  is alive on ",p_name(1:p_namelen)
        


        call mpi_finalize( err )

    end program

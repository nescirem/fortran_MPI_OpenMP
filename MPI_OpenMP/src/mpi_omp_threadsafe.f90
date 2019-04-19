!******************************************************************************
!
! Licensing:
!
!   This code is distributed under the GNU GPLv3.0 license. 
!
! Modified:
!
!   18 April 2019
!
! Author:
!
!   Rui Zhang
!
!==============================================================================
!
!>M test_thread_safe
!>  >S thread_safe
!
    
    module test_thread_safe
    
        use,intrinsic       :: iso_fortran_env, only: error_unit,output_unit
            
        implicit none
        
        private
        public :: thread_safe
        
    contains
    
        subroutine thread_safe
        
        use mpi_mod
        use omp_lib
        
        implicit none
        
        integer             :: i,num_slave,tag
        !OpenMP relevant
        integer             :: tid
        integer             :: r_tid
        
        
        num_slave = num_p-1
        call omp_set_num_threads( 4 )
        !$omp parallel default(shared) private(i,tid,r_tid,tag,istat)
        if ( required==MPI_THREAD_MULTIPLE ) then
            if ( pid==root ) then
                do i=1,num_slave
                    tid = omp_get_thread_num()
                    tag = 100+tid
                    call mpi_send( tid,1,mpi_int,i,tag,mpi_comm_world,err )
                enddo
            else !( pid/=root ) then
                tid = omp_get_thread_num()
                tag = 100+tid
                call mpi_recv( r_tid,1,mpi_int,root,tag,mpi_comm_world,istat,err )
            
                write( output_unit,'(A,I2,A,I2,A,I2,A)' ) 'Thread',tid,' in process',pid,' received greeting from thread',r_tid,' in process 0'
            endif
        else if ( required==MPI_THREAD_SERIALIZED ) then
            !$omp critical
            if ( pid==root ) then
                do i=1,num_slave
                    tid = omp_get_thread_num()
                    tag = 100+tid
                    call mpi_send( tid,1,mpi_int,i,tag,mpi_comm_world,err )
                enddo
            else !( pid/=root ) then
                tid = omp_get_thread_num()
                tag = 100+tid
                call mpi_recv( r_tid,1,mpi_int,root,tag,mpi_comm_world,istat,err )
            
                write( output_unit,'(A,I2,A,I2,A,I2,A)' ) 'Thread',tid,' in process',pid,' received greeting from thread',r_tid,' in process 0'
            endif
            !$omp end critical
        else if ( required==MPI_THREAD_FUNNELED ) then
            if ( pid==root ) then
                do i=1,num_slave
                    tid = omp_get_thread_num()
                    tag = 100
                    if (tid==0) call mpi_send( tid,1,mpi_int,i,tag,mpi_comm_world,err )
                enddo
            else !( pid/=root ) then
                tid = omp_get_thread_num()
                tag = 100
                if (tid==0) then
                    call mpi_recv( r_tid,1,mpi_int,root,tag,mpi_comm_world,istat,err )
                    write( output_unit,'(A,I2,A,I2,A,I2,A)' ) 'Thread',tid,' in process',pid,' received greeting from thread',r_tid,' in process 0'
                endif
            endif
        endif
        !$omp end parallel
        
        
        end subroutine thread_safe
        
    end module test_thread_safe

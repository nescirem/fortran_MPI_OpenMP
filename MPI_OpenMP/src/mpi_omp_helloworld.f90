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
    
    module test_mpiomphelloworld
    
        use,intrinsic       :: iso_fortran_env, only: error_unit,output_unit
            
        implicit none
        
        private
        public :: mpiomphelloworld
        
    contains
    
        subroutine mpiomphelloworld
        
        use mpi_mod
        use omp_lib
        
        implicit none
        
        !OpenMP relevant
        integer             :: tid,num_threads
        
        !$omp parallel default(private) shared(pid,num_p) num_threads(4)
        call mpi_get_processor_name( p_name,p_namelen,err )
        num_threads = omp_get_num_threads()
        tid = omp_get_thread_num()
        
        write ( output_unit,'(A,I2,A,I2,A,I2,A,I2,A,A)' ) 'Thread',tid,' of',num_threads,&
             ' threads is alive in process',pid,' of',num_p,' processes on ',p_name(1:p_namelen)
        !$omp end parallel
        

        end subroutine mpiomphelloworld
    
    end module test_mpiomphelloworld

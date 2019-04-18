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
!>M test_ompdo
!>  >S ompdo
!
!   sa = [1,2,3,4,5,6,7,8,9,10,11,12,13,14]
!   sb = [1,2,3,4,5,6,7,8,9,10,11,12,13,14]
!  ------------------------------------------------------------------------
!                             ¡ý  omp do   ¡ý
!  -------------------------------------------------------------------------------------------
! |  Thread 0  |  Thread 1  |  Thread 2  |  Thread 3  |  Thread 0  |  Thread 1  |  Thread 2  |
! | sa = [1,2] | sa = [3,4] | sa = [5,6] | sa = [7,8] | sa = [9,10]|sa = [11,12]|sa = [13,14]|
! | sb = [1,2] | sb = [3,4] | sb = [5,6] | sb = [7,8] | sb = [9,10]|sb = [11,12]|sb = [13,14]|
!      ¨K          ¨K             ¡ý          ¡ý           ¨L            ¨L         ¨L
!             sn = [1,4,9,16,25,36,49,64,81,100,121,142,169,196]
!
    
    module test_ompdo
        
        implicit none
        
        private
        public :: ompdo
        
    contains
        
        subroutine ompdo( error_cnt )
        
        use omp_lib
        
        implicit none
        
        integer                         :: i
        integer                         :: num_node=14
        real(8),pointer,dimension(:)    :: sn,sa,sb
        !test unit
        integer,intent(out)             :: error_cnt
        real(8),pointer,dimension(:)    :: t_sn
        
        allocate( sn(num_node),sa(num_node),sb(num_node) )
        do i=1,num_node
                sa(i) = i
                sb(i) = i
        enddo
        
        !parallel start and set 4 threads
        !$omp parallel default(shared) private(i) num_threads(4)
        !openMP do set chunk=2
        !$omp do schedule(static,2)
        do i=1,num_node
            sn(i) = sa(i)*sb(i)
        enddo
        !$omp end do
        !$omp end parallel
        
        !test result
        allocate ( t_sn(num_node) )
        do i=1,num_node
            t_sn(i) = sa(i)*sb(i)-sn(i)
        enddo
        if ( ANY(t_sn/=0.0d0) ) error_cnt = error_cnt + 1
        
        end subroutine ompdo
        
    end module test_ompdo

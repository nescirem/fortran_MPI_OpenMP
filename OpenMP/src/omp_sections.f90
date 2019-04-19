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
!>M test_ompsections
!>  >S ompsections
!
!   sa = [1,2,3,4,5,6,7,8,9,10,11,12,13,14]
!   sb = [1,2,3,4,5,6,7,8,9,10,11,12,13,14]
!  ------------------------------------------------------------------------
!                             ¡ý  omp sections   ¡ý
!  -----------------------------------------------------------------------------------------
! |                  Thread 0                  |                  Thread 1                  |
! | sa = [1,2,3,4,5,6,7,8,9,10,11,12,13,14]    | sb = [1,2,3,4,5,6,7,8, 9,10,11,12,13,14]   |
! | sa = [0,1,2,3,4,5,6,7,8, 9,10,11,12,13]    | sb = [2,3,4,5,6,7,8,9,10,11,12,13,14,15]   |
!                 ¨K                                              ¨L
!   sa = [0,1,2,3,4,5,6,7,8, 9,10,11,12,13]  sb = [2,3,4,5,6,7,8,9,10,11,12,13,14,15]
!  -----------------------------------------------------------------------------------------
!                                 ¡ý  omp do   ¡ý
!  ------------------------------------------------------------------------------------------
! |  Thread 0  |  Thread 1  |  Thread 2  |  Thread 3  |  Thread 0  |  Thread 1  |  Thread 2  |
! | sa = [0,1] | sa = [2,3] | sa = [4,5] | sa = [6,7] |sa = [ 8, 9]|sa = [10,11]|sa = [12,13]|
! | sb = [2,3] | sb = [4,5] | sb = [6,7] | sb = [8,9] |sb = [10,11]|sb = [12,13]|sb = [14,15]|
!      ¨K          ¨K             ¡ý          ¡ý           ¨L            ¨L         ¨L
!             sn = [2,4,6,8,10,12,14,16,18,20,22,24,26,28]
!
    
    module test_ompsections
        
        implicit none
        
        private
        public :: ompsections
        
    contains
        
        subroutine ompsections( error_cnt )
        
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
        
        !sections start and set 2 threads
        call omp_set_num_threads( 2 )
        !openMP 2 sections
        !$omp parallel sections shared(num_node,sa,sb) private(i)
        !section 1 solved by thread 0
        do i=1,num_node
            sa(i) = sa(i)-1.0
        enddo
        !$omp section
        !section 2 solved by thread 1
        do i=1,num_node
            sb(i) = sb(i)+1.0
        enddo
        !$omp end parallel sections
        
        !parallel start and set 4 threads
        call omp_set_num_threads( 4 )
        !$omp parallel default(shared) private(i)
        !$omp do schedule(static)
        do i=1,num_node
            sn(i) = sa(i)+sb(i)
        enddo
        !$omp enddo
        
        !openMP single
        !$omp single
        deallocate( sa,sb )
        !$omp end single nowait
        
        !$omp end parallel
        
        !test result
        allocate( t_sn(num_node) )
        do i=1,num_node
            t_sn(i) = 2.0d0*i-sn(i)
        enddo
        if ( ANY(t_sn/=0.0d0) ) error_cnt = error_cnt + 1
        
        end subroutine ompsections
        
    end module test_ompsections

!******************************************************************************
!
! Licensing:
!
!   This code is distributed under the GNU GPLv3.0 license. 
!
! Modified:
!
!   16 April 2019
!
! Author:
!
!   Rui Zhang
!
!==============================================================================
!
!>P omp_do
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
    
    program omp_do
    
        use omp_lib
        use,intrinsic       :: iso_fortran_env,only: output_unit
        
        implicit none
        integer                         :: i
        integer                         :: num_node=14
        real(8),pointer,dimension(:)    :: sn,sa,sb
        
        allocate ( sn(num_node),sa(num_node),sb(num_node) )
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
        
        !print result
        write ( output_unit,'(A)' ) 'sn='
        write ( output_unit,* ) sn
        
    end program

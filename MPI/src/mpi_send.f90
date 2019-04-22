!******************************************************************************
!
! Licensing:
!
!   This code is distributed under the MIT license. 
!
! Modified:
!
!   18 April 2019
!
! Author:
!
!   Nescirem
!
!==============================================================================
!
!>M test_mpisend
!>  >S mpisend
!
!        [4,1,2]          [1,2,3,4]
!   sa = [3,2,4]     sb = [4,3,2,1]
!        [2,3,3]          [3,1,2,1]
!        [1,4,4]                   
!   
!  ------------------------------------------------------------------------
!                           ¡ý  send,recv,bcast   ¡ý
!  -------------------------------------------------------------------------------
! |     Process 0     |     Process 1     |     Process 2     |     Process 3     |
! |  r_sb = [1,4,3]   |  r_sb = [2,3,1]   |  r_sb = [3,2,2]   |  r_sb = [4,1,1]   |
! |       [4,1,2]     |       [4,1,2]     |       [4,1,2]     |       [4,1,2]     |
! |  sa = [3,2,4]     |  sa = [3,2,4]     |  sa = [3,2,4]     |  sa = [3,2,4]     |
! |       [2,3,3]     |       [2,3,3]     |       [2,3,3]     |       [2,3,3]     |
! |       [1,4,4]     |       [1,4,4]     |       [1,4,4]     |       [1,4,4]     |
! |r_sn=[14,23,23,32] |r_sn=[13,16,16,18] |r_sn=[18,21,18,28] |r_sn=[19,18,14,12] |
!  -------------------------------------------------------------------------------
!                             ¡ý    gather   ¡ý
!  ------------------------------------------------------------------------
!        [14,23,23,32]
!   sn = [13,16,16,18]
!        [18,21,18,28]
!        [19,18,14,12]
!

    module test_mpisend
        
        implicit none
        
        private
        public :: mpisend
        
    contains
    
        subroutine mpisend( error_cnt )
    
        !mpi unit
        use mpi_mod
        
        implicit none
        
        !calcu unit
        real                            :: random_real
        integer                         :: num_slave,i,j,tag
        real(8)                         :: sa(4,3),sb(3,4),sn(4,4)
        real(8)                         :: r_sb(3),r_sn(4)
        !test unit
        integer,intent(out)             :: error_cnt
        real(8)                         :: t_sn(4,4)
        
        error_cnt = 0
        num_slave = num_p-1
        
        
        
        if ( pid==root ) then
            
            do j=1,3
                do i=1,4
                    call RANDOM_NUMBER( random_real )
                    sa(i,j)= random_real+1.0
                enddo
            enddo
            do j=1,4
                do i=1,3
                    call RANDOM_NUMBER( random_real )
                    sb(i,j)= random_real+1.0
                enddo
            enddo

            do i=1,3
                r_sb(i)=sb(i,1)
            enddo
            
            do i=1,num_slave
                tag = 11
                call mpi_send( sb(1,i+1),3,mpi_double_precision,i,tag,&
                    mpi_comm_world,err )
            enddo
            
        else !if( pid/=root ) then
            tag = 11
            call mpi_recv( r_sb,3,mpi_double_precision,root,tag,&
                mpi_comm_world,istat,err )
        endif
        
        
        call mpi_bcast( sa,12,mpi_double_precision,root,mpi_comm_world,err)
        
        do i=1,4
            r_sn(i) = 0
            do j=1,3
                r_sn(i)= r_sn(i)+sa(i,j)*r_sb(j)
            enddo
        enddo
        
        call mpi_gather( r_sn,4,mpi_double_precision,sn,4,mpi_double_precision,&
            root,mpi_comm_world,err)
        
        if ( pid==root ) then
            t_sn = MATMUL( sa,sb )
            t_sn = t_sn-sn
            if ( ANY(t_sn/=0.0d0) ) error_cnt = error_cnt + 1
        endif
        
        end subroutine mpisend
        
    end module test_mpisend
    !******************************************************************************

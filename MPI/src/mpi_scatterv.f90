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
!>M test_mpiscatterv
!>  >S mpiscatterv
!
!   sa = [1,2,3,4,5,6,7,8,9,10,11,12,13,14]
!   sb = [1,2,3,4,5,6,7,8,9,10,11,12,13,14]
!  ------------------------------------------------------------------------
!                             ¡ý  scatterv   ¡ý
!  -------------------------------------------------------------------------------------------
! |     Process 0    |       Process 1     |       Process 2       |           Process 3      |
! | r_sa = [1,2,?,?] | r_sa = [3,4,5,6]    | r_sa = [7,8,9,10]     | r_sa = [11,12,13,14]     |
! | r_sb = [1,2,?,?] | r_sb = [3,4,5,6]    | r_sb = [7,8,9,10]     | r_sb = [11,12,13,14]     |
! | r_sn = [1,4,?,?] | r_sn = [9,16,25,36] | r_sn = [49,64,81,100] | r_sn = [121,142,169,196] |
!  -------------------------------------------------------------------------------------------
!                             ¡ý   gatherv   ¡ý
!  ------------------------------------------------------------------------
!   sn = [1,4,9,16,25,36,49,64,81,100,121,142,169,196]
!
    
    module test_mpiscatterv
        
        implicit none
        
        private
        public :: mpiscatterv
        
        integer                         :: num_node = 14
        
    contains
    
        subroutine mpiscatterv( error_cnt )
        
        !mpi unit
        use mpi_mod
        
        implicit none
        
        !calcu unit
        integer                         :: i,num_slave,r_node,extra
        real                            :: avg_node
        real(8),pointer,dimension(:)    :: sn,sa,sb
        real(8),pointer,dimension(:)    :: r_sn,r_sa,r_sb
        integer,pointer,dimension(:)    :: scounts,rcounts,displs
        !test unit
        integer,intent(out)             :: error_cnt
        real(8)                         :: t_sn
        
        error_cnt = 0
        
        !allocate and initialize sa,sb
        if ( pid==root ) then
            allocate ( sn(num_node),sa(num_node),sb(num_node) )
            do i=1,num_node
                sa(i) = i
                sb(i) = i
            enddo
        endif
        
        !assign tasks
        num_slave = num_p-1
        avg_node = num_node/num_slave
        r_node = FLOOR( avg_node-num_node/num_p/num_p )
        extra = num_node-num_slave*r_node
        
        allocate ( scounts(num_p),rcounts(num_p),displs(num_p) )
        scounts(1) = r_node
        rcounts(1) = r_node
        displs(1) = 0
        do i=2,num_p
            scounts(i) = r_node
            rcounts(i) = r_node
            displs(i) = extra+(i-2)*r_node
        enddo
        
        allocate ( r_sn(r_node),r_sa(r_node),r_sb(r_node) )
        
        !scatter
        call mpi_scatterv( sa,scounts,displs,mpi_double_precision,r_sa,&
                        rcounts,mpi_double_precision,root,mpi_comm_world,err )
        call mpi_scatterv( sb,scounts,displs,mpi_double_precision,r_sb,&
                        rcounts,mpi_double_precision,root,mpi_comm_world,err )
        
        !parallel calculation
        if ( pid==root ) then
            do i=1,extra
                r_sn(i) = r_sa(i)*r_sb(i)
            enddo
        else !( pid/=root ) then
            do i=1,rcounts(myid)
                r_sn(i) = r_sa(i)*r_sb(i)
            enddo
        endif
        
        !gather
        call mpi_gatherv ( r_sn,r_node,mpi_double_precision,sn,rcounts,&
                        displs,mpi_double_precision,root,mpi_comm_world,err )
        
        !compare result
        if ( pid==root ) then
            do i=1,num_node
                t_sn = sa(i)*sb(i)
                if ( sn(i)/=t_sn ) then 
                    error_cnt = error_cnt + 1
                    exit
                endif
            enddo
        endif

        end subroutine mpiscatterv
        
    end module test_mpiscatterv
    !******************************************************************************

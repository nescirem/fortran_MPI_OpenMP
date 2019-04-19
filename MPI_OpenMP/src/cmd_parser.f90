!******************************************************************************
!
! Licensing:
!
!   This code is distributed under the GNU GPLv3.0 license. 
!
! Modified:
!
!   19 April 2019
!
! Author:
!
!   Rui Zhang
!
!==============================================================================
!
!>S cmd_parser
!        
    subroutine cmd_parser
    
        !mpi unit
        use mpi_mod,    only: required
        !output unit
        use,intrinsic       :: iso_fortran_env,only: error_unit,output_unit    
        
        !Command relevant
        integer             :: status,length
        character(len=10)   :: cmd_param
        
        call GET_COMMAND_ARGUMENT( 1,cmd_param,length,status )
        if ( status/=0 ) then
            if ( pid==root ) write( error_unit,'(A)' ) 'Required MPI thread safe mode set as MULTIPLE'
            required = 3
        elseif ( TRIM(cmd_param)=='-h' ) then
            if ( pid==root ) write( output_unit,'(A)' ) '-ts [thread_safe_mode]'
            stop
        elseif ( TRIM(cmd_param)=='-ts' ) then
            call GET_COMMAND_ARGUMENT( 2,cmd_param,length,status )
            if ( status/=0 ) then
                if ( pid==root ) write( error_unit,'(A)' ) 'Required MPI thread safe mode set as MULTIPLE'
                required = 3
            elseif ( TRIM(cmd_param)==('single') ) then
                if ( pid==root ) write( error_unit,'(A)' ) 'Required MPI thread safe mode set as SINGLE'
                required = 0
            elseif ( TRIM(cmd_param)==('funneled') ) then
                if ( pid==root ) write( error_unit,'(A)' ) 'Required MPI thread safe mode set as FUNNELED'
                required = 1
            elseif ( TRIM(cmd_param)==('serialized') ) then
                if ( pid==root ) write( error_unit,'(A)' ) 'Required MPI thread safe mode set as SERIALIZED'
                required = 2
            elseif ( TRIM(cmd_param)==('multiple') ) then
                if ( pid==root ) write( error_unit,'(A)' ) 'Required MPI thread safe mode set as MULTIPLE'
                required = 3
            else
                if ( pid==root ) write( error_unit,'(A)' ) 'Bad thread safe mode, EXIT'
                call sleep( 2 )
                stop
            endif
        endif
        
    end subroutine cmd_parser

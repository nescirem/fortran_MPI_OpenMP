!******************************************************************************
!
! Licensing:
!
!   This code is distributed under the MIT license. 
!
! Modified:
!
!   19 April 2019
!
! Author:
!
!   Nescirem
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
        elseif ( TRIM(cmd_param)=='-h' .or. TRIM(cmd_param)=='-help' ) then
            if ( pid==root ) write( output_unit,'(9(A,/))' ) ' ',&
            '-ts <thread_safe_mode>',&
            '         specify the thread safe mode',&
            '         indicated by <thread_safe_mode> as described below',&
            '             single      multi-thread is not supported in MPI process',&
            '             funneled    only main thread in each process can make MPI calls',&
            '             serialized  multiple threads may make MPI calls, but only one at a ',&
            '                         time',&
            '             multiple    multiple threads may call MPI, with no restrictions'
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

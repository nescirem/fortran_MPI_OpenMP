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
!>P test_all_omp
!   Entry point for the unified test of OpenMP.
!
!   Runs all the tests
!
    
    program test_all_omp
    
        !output unit
        use,intrinsic       :: iso_fortran_env,only: error_unit,output_unit    
        !test unit
        use test_omphelloworld, only: omphelloworld
        use test_ompdo,         only: ompdo
        use test_ompsections,   only: ompsections
        !++

        implicit none

        integer :: n_errors  !number of errors

        n_errors = 0
    
        !..helloworld
        call omphelloworld
    
        !..omp do
        call ompdo ( n_errors )
        if ( n_errors/=0 ) then
            write( error_unit,'(A,I2)' ) 'OpenMP do :: error:',n_errors
        else
            write( error_unit,'(A)' ) 'OpenMP do :: Pass!'
        endif
        
        !..omp sections
        call ompsections ( n_errors )
        if ( n_errors/=0 ) then
            write( error_unit,'(A,I2)' ) 'OpenMP ections :: error:',n_errors
        else
            write( error_unit,'(A)' ) 'OpenMP sections :: Pass!'
        endif
        
        !..++
        
    end program test_all_omp
!*****************************************************************************************
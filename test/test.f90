program main
    use forsus, only: Substance, pr
    implicit none
    real(pr) :: tolerance = 1e-4
    type(Substance) :: sus

    sus = Substance("ethanol")
    call test_values
    
    sus = Substance("ethanol", path="data/json")
    call test_values

contains

    subroutine test_values
        ! =============================================================================
        !  Critical properties
        ! -----------------------------------------------------------------------------
        call test(6148000._pr, sus%critical%critical_pressure%value, "Pc")
        call test(513.92_pr, sus%critical%critical_temperature%value, "Tc")
        call test(0.167_pr, sus%critical%critical_volume%value, "Vc")
        call test(0.649_pr, sus%critical%acentric_factor%value, "w")

        
        call test(2.2601e-2_pr, sus%parachor%value, "Parachor")

        call test(1.3327_pr, sus%mathiascopeman(1)%value, "MathiasCopemanC1")
        call test(0.96946_pr, sus%mathiascopeman(2)%value, "MathiasCopemanC2")
        call test(-3.1879_pr, sus%mathiascopeman(3)%value, "MathiasCopemanC3")
        end subroutine
    subroutine test(value, calc_value, name)
        real(pr), intent(in) :: value
        real(pr), intent(in) :: calc_value
        character(len=*), intent(in) :: name

        write(*, "(A)", advance="no") name
        if (abs((value - calc_value)/value) > tolerance) then
            print *, "Error!"
            call exit(1)
        else
            print *, "Ok!"
        end if
    end subroutine

    subroutine test_failed_read

    end subroutine
end program

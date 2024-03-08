program main
    use forsus, only: Substance, pr
    implicit none
    real(pr) :: tolerance = 1e-4
    type(Substance) :: sus

    sus = Substance("ethanol")

    call test(6148000._pr, sus%critical%critical_pressure%value, "Pc")
    call test(513.91999999999996_pr, sus%critical%critical_temperature%value, "Tc")
    call test(0.167_pr, sus%critical%critical_volume%value, "Vc")
    call test(0.649_pr, sus%critical%acentric_factor%value, "w")

contains
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
end program
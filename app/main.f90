program main
    use forsus, only: Substance
    use forsus__available, only: show_available

    type(Substance) :: sus
    character(len=50) :: nam

    call show_available(nam)
    sus = Substance(nam)


    print *, nam
    print *, sus%critical%critical_temperature%name, sus%critical%critical_temperature%value

    print *, "UNIFAC-VLE"
    print *, sus%unifac_vle%ids
    print *, sus%unifac_vle%counts
end program

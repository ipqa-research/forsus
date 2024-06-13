module forsus__available
    !! Show what substances are available in the database
contains
    subroutine show_available(sus)
        !! Show the available substances in the database
        use forsus_constants, only: forsus_dir, forsus_default_dir
        character(len=*), optional, intent(in out) :: sus
        integer :: funit

        character(len=*), parameter :: pst_command="| fzf | cut -d'.' -f1 > /tmp/forsus"


        if (allocated(forsus_dir)) then
            call system("ls " // forsus_dir // pst_command)
        else
            call system("ls " // forsus_default_dir // pst_command)
        end if

        if (present(sus)) then
            open(newunit=funit, file="/tmp/forsus")
            read(funit, "(A)") sus
            close(funit)
        end if
    end subroutine
end module

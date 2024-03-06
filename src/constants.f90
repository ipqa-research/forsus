module forsus_constants
    !! Package's constants.
    use iso_fortran_env, only: real64
    implicit none

    integer, parameter :: pr=real64
        !! Real precision (double)
    character(len=:), allocatable :: forsus_dir 
        !! Custom database directory
    character(len=*), parameter :: forsus_default_dir="data/json"
        !! Default database directory. Right now only works for development
        !! mode
end module

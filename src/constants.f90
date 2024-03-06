module forsus_constants
    use iso_fortran_env, only: real64
    implicit none
    integer, parameter :: pr=real64

    character(len=:), allocatable :: forsus_dir
    character(len=*), parameter :: forsus_default_dir="files/db_json"
end module

module fchem_db_constants
    use iso_fortran_env, only: real64
    implicit none
    integer, parameter :: pr=real64

    character(len=:), allocatable :: fchem_db_dir
    character(len=*), parameter :: fchem_db_default_dir="files/db_json"
end module

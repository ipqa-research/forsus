module fchem_db
    use fbchem_db_critical_constants, only: CriticalConstants
    implicit none

    type :: Substance
        !! Substance object.
        !!
        !! A Substance object holds all the defined properties available in the
        !! package. It can be initialized either by hand or from a json file.
        !! To initialize from a `json` file the user must provide a database
        !! path by setting up the variable `fchem_db_dir`. Then defining a 
        !! Substance by it's name (which should be the same as the filename)
        !! will find all the properties and set them up properly.
        !!
        !! ```fortran
        !! use fchem_db, only: Substance, fchem_db_dir
        !! type(Substance) :: sus
        !! 
        !! fchem_db_dir = "some/directory/path"
        !! sus = Substance("1-butanol")
        !! 
        !! print *, sus%critical%critical_temperature%value
        !! ```
        character(len=:), allocatable :: name !! Substance name
        character(len=:), allocatable :: database_path !! Path to custom database
        type(CriticalConstants) :: critical !! Critical constants

    end type

    interface Substance
        module procedure :: init_json
    end interface
    
contains

    type(Substance) function init_json(name, path)
        !! Initialize a Substance object from a json file, provided it's name.
        character(len=*), intent(in) :: name
        character(len=*), optional, intent(in) :: path
        
        init_json%name = trim(name)
        call init_json%critical%from_json(init_json%name//".json", path)
    end function

end module
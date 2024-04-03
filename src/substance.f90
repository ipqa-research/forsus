module forsus_substance
    use forsus_properties, only: ScalarProperty, CriticalConstants, Groups
    implicit none

    type :: Substance
        !! Substance object.
        !!
        !! A Substance object holds all the defined properties available in the
        !! package. It can be initialized either by hand or from a json file.
        !! To initialize from a `json` file the user must provide a database
        !! path by setting up the variable `forsus_dir`. Then defining a 
        !! Substance by it's name (which should be the same as the filename)
        !! will find all the properties and set them up properly.
        !!
        !! When using a custom datafile it is very possible that the information
        !! in it is limited in comparison of what the original API provides.
        !! In this case you it is possible to extract only the desired parameters
        !! with the `only` argument.
        !!
        !! Strings for using `only` are:
        !! 
        !! - "critical": Critical constants \(P_c\), \(T_c\), \(\omega\)
        !!
        !! ## Examples
        !! 
        !! ### Default behaviour
        !! ```fortran
        !! use forsus, only: Substance, forsus_dir
        !! type(Substance) :: sus
        !!
        !! ! Set the path of the json files
        !! forsus_dir = "some/directory/path"
        !! 
        !! ! Define your substance
        !! sus = Substance("1-butanol")
        !! ```
        !!
        !! ### Using a custom path for a single substance
        !! 
        !! ```fortran
        !! use forsus, only: Substance
        !! sus = Substance("1-butanol", path="the/json/is/here/")
        !! ```
        !!
        !! ### Extracting limited information
        !!
        !! ```fortran
        !! use forsus, only: Substance
        !! character(len=50) :: only_these(3)
        !!
        !! ! Only extract the critical constants
        !! sus = Substance("1-butanol", only=["critical"])
        !!
        !! ! Extracting a list of properties
        !! only_these(1) = "critical"
        !! only_these(2) = "unifac"
        !! only_these(3) = "mathiascopeman"
        !! sus = Substance("1-butanol", only=only_these)
        !! ```
        character(len=:), allocatable :: name 
            !! Substance name
        type(CriticalConstants) :: critical
            !! Critical constants
        type(ScalarProperty) :: parachor
            !! Parachor
        type(ScalarProperty) :: mathiascopeman(3)
            !! Mathias Copeman \(\alpha\) function parameters
        type(Groups) :: unifac_vle
            !! UNIFAC-VLE model groups
    end type

    ! Setting this interface allows to use `init_json` as the object init
    interface Substance
        module procedure :: init_json
    end interface

contains

    type(Substance) function init_json(name, path, only)
        !! Initialize a Substance object from a json file, provided it's name.
        !! It is also optional to use a custom path for the component.
        character(len=*), intent(in) :: name 
            !! Component's name
        character(len=*), optional, intent(in) :: path 
            !! Optional database path
        character(len=*), optional, intent(in) :: only(:)
            !! Only extract this parameters, the options are:
            !!
            !! - "critical": Tc, Pc and Acentric Factor
        
        character(len=:), allocatable :: file
        integer :: i

        init_json%name = trim(name)
        file = init_json%name // ".json"

        if (.not. present(only)) then
            call init_json%parachor%from_json("Parachor", file, path)
            call init_json%mathiascopeman(1)%from_json("MatthiasCopemanC1", file, path)
            call init_json%mathiascopeman(2)%from_json("MatthiasCopemanC2", file, path)
            call init_json%mathiascopeman(3)%from_json("MatthiasCopemanC3", file, path)
            call init_json%unifac_vle%from_json("UnifacVLE", file, path)
            call init_json%critical%from_json(file, path)
        else
        do i=1,size(only)
            select case(only(i))
            case("critical")
                call init_json%critical%from_json(init_json%name//".json", path)
            end select
        end do
        end if

    end function
end module

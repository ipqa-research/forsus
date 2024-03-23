module forsus_properties_scalar
    use forsus_constants, only: pr, forsus_default_dir, forsus_dir
    use forsus_properties_base, only: Property
    use json_module, only: json_file
    implicit none

    type, extends(Property) :: ScalarProperty
        !! Scalar property.
        !!
        !! A property with a single scalar value, like a critical constant.
        real(pr) :: value !! Property value
    contains
        procedure :: from_json => scalar_from_json
    end type ScalarProperty

contains

    impure elemental subroutine scalar_from_json(self, name, json_str, path)
        !! Setup a scalar property from a provided json key and json file path.
        use iso_fortran_env, only: error_unit
        class(ScalarProperty), intent(in out) :: self
        character(len=*), intent(in) :: name
            !! Property name. Should be the key in the `json` file.
        character(len=*), intent(in) :: json_str
            !! `json` file relative path to executable.
        character(len=*), optional, intent(in) :: path
            !! `json` file relative path to executable.

        type(json_file) :: json

        self%name = name
        call json%initialize()

        if (present(path)) then
            call json%load_file(path//"/"//json_str)
        else
            if (allocated(forsus_dir)) then
                call json%load_file(forsus_dir//"/"//json_str)
            else
                call json%load_file(forsus_default_dir//"/"//json_str)
            end if
        end if

        if (json%failed()) then
            write(error_unit, *) "ERROR: Invalid .json file: ", json_str
            error stop 1
        end if

        call json%get(self%name//".value(1)", self%value)
        call json%get(self%name//".units", self%units)
    end subroutine scalar_from_json
end module forsus_properties_scalar

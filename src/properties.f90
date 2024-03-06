module forsus_property
   use forsus_constants, only: pr, forsus_dir, forsus_default_dir
   use json_module, only: json_file
   implicit none

   type, abstract :: Property
      !! Property base type
      character(len=:), allocatable :: name !! Property's name
      character(len=:), allocatable :: units !! Units
   contains
      procedure(abs_from_json), deferred :: from_json
   end type

   abstract interface
      subroutine abs_from_json(self, name, json_str, path)
         import Property
         class(Property) :: self
         character(len=*), intent(in) :: name
         character(len=*), intent(in) :: json_str
         character(len=*), optional, intent(in) :: path
      end subroutine
   end interface

   type, extends(Property) :: ScalarProperty
      !! Scalar property.
      real(pr) :: value !! Property value
   contains
      procedure :: from_json => scalar_from_json
   end type

contains

   subroutine scalar_from_json(self, name, json_str, path)
      !! Setup a scalar property from a provided json key and json file path.
      use iso_fortran_env, only: error_unit
      class(ScalarProperty) :: self
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
         call exit(1)
      end if

      call json%get(self%name//".value(1)", self%value)
   end subroutine
end module
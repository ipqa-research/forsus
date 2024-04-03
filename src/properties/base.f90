module forsus_properties_base
   !! Basic definition of a Property
   implicit none

   type, abstract :: Property
      !! Property base type
      !!
      !! Define the basics that a property can have.
      character(len=:), allocatable :: name !! Property's name
      character(len=:), allocatable :: units !! Units
   contains
      procedure(abs_from_json), deferred :: from_json
   end type Property

   abstract interface
      impure elemental subroutine abs_from_json(self, name, json_str, path)
         !! How a Property reader routine is espected to work.
         !!
         !! A Property should be setted up by providing it's name and a
         !! `json` file relative (or absolute) path. The Property instance
         !! name should be setted up inside the subroutine and later on
         !! the Property value(s) should be read from the `json` file.
         !!
         !! Inside the subroutine the default `forsus_dir` path should be used
         !! but it should also be possible to use an optional custom path.
         !!
         !! An example implementation can be seen at [scalar_from_json(subroutine)]
         import Property
         class(Property), intent(in out) :: self !! Property
         character(len=*), intent(in) :: name !! Property's name (`json` key)
         character(len=*), intent(in) :: json_str !! `json` file path
         character(len=*), optional, intent(in) :: path !! Optional database path
      end subroutine abs_from_json
   end interface

contains
   function open_json(json_str, path) result(json)
      use iso_fortran_env, only: error_unit
      use json_module, only: json_file
      use forsus_constants, only: forsus_default_dir, forsus_dir
      type(json_file) :: json
      character(len=*), intent(in) :: json_str
      character(len=*), optional, intent(in) :: path

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
   end function open_json
end module forsus_properties_base

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
   end type

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
      end subroutine
   end interface
end module
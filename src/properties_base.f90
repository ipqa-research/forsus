module forsus_properties_base
   !! Basic definition of a Property
   implicit none

   type, abstract :: Property
      !! Property base type.
      !!
      !! Define the basics that a property can have.
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
end module
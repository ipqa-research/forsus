module forsus_properties_groups
   use forsus_properties_base, only: Property, open_json

   type, extends(Property) :: Groups
      !! Groups for a group-contribution based method.
      integer, allocatable :: ids(:)
      integer, allocatable :: counts(:)
   contains
      procedure :: from_json
   end type Groups
contains
   impure elemental subroutine from_json(self, name, json_str, path)
      !! From a json file and a model name set the present groups.
      use json_module, only: json_array, json_file
      class(Groups), intent(in out) :: self !! Groups
      character(len=*), intent(in) :: name !! Model name
      character(len=*), intent(in) :: json_str !! `json` file
      character(len=*), optional, intent(in) :: path !! Path to file

      type(json_file) :: json
      integer :: i, id, count
      logical :: found
      character(len=:), allocatable :: base, str
      character(len=50) :: idx

      ! Initialize empty arrays
      allocate(self%ids(0))
      allocate(self%counts(0))

      json = open_json(json_str, path)

      base = name//".group("

      i = 1
      do
         write(idx, *) i
         str = base // trim(adjustl(idx)) // ")"
         call json%get(str // ".id", id, found=found)
         call json%get(str // ".value", count, found=found)
         if (.not. found) exit

         self%ids = [self%ids, id]
         self%counts = [self%counts, count]
         i = i+1
      end do
   end subroutine from_json
end module forsus_properties_groups

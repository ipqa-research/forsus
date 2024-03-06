module forsus_critical_constants
   use forsus_property
   implicit none
   
   type :: CriticalConstants
      type(ScalarProperty) :: critical_pressure
      type(ScalarProperty) :: critical_temperature
      type(ScalarProperty) :: critical_volume
      type(ScalarProperty) :: acentric_factor
   contains
      procedure :: from_json
   end type

contains

   impure elemental subroutine from_json(self, json_str, path)
      class(CriticalConstants), intent(in out) :: self
      character(len=*), intent(in) :: json_str
      character(len=*), optional, intent(in) :: path
      call self%critical_pressure%from_json("CriticalPressure", json_str, path)
      call self%critical_temperature%from_json("CriticalTemperature", json_str, path)
      call self%critical_volume%from_json("CriticalVolume", json_str, path)
      call self%acentric_factor%from_json("AcentricityFactor", json_str, path)
   end subroutine
end module

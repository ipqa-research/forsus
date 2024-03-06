module forsus_properties_critical_constants
   use forsus_properties_scalar, only: ScalarProperty
   implicit none
   
   type :: CriticalConstants
      type(ScalarProperty) :: critical_pressure !! Critical Pressure
      type(ScalarProperty) :: critical_temperature !! Critical Temperature
      type(ScalarProperty) :: critical_volume !! Critical Volume
      type(ScalarProperty) :: acentric_factor !! Acentric Factor
   contains
      procedure :: from_json
   end type

contains

   impure elemental subroutine from_json(self, json_str, path)
      !! Read all the critical properties from a `json` file.
      class(CriticalConstants), intent(in out) :: self
      character(len=*), intent(in) :: json_str
      character(len=*), optional, intent(in) :: path
      call self%critical_pressure%from_json("CriticalPressure", json_str, path)
      call self%critical_temperature%from_json("CriticalTemperature", json_str, path)
      call self%critical_volume%from_json("CriticalVolume", json_str, path)
      call self%acentric_factor%from_json("AcentricityFactor", json_str, path)
   end subroutine
end module

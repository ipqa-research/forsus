program main
  use forsus_constants, only: forsus_dir
  use forsus, only: Substance

  type(Substance) :: sus(2)

  forsus_dir = "data/json"

  sus(1) = Substance("1-butanol")
  sus(2) = Substance("ethanol")

  print *, sus%critical%critical_temperature%value
end program
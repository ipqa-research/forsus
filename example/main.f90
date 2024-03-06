program main
  use forsus, only: Substance, forsus_dir

  type(Substance) :: sus(2)

  forsus_dir = "data/json"

  sus(1) = Substance("1-butanol")
  sus(2) = Substance("ethanol")

  print *, sus%critical%critical_temperature%value
end program
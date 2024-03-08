program main
  use forsus, only: Substance, forsus_dir

  type(Substance) :: sus(2)
  character(len=50) :: only_this(3)

  forsus_dir = "data/json"

  only_this(1) = "critical"
  only_this(2) = "unifac"

  sus(1) = Substance("1-butanol")
  sus(2) = Substance("ethanol", path="data/json")

  ! sus(2) = Substance("ethanol", only=["critical"])
  ! sus(2) = Substance("ethanol", only=only_this)

  print *, sus%critical%critical_temperature%value
  print *, sus%parachor%value

  print *, sus(1)%critical%critical_pressure%units
  print *, sus(1)%critical%critical_temperature%units
  print *, sus(1)%critical%critical_volume%units

end program

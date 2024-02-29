program main
  use fchem_db_constants, only: fchem_db_dir
  use fchem_db, only: Substance
  type(Substance) :: sus(2)

  fchem_db_dir = "data/json"

  sus(2) = Substance("n-hexane")
  sus(1) = Substance("1-butanol")

  print *, sus%critical%critical_temperature%value
end program

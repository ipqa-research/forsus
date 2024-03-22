[![Fortran](https://img.shields.io/badge/Fortran-734f96?logo=fortran&style=flat)](https://fortran-lang.org)
[![fpm](https://img.shields.io/badge/fpm-Fortran_package_manager-734f96)](https://fpm.fortran-lang.org)
[![Documentation](https://img.shields.io/badge/ford-Documentation%20-blueviolet.svg)](https://ipqa-research.github.io/forsus/)
[![License: MPL 2.0](https://img.shields.io/badge/License-MPL_2.0-brightgreen.svg)](https://github.com/ipqa-research/forsus/blob/main/LICENSE)
[![CI](https://github.com/ipqa-research/forsus/actions/workflows/CI.yml/badge.svg)](https://github.com/ipqa-research/forsus/actions/workflows/CI.yml)
[![codecov](https://codecov.io/gh/ipqa-research/forsus/graph/badge.svg?token=yQGaGgmOzb)](https://codecov.io/gh/ipqa-research/forsus)

# forsus
Pure chemical compounds database and general API.

`forsus` provides a simple API to read `json` files containing pure component
information and later on use it inside other projects.

## The basics
Using `forsus` in your Fortran project is relatively simple:

All the readable parameters are kept on a `Substance` object, from which
they can be later on extracted.

It keeps a global variable `forsus_dir` with should be the path of your database
file directory. [data/json](data/json) is the directory that the library uses by
default.

```fortran
program main
    use forsus

    type(Substance) :: s

    ! This will use the default path
    s = Substance("1-butanol")

    ! This will use the defined path
    forsus_dir = "my/json/files"
    s = Substance("1-butanol")

    ! It is also possible to use a custom path
    sus = Substance("1-butanol", path="the/json/is/here")

    ! Show the critical temperature
    print *, sus%critical%critical_temperature%value
end program
```
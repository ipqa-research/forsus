program main
   use forsus, only: Substance, pr, forsus_dir, version
   implicit none
   real(pr) :: tolerance = 1e-4
   type(Substance) :: sus

   print *, "ForSus version: ", version

   call test_failed_read

   sus = Substance("ethanol")
   call test_values

   sus = Substance("ethanol", path="data/json")
   call test_values

   forsus_dir = "data/json"
   sus = Substance("ethanol")
   call test_values

   call test_only

contains

   subroutine test_only
      integer :: i

      sus = Substance("ethanol", only=["critical"])
      call test_critical

      sus = Substance("ethanol", only=["unifac_vle"])
      call test_int([1, 2, 15], sus%unifac_vle%ids, "UNIFAC-VLE ids")
      call test_int([1, 1, 1], sus%unifac_vle%counts, "UNIFAC-VLE counts")

      sus = Substance("ethanol", only=["mathiascopeman"])
      call test(1.3327_pr, sus%mathiascopeman(1)%value, "MathiasCopemanC1")
      call test(0.96946_pr, sus%mathiascopeman(2)%value, "MathiasCopemanC2")
      call test(-3.1879_pr, sus%mathiascopeman(3)%value, "MathiasCopemanC3")

      sus = Substance("ethanol", only=["parachor"])
      call test(2.2601e-2_pr, sus%parachor%value, "Parachor")
   end subroutine

   subroutine test_values
      ! =============================================================================
      !  Critical properties
      ! -----------------------------------------------------------------------------
      call test_critical

      call test(2.2601e-2_pr, sus%parachor%value, "Parachor")
      call test(1.3327_pr, sus%mathiascopeman(1)%value, "MathiasCopemanC1")
      call test(0.96946_pr, sus%mathiascopeman(2)%value, "MathiasCopemanC2")
      call test(-3.1879_pr, sus%mathiascopeman(3)%value, "MathiasCopemanC3")
      call test_int([1, 2, 15], sus%unifac_vle%ids, "UNIFAC-VLE ids")
      call test_int([1, 1, 1], sus%unifac_vle%counts, "UNIFAC-VLE counts")
   end subroutine

   subroutine test_critical
      call test(6148000._pr, sus%critical%critical_pressure%value, "Pc")
      call test(513.92_pr, sus%critical%critical_temperature%value, "Tc")
      call test(0.167_pr, sus%critical%critical_volume%value, "Vc")
      call test(0.649_pr, sus%critical%acentric_factor%value, "w")
   end subroutine

   subroutine test(value, calc_value, name)
      real(pr), intent(in) :: value
      real(pr), intent(in) :: calc_value
      character(len=*), intent(in) :: name

      write (*, "(A)", advance="no") name
      if (abs((value - calc_value)/value) > tolerance) then
         print *, "Error!"
         error stop 1
      else
         print *, "Ok!"
      end if
   end subroutine
   
   subroutine test_int(value, calc_value, name)
      integer, intent(in) :: value(:)
      integer, intent(in) :: calc_value(:)
      character(len=*), intent(in) :: name

      write (*, "(A)", advance="no") name
      if (maxval(abs((value - calc_value)/value)) > tolerance) then
         print *, "Error!"
         error stop 1
      else
         print *, "Ok!"
      end if
   end subroutine

   subroutine test_failed_read
      integer                    :: exitstat, cmdstat
      character(len=256)         :: cmdmsg
      if (command_argument_count() == 0) then
         call execute_command_line( &
            arg(0)//' failed_red', &
            wait=.true., &
            exitstat=exitstat, &
            cmdstat=cmdstat, &
            cmdmsg=cmdmsg)
         if (exitstat /= 1) error stop 1
      else
         print *, "Should fail:"
         sus = Substance("fai")
      end if
   end subroutine

   function arg(i)
      character(len=:), allocatable :: arg
      integer, intent(in) :: i
      integer            :: argument_length
      call get_command_argument(number=i, length=argument_length)
      if (allocated(arg)) deallocate (arg)
      allocate (character(len=argument_length) :: arg)
      call get_command_argument(i, arg)
   end function arg
end program

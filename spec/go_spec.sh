# shellcheck shell=sh
Describe "go.sh"
  Include ./go.sh

  Describe "hello()"

    Mock date
      echo 1546268400
    End

    It "puts greeting, but not implemented"
      When call hello world
      The output should eq "hello world"
    End
  End

  Describe "main_menu()"

    Mock date
      echo 1546268400
    End


    It "exits when q is given"
      Data "q"
      When call main_menu
      The output should eq "hello world"
    End
  End
End

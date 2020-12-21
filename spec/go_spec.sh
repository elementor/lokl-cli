# shellcheck shell=sh
Describe "go.sh"
  Include ./go.sh

  Describe "hello()"

    Mock date
      echo 1546268400
    End

    It "puts greeting, but not implemented"
      When call hello world
      The output should eq "Hello world!"
    End
  End

  xDescribe "main_menu()"

    Mock date
      echo 1546268400
    End

    It "exits when q is given"
      Data "q"
      When call main_menu
      The output should eq "hello world"
    End
  End

  Describe "test_curl_available()"

    It "returns OK when cURL is available"
      command() {
        echo "/usr/bin/curl"
      }

      The result of "test_curl_available()" should be successful
    End

    It "exits when cURL is available"
      command() {
        exit 1
      }

      The result of "test_curl_available()" should not be successful
    End
  End

End

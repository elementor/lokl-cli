# shellcheck shell=sh
Describe "go.sh"
  Include ./go.sh

  Describe "main_menu()"

    It "exits when q is given"
      Data "q"
      When run main_menu
      The stdout should include 'Lokl launcher & management script'
      The status should be success
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

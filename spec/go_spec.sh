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


  Describe "set_docker_tag()"
    It "defaults to php8 if $lokl_php_ver not set"
      When run set_docker_tag
      The stderr should include 'php8'
      The status should equal 1
    End

    It "prints to stdout if $lokl_php_ver set"
      lokl_php_ver="php7"

      When run set_docker_tag
      The stdout should include 'php7'
      The status should equal 0
    End
  End

  Describe "test_curl_available()"

    It "returns OK when cURL is available"
      # simulate curl available
      command() {
        echo "/usr/bin/curl"
      }

      The result of "test_curl_available()" should be successful
    End

    It "exits with error code when cURL is missing"
      # simulate curl missing
      command() {
        exit 1
      }

      The result of "test_curl_available()" should not be successful
    End
  End

  Describe "create_site_choose_name()"
    It "launches container with name and random port when proper name is given"
     # mock test_core_capabilities as not core to this test 
      test_core_capabilities() {
        clear
        echo ""
        echo "Checking system requirements... "
        echo ""
        # skip these commands
        # test_docker_available
        # test_curl_available
      }

      # mock docker run in launching the container
      docker() {
        echo "mocking launching container...."
      }

      curl() {
        echo "mocking successful curl to container..."
      }

      # mock random port
      get_random_port() {
        echo "4070"
      }

      Data "mywptestsitename"
      When run create_site_choose_name
      The stdout should include 'Your new Lokl WordPress site, mywptestsitename, is ready at:'
      The stdout should include 'http://localhost:4070'
      The status should be success
    End

    It "strips out invalid characters from site name"
     # mock test_core_capabilities as not core to this test 
      test_core_capabilities() {
        clear
        echo ""
        echo "Checking system requirements... "
        echo ""
        # skip these commands
        # test_docker_available
        # test_curl_available
      }

      # mock docker run in launching the container
      docker() {
        echo "mocking launching container...."
      }

      curl() {
        echo "mocking successful curl to container..."
      }

      # mock random port
      get_random_port() {
        echo "4070"
      }

      Data "mywpte\$%@#\$@stsitename"
      When run create_site_choose_name
      The stdout should include 'Your new Lokl WordPress site, mywptestsitename, is ready at:'
      The stdout should include 'http://localhost:4070'
      The status should be success
    End

    It "prompts for site name again if input invalid"
     # mock test_core_capabilities as not core to this test 
      test_core_capabilities() {
        clear
        echo ""
        echo "Checking system requirements... "
        echo ""
        # skip these commands
        # test_docker_available
        # test_curl_available
      }

      # mock docker run in launching the container
      docker() {
        echo "mocking launching container...."
      }

      curl() {
        echo "mocking successful curl to container..."
      }

      # mock random port
      get_random_port() {
        echo "4070"
      }

      Data ""
      When run create_site_choose_name
      The stdout should include 'Choose a name for your new Lokl WordPress sit'
      The status should be failure
    End

    It "converts sitename to lowercase, alpha only"
     # mock test_core_capabilities as not core to this test 
      test_core_capabilities() {
        clear
        echo ""
        echo "Checking system requirements... "
        echo ""
        # skip these commands
        # test_docker_available
        # test_curl_available
      }

      # mock docker run in launching the container
      docker() {
        echo "mocking launching container...."
      }

      curl() {
        echo "mocking successful curl to container..."
      }

      # mock random port
      get_random_port() {
        echo "4070"
      }

      Data "MYWPTEST SITE NAME"
      When run create_site_choose_name
      The stdout should include 'Your new Lokl WordPress site, mywptestsitename, is ready at:'
      The stdout should include 'http://localhost:4070'
      The status should be success
    End
  End
End

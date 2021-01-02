# shellcheck shell=sh
Describe "cli.sh"
  Include ./cli.sh

  # strip all non-alpha characters from string, convert to lowercase
  # trim hyphens from start and end and double-hyphens

  fDescribe "sanitize_site_name()"
    It "strips all non-alpha characters from string"
      # Data "mywpte\$%@#\$@stsitename"
      When call sanitize_site_name "mywpte\$%@#\$@stsitename"
      The output should equal "mywptestsitename"
      The variable SITE_NAME should equal "mywptestsitename"
      The status should be success
    End
  End

  Describe "main_menu()"
    It "exits when q is given"
      Data "q"
      When run main_menu
      The stdout should include 'Lokl launcher & management script'
      The status should be success
    End
  End

  Describe "set_site_port()"
    It "remains empty if $lokl_site_port not set"
      When run set_site_port
      # TODO: terrible assertions, try to redirect output on errors
      The stderr should include ''
      The status should equal 1
    End

    It "prints to stdout if $lokl_site_port set"
      lokl_site_port="4444"

      When run set_site_port
      The stdout should include '4444'
      The status should equal 0
    End
  End

  Describe "set_site_name()"
    It "remains empty if $lokl_site_name not set"
      When run set_site_name
      # TODO: terrible assertions, try to redirect output on errors
      The stderr should include ''
      The status should equal 1
    End

    It "prints to stdout if $lokl_site_name set"
      lokl_site_name="mytestwpsitename"

      When run set_site_name
      The stdout should include 'mytestwpsitename'
      The status should equal 0
    End
  End


  Describe "set_docker_tag()"
    It "defaults to php8 if $lokl_php_ver not set"
      When run set_docker_tag
      # TODO: terrible assertions, try to redirect output on errors
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
        echo '/usr/bin/curl'
        return 0
      }

      When run test_curl_available
      The status should equal 0
    End

    It "exits with error code when cURL is missing"
      # simulate curl missing
      command() {
        return 1
      }

      When run test_curl_available
      The stdout should include "cURL doesn't seem to be installed."
      The status should equal 1
    End
  End

  Describe "test_docker_available()"
    It "returns OK when sample image runs OK"
      # simulate docker available and hello-world ran OK
      docker() {
        return 0
      }

      When run test_docker_available
      The status should equal 0
    End

    It "exits with error code when can't run sample image"
      # simulate docker unavailable or hello-world didn't run OK
      docker() {
        return 1
      }

      When run test_docker_available
      The stdout should include "Docker doesn't seem to be running or suitably configured for Lokl"
      The status should equal 1
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
        # TODO: specify fn exit codes with `return`
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

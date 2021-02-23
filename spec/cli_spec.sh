# shellcheck shell=sh disable=SC2034
Describe "cli.sh"
  Include ./cli.sh

  xIt "exits when under test"

  End

  xIt "skips wizard and "

  End

  Describe "lokl_log()"
    It "prints message to log file"

      # mock date '+%H:%M:%S'
      date() {
        echo '22:33:44'
      }

      # clear log before test
      echo '' > /tmp/lokldebuglog

      When call lokl_log 'My log message'
      The contents of file "/tmp/lokldebuglog" should equal "
22:33:44: My log message"
      The status should be success
    End
  End

  Describe "get_container_state_from_id()"
    It "returns container port"

      # mock docker inspect --format='{{.State.Status}}'
      docker() {
        echo 'running'
      }

      When call get_container_state_from_id 'someid'
      The output should equal 'running'
      The status should be success
    End
  End

  Describe "get_container_port_from_id()"
    It "returns container port"

      # mock docker inspect --format='{{.NetworkSettings.Ports}}'
      docker() {
        cat ./spec/test-data/docker-inspect-port-mapping-0-0-0-0-4363
      }

      When call get_container_port_from_id 'someid'
      The output should equal '4363'
      The status should be success
    End
  End

  Describe "get_container_name_from_id()"
    It "returns container name with leading slash stripped"

      # mock docker inspect --format='{{.Name}}'
      docker() {
        echo '/checktimeouts'
      }

      When call get_container_name_from_id 'someid'
      The output should equal 'checktimeouts'
      The status should be success
    End
  End

  Describe "set_site_poll_sleep_duration()"
    It "uses 5 seconds in production "
      When call set_site_poll_sleep_duration 0
      The output should equal '5'
      The status should be success
    End

    It "uses 0.1 seconds under test "
      When call set_site_poll_sleep_duration 1
      The output should equal '0.1'
      The status should be success
    End
  End

  Describe "set_curl_timeout_max_attempts()"
    It "tries 12 times in production "
      When call set_curl_timeout_max_attempts 0
      The output should equal '12'
      The status should be success
    End

    It "tries twice under test "
      When call set_curl_timeout_max_attempts 1
      The output should equal '2'
      The status should be success
    End
  End

  Describe "manage_sites_menu()"
    It "alerts that no site had been created and quit"
      docker() {
        echo ""
      }

      Data "q"
      When run manage_sites_menu
      The output should include 'No site created.'
      The status should be success
    End

    It "alerts that no site had been created and show creation menu"
      docker() {
        echo ""
      }

      Data "a"
      When run manage_sites_menu
      The output should include 'Type your site name'
      The status should equal 1
    End
  End

  Describe "generate_site_list()"
    It "prints numerically indexed list of site names"

      export LOKL_CONTAINERS="6f515f11c638
7874d8ccd920"

      get_container_name_from_id() {
        echo 'mywptestsite'
      }

      get_container_port_from_id() {
        echo '4455'
      }

      get_container_state_from_id() {
        echo 'running'
      }

      When call generate_site_list
      The line 1 should equal '1)  mywptestsite'
      The line 2 should equal '2)  mywptestsite'
      The status should be success
    End

    It "saves each site's container information to temp cache file"

      export LOKL_CONTAINERS="6f515f11c638
7874d8ccd920"

      get_container_name_from_id() {
        echo 'mywptestsite'
      }

      get_container_port_from_id() {
        echo '4455'
      }

      get_container_state_from_id() {
        echo 'running'
      }

      When call generate_site_list
      # without including these assertions, we get warning
      The line 1 should equal '1)  mywptestsite'
      The line 2 should equal '2)  mywptestsite'
      # TODO: isolate from real Lokl sites on test machine
      Path cache-file-1=/tmp/lokl_containers_cache/1
      Path cache-file-2=/tmp/lokl_containers_cache/2
      The path cache-file-1 should be exist
      The path cache-file-2 should be exist
      The status should be success
    End
  End

  Describe "get_random_port()"
    It "returns random port between 4000 and 5000"
      # shellcheck disable=SC2154
      acceptable_port_number() {
        [ "$acceptable_port_number" -ge 3999 ] && [ "$acceptable_port_number" -le 5001 ]  
      }

      When call get_random_port
      The output should satisfy acceptable_port_number
      The status should be success
    End
  End

  Describe "get_lokl_container_ids()"
    It "returns only Lokl container IDs"

      # mock docker ps -a with lokl and non-lokl containers
      docker(){
        cat ./spec/test-data/docker-ps-a-output-mixed-001
      }

      When call get_lokl_container_ids
      The output should equal "5577ddd81ed7
6ff99c2ca462
f089aa00ac98
7874d8ccd920
9a54863ee7a2"
      The status should be success
    End
  End

  Describe "test_core_capabilities()"
    It "passes when docker and curl are available"

      test_docker_available(){
        return 0
      }

      test_curl_available(){
        return 0
      }

      When call test_core_capabilities
      The output should include "Checking system requirements..."
      The status should be success
    End

    It "fails when docker and curl aren't available"

      test_docker_available(){
        return 1
      }

      test_curl_available(){
        return 1
      }

      When call test_core_capabilities
      The output should include "Checking system requirements..."
      The status should be failure
    End
  End

  Describe "sanitize_site_name()"
    It "strips all non-alpha characters from string"
      When call sanitize_site_name "mywpte\$%@#\$@stsitename"
      The output should equal "mywptestsitename"
      The status should be success
    End

    It "converts chars to lowercase"
      When call sanitize_site_name "MYWPTEST SITE NAME"
      The output should equal "mywptestsitename"
      The status should be success
    End

    It "trims all hyphens"
      When call sanitize_site_name "-mywptest--sitename-"
      The output should equal "mywptestsitename"
      The status should be success
    End

    It "trims to 100 characters"
      When call sanitize_site_name "drbvkgdeqommcfsxrqfijlbzuayskgahltymfpckuexhykigdtoisuemtfqcabcdjdsfiipwkkowhspxjxwqkkecthisistheendoverflow"
      The output should equal "drbvkgdeqommcfsxrqfijlbzuayskgahltymfpckuexhykigdtoisuemtfqcabcdjdsfiipwkkowhspxjxwqkkecthisistheend"
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

    It "launches create_site_choose_name when c is given"
      create_site_choose_name() {
        echo "create_site_choose_name() called"
      }

      Data "c"
      When run main_menu
      The stdout should include 'create_site_choose_name() called'
      The status should be success
    End

    It "launches manage_sites_menu when c is given"
      manage_sites_menu() {
        echo "manage_sites_menu() called"
      }

      Data "m"
      When run main_menu
      The stdout should include 'manage_sites_menu() called'
      The status should be success
    End
  End

  Describe "set_site_port()"
    It "remains empty if $lokl_site_port not set"
      When call set_site_port
      The output should equal ''
      The status should be success
    End

    It "prints to stdout if $lokl_site_port set"
      lokl_site_port="4444"

      When call set_site_port
      The output should equal '4444'
      The status should be success
    End
  End

  Describe "set_site_name()"
    It "remains empty if $lokl_site_name not set"
      When call set_site_name
      The output should equal '' 
      The status should be success
    End

    It "prints to stdout if $lokl_site_name set"
      lokl_site_name="mytestwpsitename"

      When call set_site_name
      The output should equal 'mytestwpsitename'
      The status should be success
    End
  End

  Describe "set_docker_tag()"
    It "defaults to php8-LOKL_RELEASE_VERSION if $lokl_php_ver not set"
      LOKL_RELEASE_VERSION=0.0.1

      When call set_docker_tag
      The output should equal 'php8-0.0.1'
      The status should be success
    End

    It "prints to stdout if $lokl_php_ver set"
      LOKL_RELEASE_VERSION=0.0.1
      lokl_php_ver="php7"

      When call set_docker_tag
      The output should equal 'php7-0.0.1'
      The status should be success
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

  Describe "create_site_choose_php_version()"
    create_wordpress_docker_container() {
      echo "create_wordpress_docker_container() called"
      return 0
    }

    It "sets docker image tag to php8-LOKL_RELEASE_VERSION when 8 chosen"
      LOKL_RELEASE_VERSION=0.0.1
      Data "8"
      When call create_site_choose_php_version
      The variable LOKL_DOCKER_TAG should equal 'php8-0.0.1'
      The output should include \
        'create_wordpress_docker_container() called'
      The status should be success
    End

    It "sets docker image tag to php7-LOKL_RELEASE_VERSION when 7 chosen"
      LOKL_RELEASE_VERSION=0.0.1
      Data "7"
      When call create_site_choose_php_version
      The variable LOKL_DOCKER_TAG should equal 'php7-0.0.1'
      The output should include \
        'create_wordpress_docker_container() called'
      The status should be success
    End
  End

  Describe "create_site_choose_name()"
    It "sets LOKL_NAME to site name when proper name is given"
      # mock test_core_capabilities as not core to this test 
      test_core_capabilities() {
        return 0
      }

      create_site_choose_php_version() {
        echo "create_site_choose_php_version() called"
        return 0
      }

      Data "mywptestsitename"
      When call create_site_choose_name
      The variable LOKL_NAME should equal 'mywptestsitename'
      The stdout should include \
        'create_site_choose_php_version() called'
      The status should be success
    End

    It "prompts for site name again if input invalid"
      test_core_capabilities() {
        return 0
      }

      Data ""
      When run create_site_choose_name
      The variable LOKL_NAME should equal ""
      The stdout should include 'Choose a name for your new Lokl WordPress site'
      The status should be failure
    End
  End

  Describe "create_wordpress_docker_container()"
    It "launches container with name and random port when proper name is given"
      LOKL_NAME="mywptestsitename"

      docker() {
        return 0
      }

      get_random_port() {
        echo "4070"
      }

      wait_for_site_reachable() {
        return 0
      }

      Data "mywptestsitename"
      When run create_wordpress_docker_container
      The stdout should include 'Your new Lokl WordPress site, mywptestsitename, is ready at:'
      The stdout should include 'http://localhost:4070'
      The status should be success
    End
  End

  Describe "wait_for_site_reachable()"
    It "exits if site doesn't come online after max polling duration"
      LOKL_TEST_MODE="1"

      curl() {
        echo "mocking unsuccessful curl to container..."
        return 1
      }

      When run wait_for_site_reachable "mywptestsitename" "4070"
      The lines of stdout should equal 5
      The stdout should include 'Timed out waiting for site to come online..'
      The status should be failure
    End

    It "succeeds if site is reachable within max polling duration"
      LOKL_TEST_MODE="1"

      curl() {
        return 0
      }

      When run wait_for_site_reachable "mywptestsitename" "4070"
      The lines of stdout should equal 1
      The stdout should equal \
        'Waiting for mywptestsitename to be ready at http://localhost:4070'
      The status should be success

    End
  End
End



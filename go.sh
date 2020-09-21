#!/bin/sh
#
# lokl-go: Lokl WordPress site launcher & manager
#
# Allows users to easily spin-up and manage new Lokl WordPress instances
#
# Feature to-do list:
#   - [ ] spin-up new Lokl WordPress site
#   - [ ] manage existing Lokl WordPress sites
#
# License: The Unlicense, https://unlicense.org
#
# Usage: execute this script from the project root
#
#     run from internet:
#
#     $   \curl -sSL https://lokl.dev/go | bash
#
#     run locally:
#
#     $   sh go.sh
#

main_menu() {
  clear
  echo ""
  echo "====================================="
  echo "  Lokl launcher & management script  "
  echo "====================================="
  echo ""
  echo "c) Create new Lokl WordPress site"
  echo "m) Manage my existing Lokl sites"
  echo ""
  echo "q) Quit this menu"
  echo ""
  echo ""
  echo "Please type (c), (m) or (q) and the Enter key: "
  echo ""
  read -r main_menu_choice

  if [ "$main_menu_choice" != "${main_menu_choice#[cmq]}" ] ;then
    case $main_menu_choice in
      c|C) create_site_choose_name ;;
      m|M) manage_sites_menu ;;
      q|Q) exit 0 ;;
    esac

  else
    main_menu
  fi
}

create_site_choose_name() {
  clear
  echo ""
  echo "================================================"
  echo "      Lokl launcher & management script         "
  echo "================================================"
  echo "   Press (Ctrl) and (c) keys to exit anytime    "
  echo "------------------------------------------------"
  echo ""
  echo "Choose a name for your new Lokl WordPress site. "
  echo ""
  echo "Please use letters, numbers and hyphens         "
  echo ""
  echo "ie, portfolio"
  echo ""
  echo ""
  echo "Type your site name, then the Enter key: "
  echo ""
  read -r create_site_name_choice

  # strip all non-alpha characters from string, convert to lowercase
  LOKL_NAME="$(echo "$create_site_name_choice" | tr -cd '[:alnum:]-' | \
    tr '[:upper:]' '[:lower:]')"

  # trim hyphens from start and end and double-hyphens
  LOKL_NAME="$(echo "$LOKL_NAME" | sed 's/--//g' | sed 's/^-//' | sed 's/-$//')"

  # check name is not empty
  if [ "$LOKL_NAME" = "" ]; then
    create_site_choose_name
  else
    # trim to 100 chars if over
    LOKL_NAME="$(echo "$LOKL_NAME" | cut -c1-100)"

    echo "Launching your new Lokl WordPress site!"
    echo "$LOKL_NAME"

    LOKL_PORT="$(awk -v min=4000 -v max=5000 'BEGIN{srand(); print int(min+rand()*(max-min+1))}')"
    LOKL_VERSION=0.0.18
    docker run -e N="$LOKL_NAME" -e P="$LOKL_PORT" \
      --name="$LOKL_NAME" -p "$LOKL_PORT":"$LOKL_PORT" \
      -d lokl/lokl:"$LOKL_VERSION"

   # TODO: poll until site accessible, print progresss

   echo "Done! Access your Lokl WordPress site at:"
   echo "http://localhost:$LOKL_PORT"
   echo ""
   echo "Press any key to manage sites:"

   read -r ""
   manage_sites_menu
  fi

}

manage_sites_menu() {
  clear
  echo ""
  echo "================================================"
  echo "      Lokl launcher & management script         "
  echo "================================================"
  echo "   Press (Ctrl) and (c) keys to exit anytime    "
  echo "------------------------------------------------"
  echo ""
  echo "Your Lokl WordPress sites"
  echo ""
  # get all lokl container IDs
  LOKL_CONTAINERS="$(docker ps -a | awk '{ print $1,$2 }' | grep lokl | awk '{print $1 }')"

  # empty flatfile lokl containers cache
  rm -Rf /tmp/lokl_containers_cache/*
  mkdir -p /tmp/lokl_containers_cache/

  SITE_COUNTER=1

  # POSIX compliant way to iterate a list
  OLDIFS="$IFS"
  IFS='
'
  for CONTAINER_ID in $LOKL_CONTAINERS
  do
    CONTAINER_NAME="$(docker inspect --format='{{.Name}}' "$CONTAINER_ID" | sed 's|/||')"
    # get container's exposed port
    CONTAINER_PORT="$(docker inspect --format='{{.NetworkSettings.Ports}}' "$CONTAINER_ID" | \
      sed 's/^[^{]*{\([^{}]*\)}.*/\1/' | awk '{print $2}')"

    # print choices for user
    echo "$SITE_COUNTER)  $CONTAINER_NAME"

    # append choices in cache file named for site counter (brittle internal ID) 
    echo "$CONTAINER_ID,$CONTAINER_NAME,$CONTAINER_PORT" >> /tmp/lokl_containers_cache/$SITE_COUNTER

    SITE_COUNTER=$((SITE_COUNTER+1))
  done
  IFS="$OLDIFS"

  echo ""
  echo "Choose the site you want to manage."
  echo ""
  echo "Type your site's number, then the Enter key: "
  echo ""

  read -r site_to_manage_choice

  # check int selected is in range of available sites
  if [ ! -f "/tmp/lokl_containers_cache/$site_to_manage_choice" ]; then
    echo "Requested site not found, try again"
    manage_sites_menu
  else 
    manage_single_site
  fi
}

manage_single_site() {
  # load lokl container info from cache file

  CONTAINER_INFO=$(cat "/tmp/lokl_containers_cache/$site_to_manage_choice") 

  CONTAINER_ID=$(echo "$CONTAINER_INFO" | cut -f1 -d,)
  CONTAINER_NAME=$(echo "$CONTAINER_INFO" | cut -f2 -d,)
  CONTAINER_PORT=$(echo "$CONTAINER_INFO" | cut -f3 -d,)

  # print out details
  echo "Site: $CONTAINER_NAME"
  echo ""
  echo "Choose action to perform: "
  echo ""
  echo "o) open in browser  http://localhost:$CONTAINER_PORT"
  echo "s) SSH into container"
  echo "t) take snapshot backup of container"
  echo ""
}

# get all lokl container ports and find another within 4000-5000 range
get_available_container_port() {
  echo ""
  # get all lokl container IDs
  LOKL_CONTAINERS="$(docker ps -a | awk '{ print $1,$2 }' | grep lokl | awk '{print $1 }')"

  # POSIX compliant way to iterate a list
  OLDIFS="$IFS"
  IFS='
'
  for CONTAINER_ID in $LOKL_CONTAINERS
  do
    # get container's exposed port
    CONTAINER_PORT="$(docker inspect --format='{{.NetworkSettings.Ports}}' "$CONTAINER_ID" | \
      sed 's/^[^{]*{\([^{}]*\)}.*/\1/' | awk '{print $2}')"

    echo "$SITE_COUNTER)  http://localhost:$CONTAINER_PORT"

    SITE_COUNTER=$((SITE_COUNTER+1))
  done
  IFS="$OLDIFS"

  echo "Available container port:"
}

main_menu

exit 0





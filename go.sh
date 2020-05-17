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

  echo "Please type (c), (m) or (q) and the Enter key: "
  echo ""
  read -r main_menu_choice

  if [ "$main_menu_choice" != "${main_menu_choice#[cmq]}" ] ;then
    echo "Good choice, let's show you another menu!"
  else
    main_menu
  fi
}

main_menu

exit 0

# Lokl configuration file example
#
# Add to a $HOME/.lokl/templates/ directory
#
# This will allow you to choose to create a site from template
#
# Initially, allowing you to set volumes to mount
#
# Future versions may add extra functionality, like installing 
#  extra plugins/themes, etc during provisioning
#
# Usage:
#
# Name the template file for recognition, ie default-php8-mount-my-plugins
#
# Template selection is offered after choosing a name for your site,
#  if your $HOME/.lokl/templates/ directory contains any valid templates
#
# Required template fields:
#
# PHP_VERSION
# VOLUMES
#
# License: The Unlicense, https://unlicense.org

PHP_VERSION

8

VOLUMES

/Users/leon/wp2static,/usr/html/wp-content/plugins/wp2static
/Users/leon/wp2static-addon-netlify,/usr/html/wp-content/plugins/wp2static-addon-netlify

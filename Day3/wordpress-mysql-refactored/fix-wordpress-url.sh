#!/bin/bash
# Run this if WordPress installed with the wrong siteurl/home.
# Updates wp_options directly in MySQL.
#
# Usage: ./fix-wordpress-url.sh <route-hostname>
# Example: ./fix-wordpress-url.sh wordpress-jegan.apps.ocp4.palmeto.org

if [ -z "$1" ]; then
  echo "Usage: $0 <route-hostname>"
  echo "Example: $0 wordpress-jegan.apps.ocp4.palmeto.org"
  exit 1
fi

HOSTNAME=$1
CORRECT_URL="http://${HOSTNAME}"

echo "\nFixing WordPress site URL to: ${CORRECT_URL}"

oc exec mysql-0 -- mysql -uroot -proot@123 wordpress <<SQL
UPDATE wp_options SET option_value = '${CORRECT_URL}' WHERE option_name = 'siteurl';
UPDATE wp_options SET option_value = '${CORRECT_URL}' WHERE option_name = 'home';
SELECT option_name, option_value FROM wp_options WHERE option_name IN ('siteurl','home');
SQL

echo "\nDone. No restart needed - try the URL in your browser immediately."

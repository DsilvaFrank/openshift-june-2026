#!/bin/bash
# Run this if WordPress is already installed with the wrong siteurl/home.
# It directly updates wp_options in MySQL to the correct Route hostname.
#
# Usage: ./fix-wordpress-url.sh <correct-hostname>
# Example: ./fix-wordpress-url.sh wordpress-jegan.apps.ocp4.example.com
#
# Get your Route hostname first:
#   oc get route wordpress -o jsonpath='{.spec.host}'

if [ -z "$1" ]; then
  echo "Usage: $0 <route-hostname>"
  echo "Example: $0 wordpress-jegan.apps.ocp4.example.com"
  exit 1
fi

HOSTNAME=$1
CORRECT_URL="http://${HOSTNAME}"

echo "\nFixing WordPress site URL to: ${CORRECT_URL}"

# Run the SQL directly on mysql-0 (the primary/writer)
oc exec mysql-0 -- mysql -uroot -proot@123 wordpress <<SQL
UPDATE wp_options SET option_value = '${CORRECT_URL}' WHERE option_name = 'siteurl';
UPDATE wp_options SET option_value = '${CORRECT_URL}' WHERE option_name = 'home';
SELECT option_name, option_value FROM wp_options WHERE option_name IN ('siteurl','home');
SQL

echo "\nDone. Also update wordpress-cm.yml blog_hostname to: ${HOSTNAME}"
echo "Then run:"
echo "  oc apply -f wordpress-cm.yml"
echo "  oc rollout restart statefulset/wordpress"

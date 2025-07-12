#!/bin/sh
set -e

CATALINA_HOME="/opt/apache-tomcat-9.0.107"
CONFIG_FILE="$CATALINA_HOME/webapps/ROOT/WEB-INF/classes/WindwardReports.properties"
LICENSE_LINE="license=6a1ec2b7-1db4-4336-a181-658d06c00601"

# Start Tomcat in the background
"$CATALINA_HOME/bin/catalina.sh" start 
sleep 5

# Wait for the config file to appear (timeout after 60 seconds)
timeout=5
while [ ! -f "$CONFIG_FILE" ] && [ $timeout -gt 0 ]; do
  sleep 1
  timeout=$((timeout - 1))
done

# Patch the license line
if [ -f "$CONFIG_FILE" ]; then
  if grep -q '^license=' "$CONFIG_FILE"; then
    sed -i "s/^license=.*/$LICENSE_LINE/" "$CONFIG_FILE"
  else
    echo "$LICENSE_LINE" >> "$CONFIG_FILE"
  fi
else
  echo "$LICENSE_LINE" > "$CONFIG_FILE"
fi

# Stop Tomcat gracefully
"$CATALINA_HOME/bin/catalina.sh" stop

# Wait for shutdown to complete
sleep 5

# Start Tomcat in the foreground
exec "$CATALINA_HOME/bin/catalina.sh" run

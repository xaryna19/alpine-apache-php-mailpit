#!/bin/sh
DIRECTORY_TO_WATCH="/path/to/directory"
echo $$ > /run/monitor_directory.pid  # Store the PID of this process
/usr/local/bin/mailpit -d /var/lib/mailpit/mailpit.db -m 1000 --smtp-auth-allow-insecure --quiet

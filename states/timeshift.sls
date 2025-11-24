timeshift:
    pkg.installed: []
    cmd.run:
        - name: "timeshift --scripted --create --rsync --snapshot-device /dev/sda2 --tags B"
        - creates: /etc/timeshift/timeshift.json
        - requires:
            - pkg: timeshift
        - watch_in:
            - cmd: /etc/timeshift/timeshift.json

jq:
    pkg.installed: []

/etc/timeshift/timeshift.json:
    cmd.wait:
        - name: jq '.stop_cron_emails = "true" | .schedule_monthly = "true" | .schedule_weekly = "true" | .schedule_daily = "true" | .schedule_hourly = "false" | .schedule_boot = "true" | .count_monthly = "2" | .count_weekly = "3" | .count_daily = "5" | .count_hourly = "6" | .count_boot = "5"' /etc/timeshift/timeshift.json > /tmp/timeshift.json && mv /tmp/timeshift.json /etc/timeshift/timeshift.json
        - requires:
            - pkg: jq
        - watch_in:
            - cmd: timeshift --scripted --check
  
timeshift --scripted --check:
    cmd.wait: []

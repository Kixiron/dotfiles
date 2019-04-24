# Update stuff
update() {
    apt update
    apt upgrade
    apt dist-upgrade
    snap refresh
    rustup update
    apt autoremove
}

# Update At 14:00 on Monday, Thursday, and Saturday.
crontab 0 14 * * 1,4,6 update

# Update on reboot
crontab @reboot update

# Restart cron to make sure changes are saved
service crond restart

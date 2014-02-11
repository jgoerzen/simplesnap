#
# Regular cron jobs for the simplesnap package
#
0 4	* * *	root	[ -x /usr/bin/simplesnap_maintenance ] && /usr/bin/simplesnap_maintenance

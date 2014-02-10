simplesnap

DESCRIPTION

simplesnap is a simple way to send ZFS snapshots across a network.
Although it can serve many purposes, its primary goal is to manage
backups from one ZFS filesystem to a backup filesystem also running
ZFS, using incremental backups to minimize network traffic and disk
usage.

simplesnap:

 * Does one thing and does it well.  It is designed to be used with
   a snapshot auto-rotator on both ends (such as zfSnap).  simplesnap
   will transfer snapshots made by other tools, but will not destroy
   them on either end.

 * Requires ssh public key authorization to the host being backed up,
   but does not require permission to run arbitrary commands.  It has
   a wrapper to run on the backup host, written in bash, which accepts
   only three operations and performs them simply.  It is suitable for
   a locked-down authorized_keys file.

 * Creates minimal snapshots for its own internal purposes, generally
   leaving no more than 1 or 2 per dataset, and reaps them
   automatically without touching others.

 * Most of the code is devoted to sanity-checking, security, and error
   checking.

 * Automatically discovers what datasets to back up from the remote.
   Uses a user-defined zfs property to exclude filesystems that should
   not be backed up.

 * Logs copiously to syslog on all hosts involved in backups.

 * Intelligently supports a single machine being backed up by multiple
   backup hosts, or onto multiple sets of backup media (when, for
   instance, backup media is cycled into offsite storage)

LICENSE

Copyright (c) 2014 John Goerzen


   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.


See file COPYING for details.

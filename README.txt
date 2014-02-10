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

PREREQUISITES

Requires:

 * GNU bash
 * logger (from bsdutils on Linux; 
   ftp://ftp.us.kernel.org/pub/linux/utils/util-linux-ng/ or 
   git://git.debian.org/~lamont/util-linux.git )

Highly recommended:

 * An automatic snapshotting and rotation system.  I use zfSnap from
   https://github.com/graudeejs/zfSnap

 * optional but recommended: dotlockfile from liblockfile.

This has been tested on Debian Linux with ZFSOnLinux.  It will
probably work on FreeBSD or Solaris as well, especially if the GNU
tools are installed or available under "g" names.  The script will try
to find them with those names and use them if possible.

INSTALLATION

Copy simplesnap somewhere on the host that will store backups and mark
it executable.

Copy simplesnapwrap somewhere on the hosts that will be backed up and
mark it executable.

If the host storing backups will also be backed up, it needs both.

CONFIGURATION

I will refer to the machine storing the backups as the "holderhost"
and the machine being backed up as the "serverhost".

First, on the holderhost, as root, generate an ssh keypair that will
be used for this purpose.

ssh-keygen -t rsa -f ~/.ssh/id_rsa_simplesnap

When prompted for a passphrase, leave it empty.

Now, on the serverhost, edit or create a file called
~/.ssh/authorized_keys.  Initialize it with the content of
~/.ssh/id_rsa_simplesnap.pub from the holderhost.  (Or, add to the
end, if you already have lines in the file.)  Then, at the
beginning of that one very long line, add text like this:

command="/usr/sbin/simplesnapwrap",from="1.2.3.4",no-port-forwarding,no-X11-forwarding,no-pty 

The 1.2.3.4 is the IP address that connections frmo the holderhost
will appear to come from.  It may be omitted if the IP is not static,
but it affords a little extra security.  The line will wind up looking
like:

command="/usr/sbin/simplesnapwrap",from="1.2.3.4",no-port-forwarding,no-X11-forwarding,no-pty ssh-rsa AAAA....

If there are any ZFS datasets you do not want to be backed up, set
org.complete.simplesnap:exclude property to on.  For instance:

zfs set org.complete.simplesnap:exclude=on tank/junkdata

Now, back on the holderhost, you should be able to run

ssh -i ~/.ssh/id_rsa_simplesnap serverhost

say yes when asked if you want to add the key to the known_hosts
file.  At this point, you should see output containing:

"This program is to be run from ssh."

If you see that, then simplesnapwrap was properly invoked remotely.

Now, create a ZFS filesystem to hold your backups.  For instance:

zfs create tank/simplesnap

Now, you can run the backup:

simplesnap --host serverhost --setname mainset --store tank/simplesnap

You can monitor progress in /var/log/syslog.  If all goes well, you
will see filesystems start to be populated under tank/simplesnap/host.

Note: you cannot use "=" in these commands.

Simple!

ADVANCED

Most people will always use the same setname.  The setname is used to
track the snapshots on the remote end.  simplesnap tries to always
leave one snapshot on the remote, to serve as the base for a future
incremental.

In some situations, you may have multiple bases for incrementals.  The
two primary examples are two different backup servers backing up the
same machine, or having two sets of backup media and rotating them to
offsite storage.  In these situations, you will have to keep different
snapshots on the serverhost for the different backups, since they will
be current to different points in time.

HOW IT WORKS

The operation is very simple.

simplesnap first connects to the simplesnapwrap and asks it for a
list of the ZFS datasets ("listfs" operation).  simplesnapwrap
responds with a list of all ZFS datasets that were not flagged for
exclusion.

Next, simplesnap connects back to simplesnapwrap once for each dataset
to be backed up -- the "sendback" operation.  simplesnap passes along
to it only two things: the setname and the dataset (filesystem) name.

simplesnapwrap looks to see if there is an existing simplesnap
snapshot corresponding to that setname.  If not, it creates one and
sends it as a full, non-incremental backup.  That completes the job
for that dataset.

If there is an existing snapshot for that setname, simplesnapwrap
creates a new one, then sends an incremental, using the oldest
snapshot from that setname as the basis for zfs send -I.

After the holderhost has observed zfs receive exiting without error,
it contacts simplesnapwrap once more and requests the "reap"
operation.  This cleans up the old snapshots for the given setname,
leaving only the most recent.  This is a separate operation in
simplesnapwrap ensuring that even if the transmission is interrupted,
still it will be OK in the end because zfs receive -F is used, and the
data will come across next time.

The idea is that some system like zfSnap will be used on both ends to
make periodic snapshots and clean them up.  One can use careful prefix
names with zfSnap to use different prefixes on each serverhost, and
then implement custom cleanup rules with -F on the holderhost.

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

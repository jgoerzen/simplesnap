simplesnap

DESCRIPTION


simplesnap:


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

simplesnap --host serverhost --setname mainset \
  --store tank/simplesnap \
  --sshcmd "ssh -i /root/.ssh/id_rsa_simplesnap"


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

simplesnap

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

#!/bin/sh
# Desc: Distribute unified copy of /etc/sudoers
#
# $Id: $
#set -x

export ODMDIR=/etc/repos

#
# perform any cleanup actions we need to do, and then exit with the
# passed status/return code
#
clean_exit()
{
cd /
test -f "$tmpfile" && rm $tmpfile
exit $1
}

#Set variables
PROG=`basename $0`
PLAT=`uname -s|awk '{print $1}'`
HOSTNAME=`uname -n | awk -F. '{print $1}'`
HOSTPFX=$(echo $HOSTNAME |cut -c 1-2)
NFSserver="nfs-server"
NFSdir="/NFS/AIXSOFT_NFS"
MOUNTPT="/mnt.$$"
MAILTO="unix@company.com"
DSTRING=$(date +%Y%m%d%H%M)
LOGFILE="/tmp/${PROG}.dist_sudoers.${DSTRING}.log"
BKUPFILE=/etc/sudoers.${DSTRING}
SRCFILE=${MOUNTPT}/skel/sudoers-uni
MD5FILE="/.sudoers.md5"

echo "Starting ${PROG} on ${HOSTNAME}" >> ${LOGFILE} 2>&1

# Make sure we run as root
runas=`id | awk -F'(' '{print $1}' | awk -F'=' '{print $2}'`
if [ $runas -ne 0 ] ; then
echo "$PROG: you must be root to run this script." >> ${LOGFILE} 2>&1
exit 1
fi

case "$PLAT" in
SunOS)
export PINGP=" -t 7 $NFSserver "
export MOUNTP=" -F nfs -o vers=3,soft "
export PATH="/usr/sbin:/usr/bin"
echo "SunOS" >> ${LOGFILE} 2>&1
exit 0
;;
AIX)
export PINGP=" -T 7 $NFSserver 2 2"
export MOUNTP=" -o vers=3,bsy,soft "
export PATH="/usr/bin:/etc:/usr/sbin:/usr/ucb:/usr/bin/X11:/sbin:/usr/java5/jre/bin:/usr/java5/bin"
printf "Continuing on AIX...\n\n" >> ${LOGFILE} 2>&1
;;
Linux)
export PINGP=" -t 7 -c 2 $NFSserver"
export MOUNTP=" -o nfsvers=3,soft "
export PATH="/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin"
printf "Continuing on Linux...\n\n" >> ${LOGFILE} 2>&1
;;
*)
echo "Unsupported Platform." >> ${LOGFILE} 2>&1
exit 1
esac

##
## Exclude Lawson Hosts
##
if [ ${HOSTPFX} = "la" ]
then
echo "Exiting Lawson host ${HOSTNAME} with no changes." >> ${LOGFILE} 2>&1
exit 0
fi

##
## * NFS Mount Section *
##

## Check to make sure NFS host is up
printf "Current PATH is..." >> ${LOGFILE} 2>&1
echo $PATH >> $LOGFILE 2>&1
ping $PINGP >> $LOGFILE 2>&1
if [ $? -ne 0 ]; then
echo " NFS server is DOWN ... ABORTING SCRIPT ... Please check server..." >> $LOGFILE
echo "$PROG failed on $HOSTNAME ... NFS server is DOWN ... ABORTING SCRIPT ... Please check server ... " | mailx -s "$PROG Failed on $HOSTNAME" $MAILTO
exit 1
else
echo " NFS server is UP ... We will continue..." >> $LOGFILE
fi

##
## Mount NFS share to HOSTNAME. We do this using a soft mount in case it is lost during a backup
##
mkdir $MOUNTPT
mount $MOUNTP $NFSserver:${NFSdir} $MOUNTPT >> $LOGFILE 2>&1

##
## Check to make sure mount command returned 0. If it did not odds are something else is mounted on /mnt.$$
##
if [ $? -ne 0 ]; then
echo " Mount command did not work ... Please check server ... Odds are something is mounted on $MOUNTPT ..." >> $LOGFILE
echo " $PROG failed on $HOSTNAME ... Mount command did not work ... Please check server ... Odds are something is mounted on $MOUNTPT ..." | mailx -s "$PROG Failed on $HOSTNAME" $MAILTO
exit 1
else
echo " Mount command returned a good status which means $MOUNPT was free for us to use ... We will now continue ..." >> $LOGFILE
fi

##
## Now check to see if the mount worked
##
if [ ! -f ${SRCFILE} ]; then
echo " File ${SRCFILE} is missing... Maybe NFS mount did NOT WORK ... Please check server ..." >> $LOGFILE
echo " $PROG failed on $HOSTNAME ... File ${SRCFILE} is missing... Maybe NFS mount did NOT WORK ... Please check server ..." | mailx -s "$PROG Failed on $HOSTNAME" $MA
ILTO
umount -f $MOUNTPT >> $LOGFILE
rmdir $MOUNTPT >> $LOGFILE
exit 1
else
echo " NFS mount worked we are going to continue ..." >> $LOGFILE
fi


##
## * Main Section *
##

if [ ! -f ${BKUPFILE} ]
then
cp -p /etc/sudoers ${BKUPFILE}
else
echo "Backup file already exists$" >> ${LOGFILE} 2>&1
exit 1
fi

if [ -f "$SRCFILE" ]
then
echo "Copying in new sudoers file from $SRCFILE." >> ${LOGFILE} 2>&1
cp -p $SRCFILE /etc/sudoers
chmod 440 /etc/sudoers
else
echo "Source file not found" >> ${LOGFILE} 2>&1
exit 1
fi

echo >> ${LOGFILE} 2>&1
visudo -c |tee -a ${LOGFILE}
if [ $? -ne 0 ]
then
echo "sudoers syntax error on $HOSTNAME." >> ${LOGFILE} 2>&1
mailx -s "${PROG}: sudoers syntax error on $HOSTNAME" "$MAILTO" << EOF

Syntax error /etc/sudoers on $HOSTNAME.

Reverting changes

Please investigate.

EOF
echo "Reverting changes." >> ${LOGFILE} 2>&1
cp -p ${BKUPFILE} /etc/sudoers
else
#
# Update checksum file
#
grep -v '/etc/sudoers' ${MD5FILE} > ${MD5FILE}.tmp
csum /etc/sudoers >> ${MD5FILE}.tmp
mv ${MD5FILE}.tmp ${MD5FILE}
chmod 600 ${MD5FILE}
fi

echo >> ${LOGFILE} 2>&1

if [ "${HOSTPFX}" = "hd" ]
then
printf "\nAppending #includedir /etc/sudoers.d at end of file.\n" >> ${LOGFILE} 2>&1
echo "" >> /etc/sudoers
echo "## Read drop-in files from /etc/sudoers.d (the # here does not mean a comment)" >> /etc/sudoers
echo "#includedir /etc/sudoers.d" >> /etc/sudoers
fi

##
## * NFS Un-mount Section *
##

##
## Unmount /mnt.$$ directory
##
umount ${MOUNTPT} >> $LOGFILE 2>&1
if [ -d ${MOUNTPT} ]; then
rmdir ${MOUNTPT} >> $LOGFILE 2>&1
fi

##
## Make sure that /mnt.$$ got unmounted
##
if [ -f ${SRCFILE} ]; then
echo " The umount command failed to unmount ${MOUNTPT} ... We will not force the unmount ..." >> $LOGFILE
umount -f ${MOUNTPT} >> $LOGFILE 2>&1
if [ -d ${MOUNTPT} ]; then
rmdir ${MOUNTPT} >> $LOGFILE 2>&1
fi
else
echo " $MOUNTPT was unmounted ... There is no need for user intervention on $HOSTNAME ..." >> $LOGFILE
fi

#
# as always, exit cleanly
#
clean_exit 0
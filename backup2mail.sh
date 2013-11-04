#!/bin/bash
#
# backup2email.sh - Creates backup tgz file and send it to e-mail account
#
# Site: 	https://github.com/ysidorito/backup2mail
# Author:	Rodolfo Pilas <rodolfo@pilas.net>
# 
# -----------------------------------------------------------------------
# This program creates a backup tgz file from external list of files and
# folders ($FILELIST), then enclose it to a email address ($TO)
#
# It all works no stdout message is issued. Ready as CRON process
# 
# -> requires full working MTA (smtp) server at localhost 
# -> requires mail command to deliver errors (package bsd-mailx)
# -> requires package: biabam
# -----------------------------------------------------------------------
#
# History:
# 1.0 2013-11-01 First stable/public release
#
# License: The MIT License (MIT)
# 
 
# -- CHANGE HERE -- ####################################################
TO="rootway@email-gmail.com"    # e-mail to send backup files
FILELIST=respaldar.txt          # file at the same directory with 
                                #   file & folders to backup

########################################################################

# -- NO more change needed from here -- ################################

function filelistpath() {
    if [ -h $0 ]; then
        RESPARCHIVO=`dirname $(readlink $0)`/$FILELIST;
    else
        RESPARCHIVO=`dirname $0`/$FILELIST;
    fi
    if [ ! -f $RESPARCHIVO ]; then
        echo "$RESPARCHIVO file not found" | /usr/bin/mail -s "$HOSTNAME Error" $TO
        exit 1
    fi
}

filelistpath
DATE=$(date +%Y%m%d-%H%M)
DIRTMP=$RANDOM
DIRDEST=/tmp/$DIRTMP/$HOSTNAME-$DATE
if [ -x /usr/bin/biabam ]; then
   mkdir -p $DIRDEST
   dpkg --get-selections > $DIRDEST/dpkg-selections   # Debian Package Manager !
   for RESPALDAR in $(cat $RESPARCHIVO); do
      cp -r --preserve --parents $RESPALDAR $DIRDEST
   done
   cd $DIRDEST
   tar czf /tmp/$DIRTMP/$HOSTNAME-$DATE.tgz .
   echo "Backup $HOSTNAME of $DATE is attached" | /usr/bin/biabam /tmp/$DIRTMP/$HOSTNAME-$DATE.tgz \
       -s "BACKUP $HOSTNAME of $DATE" $TO
   rm -R /tmp/$DIRTMP
else
   echo "biabam utility is not installed, apt-get install biabam" | /usr/bin/mail -s "$HOSTNAME Error" $TO
   exit 2
fi
exit 0


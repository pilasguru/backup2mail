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
# -> requires package: biabam
# -----------------------------------------------------------------------
#
# History:
# 1.5 2013-11-04 Errors to STDERR if mail command not present
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
        if [ -x /usr/bin/mail ]; then
            echo "ERROR: BACKUP $HOSTNAME Error: $RESPARCHIVO file not found" | /usr/bin/mail \
	    	-s "BACKUP $HOSTNAME Error" $TO
        else
	    echo "WARNING: Command mail not installed" >&2
            echo "ERROR: BACKUP $HOSTNAME Error: $RESPARCHIVO file not found"  >&2
        fi
        exit 1
    fi
}

function checkbiabam() {
if [ ! -x /usr/bin/biabam ]; then
   if [ -x /usr/bin/mail ]; then
      echo "ERROR: BACKUP $HOSTNAME Error: biabam utility is not installed" | /usr/bin/mail \
         -s "BACKUP $HOSTNAME Error" $TO
    else
      echo "WARNING: Command mail not installed" >&2
      echo "ERROR: BACKUP $HOSTNAME Error: biabam utility is not installed"  >&2
   fi
   exit 2
fi
}

filelistpath
checkbiabam
DATE=$(date +%Y%m%d-%H%M)
DIRTMP=$RANDOM
DIRDEST=/tmp/$DIRTMP/$HOSTNAME-$DATE

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

exit 0

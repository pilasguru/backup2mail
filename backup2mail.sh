#!/bin/bash
# Create backup of files (tgz) and send it to an e-mail account to storage 
# 
# -> requieres package biabam
 
# At the same directory requires $FILELIST with a file/folders to backup one per line
FILELIST=respaldar.txt
if [ -h $0 ]; then
   RESPARCHIVO=`dirname $(readlink $0)`/$FILELIST;
else
   RESPARCHIVO=`dirname $0`/$FILELIST;
fi
if [ ! -f $RESPARCHIVO ]; then
   echo "$RESPARCHIVO file not found" | /usr/bin/mail -s "$HOSTNAME Error" $TO; exit 1
fi
 
TO="rootway@email-gmail.com"  # CHANGE IT !!
 
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
 
if [ -x /usr/bin/biabam ]; then
   echo "Backup $HOSTNAME of $DATE is attached" | /usr/bin/biabam /tmp/$DIRTMP/$HOSTNAME-$DATE.tgz \
       -s "BACKUP $HOSTNAME of $DATE" $TO
else
   echo "biabam utility is not installed, apt-get install biabam" | /usr/bin/mail -s "$HOSTNAME Error" $TO
fi
 
rm -R /tmp/$DIRTMP
exit 0


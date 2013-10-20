#!/bin/bash
#
# respaldo y envio por e-mail
# -> requiere package biambam
 
# En mismo directorio respaldar.txt para lista archivos, uno por linea
if [ -h $0 ]; then
   RESPARCHIVO=`dirname $(readlink $0)`/respaldar.txt;
else
   RESPARCHIVO=`dirname $0`/respaldar.txt;
fi
if [ ! -f $RESPARCHIVO ]; then
   echo "Archivo $RESPARCHIVO no encontrado" | /usr/bin/mail -s "$HOSTNAME Error" $TO; exit 1
fi
 
TO="rootway@email-gmail.com"  # CAMBIAR !!
 
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
   echo "Adjunto archivo respaldo $HOSTNAME de fecha $DATE" | /usr/bin/biabam /tmp/$DIRTMP/$HOSTNAME-$DATE.tgz \
       -s "RESPALDO $HOSTNAME del $DATE" $TO
else
   echo "No existe el utilitario biabam, instale el paquete" | /usr/bin/mail -s "$HOSTNAME Error" $TO
fi
 
rm -R /tmp/$DIRTMP
exit 0


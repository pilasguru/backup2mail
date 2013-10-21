backup2mail
===========

Backup to mail, is a bash script to create local backup file and then send it to 
an e-mail account as attached file.

Installation
============

1. Requires a full functional MTA (smtp) working at localhost

2. Requires mail comand, i.e:  

	apt-get install bsd-mailx

3. Requires biabam utility: 

	apt-get install biabam

4. 
        cd /usr/local/src
        git clone https://github.com/ysidorito/backup2mail.git

5. 
        cd /usr/local/sbin
        cp ../src/backup2mail/backup2mail.sh .
        chmod 750 backup2mail.sh

6. Edit backup2mail.sh and configure first VARIABLES to your environment.

        TO="yourbackup@address.biz"

7. Create respaldar.txt file wih a file/folder at each line

        /etc
        /usr/local
        /var/www/index.php

8. Include into cron.daily task:

        ln -s /usr/local/sbin/backup2mail.sh /etc/cron.daily/backup2mail

Ready!


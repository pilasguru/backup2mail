backup2mail
===========

Backup to mail, is a bash script to create local backup file and then send it to 
an e-mail account as attached file.

Installation
------------

1. Requires a full functional MTA (smtp) working at localhost

2. Requires mail comand, i.e:  

```bash
apt-get install bsd-mailx
```

3. Requires biabam utility: 

```bash
apt-get install biabam
```

4. 
```bash
cd /usr/local/sbin
git clone https://github.com/ysidorito/backup2mail.git
cd backup2mail
chmod 750 backup2mail.sh
```

5. Edit backup2mail.sh and configure first VARIABLES to your environment.

```bash
TO="yourbackup@address.biz"
```

6. Create respaldar.txt file wih a file/folder at each line

```
/etc
/usr/local
/var/www/index.php
```

7. Include into cron.daily task:

```bash
ln -s /usr/local/sbin/backup2mail/backup2mail.sh /etc/cron.daily/backup2mail
```

Ready!


backup2mail
===========

Backup to mail, is a bash script to create local backup file and then send it to 
an e-mail account as attached file.

Installation
------------

* Requires a full functional MTA (smtp) working at localhost

* Requires mail comand, i.e:  

```bash
apt-get install bsd-mailx
```

* Requires biabam utility: 

```bash
apt-get install biabam
```

* Install backup2mail  (you may use git)
 
```bash
cd /usr/local/sbin
wget https://github.com/ysidorito/backup2mail/archive/master.zip
unzip master.zip && rm master.zip
cd backup2mail
chmod 750 backup2mail.sh
```

* Edit backup2mail.sh and configure first VARIABLES to your environment.

```bash
TO="yourbackup@address.biz"
```

* Create respaldar.txt file wih a file/folder at each line

```
/etc
/usr/local
/var/www/index.php
```

* Include into cron.daily task:

```bash
ln -s /usr/local/sbin/backup2mail/backup2mail.sh /etc/cron.daily/backup2mail
```

Ready!

ToDo
----

- [ ] Avoid local disk usage previous create tgz
- [ ] Incluir contenido del respaldo en el texto del e-mail
- [ ] Avoid error if $FILELIST do not exists (enables isolated run)
- [ ] Error to STDERR if mail command or smtp-local-server not installed
- [ ] Define max size to e-mail (perhaps split attached file)
- [ ] Ensure work on RedHat family OS too



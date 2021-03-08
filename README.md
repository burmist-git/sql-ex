Documentation
-------------

https://sql-ex.ru/
http://www.sql-tutorial.ru/
https://www.sql-ex.com/db_script_download.php

Installation
-------------
https://www.digitalocean.com/community/tutorials/how-to-create-a-new-user-and-grant-permissions-in-mysql
https://www.tutorialspoint.com/mysql-error-hash1046-no-database-selected
For information about MySQL products and services, visit:
http://www.mysql.com/
For developer information, including the MySQL Reference Manual, visit:
http://dev.mysql.com/
To buy MySQL Enterprise support, training, or other products, visit:
https://shop.mysql.com/
https://www.mysqltutorial.org/mysql-show-databases/SW
https://linuxhint.com/install_mysql_ubuntu_20-04/
https://itsfoss.com/install-mysql-ubuntu/
sudo apt install mysql-server -y
/etc/mysql/mysql.cnf
/etc/mysql/mysql.conf.d/mysqld.cnf
~/.mysql_history
sudo systemctl status mysql.service
sudo systemctl start mysql.service
sudo netstat -tap | grep mysql

sudo systemctl enable mysql
sudo systemctl disable mysql
sudo systemctl restart mysql
ss -ltn

mysql -h host_name -u user -p
mysql -u root -p




Uninstalling MySQL
-------------

sudo systemctl stop mysql.service && sudo systemctl disable mysql.service
sudo apt purge mysql*
sudo apt autoremove

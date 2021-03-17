#!/bin/bash

function DELUSER_sh {
    mysql -u root -p -e "DROP USER $username@$hostname;"
}

function SHOW_all_USER_sh {
    mysql -u root -p -e "TEE $outlog; \
    	     	     	 SELECT Host, User, Select_priv, Execute_priv, password_last_changed FROM mysql.user;"
}

function USER_sh {
    mysql -u root -p -e "TEE $outlog;
    	     	     	 SHOW TABLES FROM mysql; \
    	     	     	 desc mysql.user; \
			 CREATE USER $username@$hostname IDENTIFIED BY '111111'; \
			 grant all privileges on $username.* to $username@$hostname;
			 SELECT Host, User, Select_priv, Execute_priv, password_last_changed FROM mysql.user;"
}

function show_user_db_sh {
    mysql -u $username -p$motp -e "SHOW DATABASES;"
}

function creat_user_db_sh {
    echo "to be implemented"
    mysql -u $username -p$motp -e "CREATE DATABASE aero_test; \
    	     	     	       	   USE aero_test; \
    			 	   SOURCE $MYSQLDBCREATOR/aero_mysql_script.sql;"
    #mysql -u $username -p$motp -e "CREATE DATABASE aero; \
    #	     	     	       	   USE aero; \
    #			 	   SOURCE $MYSQLDBCREATOR/aero_mysql_script.sql; \
    #	     	     	 	   CREATE DATABASE inc; \
    #	     	     	 	   USE inc; \
    #			 	   SOURCE $MYSQLDBCREATOR/inc_out_mysql_script.sql; \
    #			 	   CREATE DATABASE painting; \
    #	     	     	 	   USE painting; \
    #			 	   SOURCE $MYSQLDBCREATOR/painting_mysql_script.sql; \
    #			 	   CREATE DATABASE computer; \
    #	     	     	 	   USE computer; \
    #			 	   SOURCE $MYSQLDBCREATOR/computer_mysql_script.sql; \
    #			 	   CREATE DATABASE ships; \
    #	     	     	 	   USE ships; \
    #			 	   SOURCE $MYSQLDBCREATOR/ships_mysql_script.sql;"
}

function show_db_sh {
    mysql -u root -p -e "SHOW DATABASES; \
    	     	     	 SHOW TABLES FROM aero; \
    	     	     	 SHOW TABLES FROM inc; \
			 SHOW TABLES FROM painting; \
			 SHOW TABLES FROM computer; \
			 SHOW TABLES FROM ships;"
}

function show_db_sh {
    mysql -u root -p -e "SHOW DATABASES; \
    	     	     	 SHOW TABLES FROM aero; \
    	     	     	 SHOW TABLES FROM inc; \
			 SHOW TABLES FROM painting; \
			 SHOW TABLES FROM computer; \
			 SHOW TABLES FROM ships;"
}

function creat_db_sh {
    tar -zxvf mysql_db_creator.tar.gz
    mysql -u root -p -e "CREATE DATABASE aero; \
    	     	     	 USE aero; \
			 SOURCE $MYSQLDBCREATOR/aero_mysql_script.sql; \
    	     	     	 CREATE DATABASE inc; \
    	     	     	 USE inc; \
			 SOURCE $MYSQLDBCREATOR/inc_out_mysql_script.sql; \
			 CREATE DATABASE painting; \
    	     	     	 USE painting; \
			 SOURCE $MYSQLDBCREATOR/painting_mysql_script.sql; \
			 CREATE DATABASE computer; \
    	     	     	 USE computer; \
			 SOURCE $MYSQLDBCREATOR/computer_mysql_script.sql; \
			 CREATE DATABASE ships; \
    	     	     	 USE ships; \
			 SOURCE $MYSQLDBCREATOR/ships_mysql_script.sql;"
}

function clean_db_sh {
    rm -rf $MYSQLDBCREATOR
    mysql -u root -p -e "DROP DATABASE aero; \
    	     	     	 DROP DATABASE inc; \
			 DROP DATABASE painting; \
			 DROP DATABASE computer; \
			 DROP DATABASE ships; \
			 SHOW DATABASES;"    
}

function printHelp {
    echo " --> ERROR in input arguments"
    echo " -h              : print help"
    echo " --show          : show DB"
    echo " --creat         : creat DB (CREATE DATABASE)"
    echo " --clean         : clean DB (DROP DATABASE)"
    echo " --makeuser      : make user"
    echo " --deluser       : delete user"
    echo " --show_all_user : show all users"
    echo " --show_user     : show user"
    echo " --creat_user    : creat user DB (CREATE DATABASE)"
}

MYSQLDBCREATOR='mysql_db_creator'
username="exer_user"
hostname="localhost"
motp='111111'

if [ $# -eq 0 ]; then
    printHelp
else
    if [ "$1" = "-h" ]; then
	printHelp
    elif [ "$1" = "--show" ]; then
	show_db_sh
    elif [ "$1" = "--show_all_user" ]; then
	SHOW_all_USER_sh    
    elif [ "$1" = "--creat" ]; then
	creat_db_sh
    elif [ "$1" = "--clean" ]; then
	clean_db_sh
    elif [ "$1" = "--makeuser" ]; then
	USER_sh
    elif [ "$1" = "--deluser" ]; then
	DELUSER_sh
    elif [ "$1" = "--show_user" ]; then
	show_user_db_sh
    elif [ "$1" = "--creat_user" ]; then
	creat_user_db_sh
    else
        printHelp
    fi
fi

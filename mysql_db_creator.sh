#!/bin/bash

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
    echo " -h      : print help"
    echo " --show  : show DB"
    echo " --creat : creat DB (CREATE DATABASE)"
    echo " --clean : clean DB (DROP DATABASE)"
}

MYSQLDBCREATOR='mysql_db_creator'

if [ $# -eq 0 ]; then
    printHelp
else
    if [ "$1" = "-h" ]; then
	printHelp
    elif [ "$1" = "--show" ]; then
	show_db_sh
    elif [ "$1" = "--creat" ]; then
	creat_db_sh
    elif [ "$1" = "--clean" ]; then
	clean_db_sh
    else
        printHelp
    fi
fi

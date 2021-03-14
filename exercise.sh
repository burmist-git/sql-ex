#!/bin/bash

function exercise_000 {
    mysql -u root -p -e "SHOW DATABASES; \
    	     	     	 SHOW TABLES FROM computer; \
			 SELECT * FROM computer.Product; \
			 SELECT * FROM computer.PC;"
}


#https://sql-ex.ru/learn_exercises.php
#Exercise: 1 (Serge I: 2002-09-30)
#Find the model number, speed and hard drive
#capacity for all the PCs with prices below $500.
#Result set: model, speed, hd.
function exercise_001 {
    mysql -u root -p -e "USE computer;
			 SELECT model, speed, hd \
    	     	     	 FROM PC \
			 WHERE price < 500;"
    #correct result
    #SELECT model, speed, hd 
    #FROM PC
    #WHERE price < 500
}

#https://sql-ex.ru/learn_exercises.php?LN=2
#Exercise: 2 (Serge I: 2002-09-21)
#List all printer makers. Result set: maker.
function exercise_002 {
    mysql -u root -p -e "USE computer; \
    	     	     	 SHOW TABLES FROM computer; \
    	     	     	 SELECT * FROM Product; \
			 SELECT * FROM Printer; \
			 SELECT DISTINCT maker FROM Product \
			 WHERE type='Printer';"
}

#https://sql-ex.ru/learn_exercises.php?LN=3
#Exercise: 3 (Serge I: 2002-09-30)
#Find the model number, RAM and screen size of the laptops with prices over $1000.
function exercise_003 {
    mysql -u root -p -e "USE computer; \
    	     	     	 SHOW TABLES FROM computer; \
    	     	     	 SELECT * FROM Product; \
			 SELECT * FROM Laptop; \
			 SELECT model, ram, screen FROM Laptop \
			 WHERE price>1000;"    
}

#https://sql-ex.ru/learn_exercises.php?LN=4
#Exercise: 4 (Serge I: 2002-09-21)
#Find all records from the Printer table containing data about color printers.
function exercise_004 {
    mysql -u root -p -e "USE computer; \
			 SELECT * FROM Printer \
			 WHERE color='y';"
}

#https://sql-ex.ru/learn_exercises.php?LN=5
#Exercise: 5 (Serge I: 2002-09-30)
#Find the model number, speed and hard drive capacity of PCs
#cheaper than $600 having a 12x or a 24x CD drive. 
function exercise_005 {
    mysql -u root -p -e "USE computer; \
			 SELECT model, speed, hd FROM PC \
			 WHERE (price<600) AND ((cd='12x') OR (cd='24x'));"
}

#https://sql-ex.ru/learn_exercises.php?LN=6
#Exercise: 6 (Serge I: 2002-10-28)
#For each maker producing laptops with a hard drive capacity of 10 Gb or higher,
#find the speed of such laptops. Result set: maker, speed. 
function exercise_006 {
    mysql -u root -p -e "USE computer; \
			 SELECT * FROM Laptop; \
			 SELECT * FROM Product; \
			 SELECT * FROM Product LEFT JOIN (Laptop) \
		          ON (Product.model = Laptop.model); \
			 SELECT maker, speed FROM Product RIGHT JOIN (Laptop) \
                	  ON (Product.model = Laptop.model) \
			 WHERE hd >= 10;"
    mysql -u root -p -e "USE computer; \
    	     	         SELECT DISTINCT maker, speed FROM \
			 Product RIGHT JOIN Laptop \
			  ON Product.model = Laptop.model \
			 WHERE hd >= 10;"
    #correct result
    #SELECT DISTINCT maker, speed FROM
    #Product RIGHT JOIN
    # Laptop ON Product.model = Laptop.model
    #WHERE hd >= 10
}

#https://sql-ex.ru/learn_exercises.php?LN=7
#Exercise: 7 (Serge I: 2002-11-02)
#Get the models and prices for all commercially available products (of any type) produced by maker B. 
function exercise_007 {
    mysql -u root -p -e "USE computer; \
			 SELECT Product.model, Product.maker, Laptop.price \
			 FROM Product JOIN Laptop \
			  ON Product.model = Laptop.model \
			 WHERE Product.maker LIKE 'B' \
    	     	         UNION \
			 SELECT Product.model, Product.maker, PC.price \
			 FROM Product JOIN PC \
			  ON Product.model = PC.model \
			 WHERE Product.maker LIKE 'B' \
    	     	         UNION \
			 SELECT Product.model, Product.maker, Printer.price \
			 FROM Product JOIN Printer \
			  ON Product.model = Printer.model \
			 WHERE Product.maker LIKE 'B';"
}
function exercise_00701 {
    mysql -u root -p -e "USE computer; \
    	     	     	 SELECT model, price FROM PC \
    			 WHERE model = (SELECT model FROM Product \
     			  		WHERE maker = 'B' AND type = 'PC') \
    			 UNION \
    			 SELECT model, price FROM Laptop \
			 WHERE model = (SELECT model FROM Product \
			       	        WHERE maker = 'B' AND type = 'Laptop') \
    		         UNION \
			 SELECT model, price FROM Printer \
    			 WHERE model = (SELECT model FROM Product \
     			       	        WHERE maker = 'B' AND type = 'Printer');"
}

#https://sql-ex.ru/learn_exercises.php?LN=8
#Exercise: 8 (Serge I: 2003-02-03)
#Find the makers producing PCs but not laptops.
function exercise_008 {
    #mysql -u root -p -e "USE computer; \
    #	     	     	 SELECT maker, type FROM Product \
    #			 WHERE type = 'PC' OR type = 'Printer'";
    #
    
    mysql -u root -p -e "USE computer; \
    	     	         SELECT * FROM \
			 (SELECT maker, type FROM Product WHERE type = 'PC') mm \
			 LEFT JOIN Product \
			  ON mm.maker = Product.maker \
			 WHERE Product.type <> 'Laptop';"

    
#    mysql -u root -p -e "USE computer; \
#			 SELECT Product.model, Product.maker, Laptop.price \
#			 FROM Product JOIN Laptop \
#			  ON Product.model = Laptop.model \
#			 WHERE Product.maker LIKE 'B' \
#   	     	         UNION \

#    mysql -u root -p -e "USE computer; \
#    	     	     	 SELECT t_pc.maker FROM \
#			 (SELECT * FROM Product WHERE type='PC') t_pc;"
}

function printHelp {
    echo " --> ERROR in input arguments"
    echo " -h  : print help"
    echo " 001 : first exercise "
    echo " XXX : last exercise"
}

MYSQLDBCREATOR='mysql_db_creator'

if [ $# -eq 0 ]; then
    printHelp
else
    if [ "$1" = "-h" ]; then
	printHelp
    else
	cmd='exercise_'$1
        $cmd
    fi
fi

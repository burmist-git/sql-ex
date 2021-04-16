#!/bin/bash

function exercise_000 {
    mysql -u root -p -e "TEE $outlog;
			 SHOW DATABASES; \
			 SELECT COUNT(*) FROM (SELECT * FROM sys.version) as tmp; \
    	     	     	 SHOW TABLES FROM computer; \
			 SELECT * FROM computer.Product; \
			 SELECT * FROM computer.PC; \
			 SELECT COUNT(*) FROM (SELECT * FROM sys.version) as tmp; \
    	     	     	 SHOW TABLES FROM ships; \
			 "
    #aero
    #inc
    #painting
    #ships
}

function exercise_VER {
    mysql -u root -p -e "SELECT * FROM sys.version"
}

#PRINT NULL (or space)
function exercise_NULL {
    mysql -u root -p -e "SELECT COUNT(*) FROM (SELECT * FROM sys.version) as tmp"
}

#SELECT * FROM t1
#LEFT JOIN t2 ON t1.id = t2.id
#UNION
#SELECT * FROM t1
#RIGHT JOIN t2 ON t1.id = t2.id
#The query above works for special cases where a FULL OUTER JOIN operation would not produce any duplicate rows.
#The query above depends on the UNION set operator to remove duplicate rows introduced by the query pattern.
#We can avoid introducing duplicate rows by using an anti-join pattern for the second query, and then
#use a UNION ALL set operator to combine the two sets. In the more general case, where a
#FULL OUTER JOIN would return duplicate rows, we can do this:
#SELECT * FROM t1
#LEFT JOIN t2 ON t1.id = t2.id
#UNION ALL
#SELECT * FROM t1
#RIGHT JOIN t2 ON t1.id = t2.id
#WHERE t1.id IS NULL
function exercise_FULL {
    mysql -u root -p -e "USE computer; \
    	     	     	 SELECT * FROM Product AS pr \
			 LEFT JOIN PC AS pc \
			 ON pr.model = pc.model \
			 UNION ALL \
			 SELECT * FROM Product AS pr \
			 RIGHT JOIN PC AS pc \
			 ON pr.model = pc.model \
			 WHERE pc.model IS NULL; \
    	     	     	 SELECT * FROM Product \
			 LEFT JOIN PC \
			 ON Product.model = PC.model \
			 UNION ALL \
			 SELECT * FROM Product \
			 RIGHT JOIN PC \
			 ON Product.model = PC.model \
			 WHERE Product.model IS NULL;"
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
    mysql -u root -p -e "USE computer; \
    	     	     	 SELECT thetable.maker_pc FROM (SELECT * FROM (SELECT DISTINCT Product.maker AS maker_pc, Product.type AS type_pc FROM Product WHERE type = 'PC') AS pc \
			 LEFT JOIN (SELECT DISTINCT Product.maker AS maker_la, Product.type AS type_la FROM Product WHERE type = 'Laptop') AS la \
			 ON pc.maker_pc = la.maker_la \
			 UNION ALL \
    	     	     	 SELECT * FROM (SELECT DISTINCT Product.maker AS maker_pc, Product.type AS type_pc FROM Product WHERE type = 'PC') AS pc \
			 RIGHT JOIN (SELECT DISTINCT Product.maker AS maker_la, Product.type AS type_la FROM Product WHERE type = 'Laptop') AS la \
			 ON pc.maker_pc = la.maker_la \
			 WHERE pc.maker_pc IS NULL) AS thetable \
			 WHERE thetable.maker_la IS NULL;"
}
function exercise_00801 {
    mysql -u root -p -e "USE computer; \
    	     	     	 SELECT type FROM Product \
			 WHERE type = 'Laptop';
    	     	         SELECT DISTINCT maker, type \
			 FROM Product \
			 WHERE type IN ('PC') \
			 AND maker IN \
			 (SELECT maker FROM Product \
			 WHERE maker = 'A' OR maker = 'B' OR maker = 'C' OR maker = 'E'); \
    	     	         SELECT DISTINCT maker, type \
			 FROM Product \
			 WHERE type IN ('PC') \
			 AND maker NOT IN \
			 (SELECT maker FROM Product \
			 WHERE type = 'Laptop');"
}

#Exercise: 9 (Serge I: 2002-11-02)
#Find the makers of PCs with a processor speed of 450 MHz or more. Result set: maker. 
function exercise_009 {
    mysql -u root -p -e "USE computer; \
			 SELECT DISTINCT Prod.maker FROM (SELECT * FROM Product WHERE type = 'PC') AS Prod LEFT JOIN (PC) \
		         ON (Prod.model = PC.model) \
			 WHERE PC.speed >= 450 "
}
function exercise_00901 {
    mysql -u root -p -e "USE computer; \
			 SELECT DISTINCT Product.maker FROM Product LEFT JOIN (PC) \
		         ON (Product.model = PC.model) \
			 WHERE PC.speed >= 450 "
}

#Exercise: 10 (Serge I: 2002-09-23)
#Find the printer models having the highest price. Result set: model, price.
function exercise_010 {
    mysql -u root -p -e "USE computer; \
    	     	         SELECT model, price FROM Printer \
			 WHERE price >= (SELECT MAX(price) FROM Printer)"
}
function exercise_01001 {
    mysql -u root -p -e "USE computer; \
    	     	         SELECT model, price FROM Printer \
			 ORDER BY price DESC;"
}
function exercise_01002 {
    mysql -u root -p -e "USE computer; \
    	     	     	 SELECT MAX(price) FROM Printer;"
}

#Exercise: 11 (Serge I: 2002-11-02)
#Find out the average speed of PCs.
function exercise_011 {
    mysql -u root -p -e "USE computer; \
    	     	         SELECT AVG(speed) FROM PC;"
}

#Exercise: 12 (Serge I: 2002-11-02)
#Find out the average speed of the laptops priced over $1000.
function exercise_012 {
    mysql -u root -p -e "USE computer; \
    	     	         SELECT AVG(Lap.speed) FROM (SELECT speed FROM Laptop WHERE price > 1000) AS Lap;"
}

#Exercise: 13 (Serge I: 2002-11-02)
#Find out the average speed of the PCs produced by maker A.
function exercise_013 {
    mysql -u root -p -e "USE computer; \
    	     	         SELECT AVG(tmp.speed) FROM (SELECT PC.speed FROM PC JOIN Product \
			 ON PC.model=Product.model 
			 WHERE maker = 'A') as tmp;"
}

#Exercise: 14 (Serge I: 2002-11-05)
#For the ships in the Ships table that have at least 10 guns, get the class, name, and country.
function exercise_014 {
    mysql -u root -p -e "USE ships; \
                         SELECT Ships.class, Ships.name, Classes.country FROM Ships JOIN Classes \
			 ON Ships.class = Classes.class \
			 WHERE Classes.numGuns>=10;"
}

#Exercise: 15 (Serge I: 2003-02-03)
#Get hard drive capacities that are identical for two or more PCs.
#Result set: hd.
function exercise_015 {
    mysql -u root -p -e "USE computer; \
    	     	     	 SELECT tmp.hd FROM (SELECT hd, COUNT(hd) AS hd_count \
    	     	         FROM PC \
			 GROUP BY hd) AS tmp \
			 WHERE tmp.hd_count >= 2;"
}
#Exercise: 15 (Serge I: 2003-02-03)
#Get hard drive capacities that are identical for two or more PCs.
#Result set: hd.
function exercise_01501 {
    mysql -u root -p -e "USE computer; \
    	     	     	 SELECT hd, COUNT(hd) AS hd_count FROM PC GROUP BY hd;"
}

#Exercise: 16 (Serge I: 2003-02-03)
#Get pairs of PC models with identical speeds and the same RAM capacity. Each resulting pair should be displayed only once, i.e. (i, j) but not (j, i).
#Result set: model with the bigger number, model with the smaller number, speed, and RAM. 
function exercise_016 {
    mysql -u root -p -e "USE computer; \
    	     	     	 SELECT DISTINCT pc1.model, pc2.model, pc1.speed, pc1.ram FROM \
			 (SELECT model, speed, ram FROM PC) AS pc1, \
			 (SELECT model, speed, ram FROM PC) AS pc2 \
			 WHERE pc1.speed = pc2.speed AND pc1.ram = pc2.ram AND pc1.model > pc2.model;"
}

#Exercise: 17 (Serge I: 2003-02-03)
#Get the laptop models that have a speed smaller than the speed of any PC.
#Result set: type, model, speed.
function exercise_017 {
    mysql -u root -p -e "USE computer; \
    	     	     	 SELECT DISTINCT Product.type, Laptop.model, Laptop.speed FROM Laptop JOIN Product \
			 WHERE Product.type='Laptop' AND Laptop.speed < (SELECT MIN(speed) FROM PC);"
}

#Exercise: 18 (Serge I: 2003-02-03)
#Find the makers of the cheapest color printers.
#Result set: maker, price.
function exercise_018 {
    mysql -u root -p -e "USE computer; \
    	     	     	 SELECT Product.maker, Printer.price FROM Printer JOIN Product \
			 ON Printer.model = Product.model \
			 WHERE Printer.color='y' AND Printer.price <= (SELECT MIN(price) FROM Printer WHERE color='y');"
}

#Exercise: 19 (Serge I: 2003-02-13)
#For each maker having models in the Laptop table, find out the average screen size of the laptops he produces.
#Result set: maker, average screen size.
function exercise_019 {
    mysql -u root -p -e "USE computer; \
    	     	     	 SELECT tmp.maker AS Maker, AVG(tmp.screen) AS Avg_screen FROM \
			 (SELECT Product.maker AS maker, Laptop.screen AS screen FROM Laptop JOIN Product \
			 ON Laptop.model = Product.model) AS tmp \
			 GROUP BY tmp.maker;"
}

#Exercise: 20 (Serge I: 2003-02-13)
#Find the makers producing at least three distinct models of PCs.
#Result set: maker, number of PC models.
function exercise_020 {
    mysql -u root -p -e "USE compute; \
    	     	     	 SELECT maker, COUNT(model) AS Count_model FROM Product \
			 WHERE type='PC' \
			 GROUP BY maker \
			 HAVING COUNT(model)>=3"
}

#Exercise: 21 (Serge I: 2003-02-13)
#Find out the maximum PC price for each maker having models in the PC table. Result set: maker, maximum price.
#function exercise_021 {
#asAS    mysql -u root -p -e "USE computer; \
#    ASAA	     	     	 SELECT Product.maker AS maker, COUNT(model) AS Count_model FROM PC JOIN Product ON PC.model = Product.model;"
#}

#Exercise: 22 (Serge I: 2003-02-13)
#For each value of PC speed that exceeds 600 MHz, find out the average price of PCs with identical speeds.
#Result set: speed, average price. 

#Exercise: 23 (Serge I: 2003-02-14)
#Get the makers producing both PCs having a speed of 750 MHz or higher and laptops with a speed of 750 MHz or higher.
#Result set: maker

#Exercise: 24 (Serge I: 2003-02-03)
#List the models of any type having the highest price of all products present in the database. 

#Exercise: 25 (Serge I: 2003-02-14)
#Find the printer makers also producing PCs with the lowest RAM capacity and the highest processor speed of all PCs having the lowest RAM capacity.
#Result set: maker.
#SELECT DISTINCT maker FROM Product 
#WHERE type='Printer' AND maker IN (SELECT DISTINCT Product.maker FROM (SELECT model, ram, speed from PC
#WHERE ram<=(SELECT MIN(ram) FROM PC)
#AND
#speed >= (SELECT MAX(tmp.speed) FROM (SELECT speed from PC
#WHERE ram<=(SELECT MIN(ram) FROM PC)) as tmp)) as tmp
#JOIN Product ON tmp.model=Product.model)

#Exercise: 26 (Serge I: 2003-02-14)
#Find out the average price of PCs and laptops produced by maker A.
#Result set: one overall average price for all items.

#Exercise: 27 (Serge I: 2003-02-03)
#Find out the average hard disk drive capacity of PCs produced by makers who also manufacture printers.
#Result set: maker, average HDD capacity.

#Exercise: 28 (Serge I: 2012-05-04)
#Using Product table, find out the number of makers who produce only one model. 

#Exercise: 29 (Serge I: 2003-02-14)
#Under the assumption that receipts of money (inc) and payouts (out) are registered not more than once a day for each collection point
#[i.e. the primary key consists of (point, date)], write a query displaying cash flow data (point, date, income, expense).
#Use Income_o and Outcome_o tables.
function exercise_029 {
    #mysql -u root -p -e "USE inc; \
    #	     	         SELECT * FROM Income_o JOIN Outcome_o \
    #		         ON Income_o.point = Outcome_o.point AND Income_o.date = Outcome_o.date;"
    #mysql -u root -p -e "USE inc; \
    # 	     	         SELECT * FROM Income_o; \
    #			 SELECT * FROM Outcome_o; \
    #	     	     	 SELECT Income_o.point, Income_o.date AS date_inc, Income_o.inc, Outcome_o.out \
    #		         FROM Income_o JOIN Outcome_o \
    #			 ON Income_o.point = Outcome_o.point;"
    #mysql -u root -p -e "USE inc; \
    #	     	         SELECT DISTINCT * FROM Outcome_o JOIN (SELECT Income_o.point, Income_o.date AS date_inc, Income_o.inc, Outcome_o.out \
    #		         FROM Income_o JOIN Outcome_o \
    #			 ON Income_o.point = Outcome_o.point) AS tmp \
    #			 ON Outcome_o.date = tmp.date_inc;"
    #mysql -u root -p -e "USE inc; \
    #	     	     	 SELECT Income_o.point, Income_o.date AS date_inc, Income_o.inc, Outcome_o.out \
    #		         FROM Income_o JOIN Outcome_o \
    #			 ON Income_o.point = Outcome_o.point;"
    #mysql -u root -p -e "USE inc; \
    # 	     	     	 SELECT * \
    #		         FROM Income_o JOIN Outcome_o \
    #			 ON Income_o.date = Outcome_o.date;"
    #mysql -u root -p -e "USE inc; \
    # 	     	         SELECT * FROM Income_o; \
    # 			 SELECT * FROM Outcome_o;"
    #echo "UNION"
    #mysql -u root -p -e "USE inc; \
    # 	     	         SELECT point, date FROM Income_o \
    #			 UNION
    #			 SELECT point, date FROM Outcome_o;" | nl
    #echo "Income_o"
    #mysql -u root -p -e "USE inc; \
    # 	     	         SELECT * FROM Income_o;" | nl
    #echo "Outcome_o"
    #mysql -u root -p -e "USE inc; \
    # 			 SELECT * FROM Outcome_o;" | nl
    #mysql -u root -p -e "USE inc; \
    #	     	     	 SELECT point, date FROM Outcome_o \
    #			 UNION \
    #			 SELECT point, date FROM Income_o;" | nl
    #mysql -u root -p -e "USE inc; \
    #	                 SELECT pd.point AS point, pd.date AS date, \
    #			 Income_o.point AS point_inc, Income_o.inc FROM \
    #                    (SELECT point, date FROM Outcome_o UNION \
    #			 SELECT point, date FROM Income_o) AS pd \
    #			 LEFT JOIN Income_o \
    #			 ON (pd.date = Income_o.date)" | nl
    #mysql -u root -p -e "USE inc; \
    #	                 SELECT pd.point AS point, pd.date AS date, \
    #			 Income_o.point AS point_inc, Income_o.inc FROM \
    #                    (SELECT point, date FROM Outcome_o UNION \
    #   		 SELECT point, date FROM Income_o) AS pd \
    #			 LEFT JOIN Income_o \
    #			 ON (pd.date = Income_o.date AND pd.point = Income_o.point)" | nl
#SELECT pdi.point AS point, pdi.date AS date, pdi.inc AS inc, Outcome_o.out AS out FROM (SELECT pd.point AS point, pd.date AS date, Income_o.inc FROM (SELECT point, date FROM Outcome_o
UNION
SELECT point, date FROM Income_o) AS pd
LEFT JOIN Income_o
ON (pd.date = Income_o.date AND pd.point = Income_o.point)) AS pdi
LEFT JOIN Outcome_o ON (pdi.date = Outcome_o.date AND pdi.point = Outcome_o.point)

}

function printHelp {
    echo " --> ERROR in input arguments"
    echo " -h  : print help"
    echo " 001 : first exercise "
    echo " XXX : last exercise"
}

MYSQLDBCREATOR='mysql_db_creator'
outlog="out.log"
username="exer_user"
hostname="localhost"
motp=111111

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

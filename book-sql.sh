#!/bin/bash

function book_sql_sh {
    book_sql_appendixes_sh
}

function finalMerge {
    cmd="gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=$book_sql_name $outname_frontpage \
    $outname_appendixes"
    echo $cmd
    $cmd
}

function book_sql_appendixes_sh {
    #appendixes
    outname=$outname_appendixes
    #
    mkdir -p $INFODIR/appendixes
    wkhtmltopdf http://www.sql-tutorial.ru/en/book_appendixes.html $INFODIR/appendixes/book_appendixes.pdf
    wkhtmltopdf http://www.sql-tutorial.ru/en/book_appendix_1_databases.html $INFODIR/appendixes/book_appendix_1_databases.pdf
    wkhtmltopdf http://www.sql-tutorial.ru/en/book_computers_database.html $INFODIR/appendixes/book_computers_database.pdf
    wkhtmltopdf http://www.sql-tutorial.ru/en/book_database_recycled_company.html $INFODIR/appendixes/book_database_recycled_company.pdf
    wkhtmltopdf http://www.sql-tutorial.ru/en/book_database_ships.html $INFODIR/appendixes/book_database_ships.pdf
    wkhtmltopdf	http://www.sql-tutorial.ru/en/book_database_ships/page2.html $INFODIR/appendixes/book_database_ships_page2.pdf
    wkhtmltopdf http://www.sql-tutorial.ru/en/book_airport.html $INFODIR/appendixes/book_airport.pdf
    wkhtmltopdf http://www.sql-tutorial.ru/en/book_painting.html $INFODIR/appendixes/book_painting.pdf
    #
    strip_pdf $INFODIR/appendixes/book_appendixes.pdf 2
    strip_pdf $INFODIR/appendixes/book_appendix_1_databases.pdf 2
    strip_pdf $INFODIR/appendixes/book_computers_database.pdf 2
    strip_pdf $INFODIR/appendixes/book_database_recycled_company.pdf 1
    strip_pdf $INFODIR/appendixes/book_database_ships.pdf 2
    strip_pdf $INFODIR/appendixes/book_database_ships_page2.pdf 2
    strip_pdf $INFODIR/appendixes/book_airport.pdf 2
    strip_pdf $INFODIR/appendixes/book_painting.pdf 2
    #
    cmd="gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=$outname $INFODIR/appendixes/book_appendixes.pdf \
    $INFODIR/appendixes/book_appendix_1_databases.pdf \
    $INFODIR/appendixes/book_computers_database.pdf \
    $INFODIR/appendixes/book_database_recycled_company.pdf \
    $INFODIR/appendixes/book_database_ships.pdf \
    $INFODIR/appendixes/book_database_ships_page2.pdf \
    $INFODIR/appendixes/book_airport.pdf \
    $INFODIR/appendixes/book_painting.pdf"
    echo $cmd
    $cmd
}

function strip_pdf {
    npages=`qpdf --show-npages $1`
    lastPage=`echo $npages - $2 | bc`
    #echo "$npages"
    #echo "$lastPage"
    tmp_pdf="$1_tmp.pdf"
    mv $1 $tmp_pdf
    #echo "$1"
    #echo "$tmp_pdf"
    cmd="gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER -dFirstPage=1 -dLastPage=$lastPage -sOutputFile=$1 $tmp_pdf"
    $cmd
    mv $tmp_pdf ./tmp/.
}

function printHelp {
    echo " --> ERROR in input arguments"
    echo " -h   : print help"
    echo " -d   : default"
    echo " --fm : final merge"
}

INFODIR="book-sql"
book_sql_name="$INFODIR/book-sql.pdf"
outname_frontpage="$INFODIR/frontpage.pdf"
outname_appendixes="$INFODIR/appendixes.pdf"
mkdir -p $INFODIR
mkdir -p tmp

if [ $# -eq 0 ]; then
    printHelp
else
    if [ "$1" = "-h" ]; then
	printHelp
    elif [ "$1" = "-d" ]; then
	#sudo apt-get install wkhtmltopdf
	book_sql_sh
	#elif [ "$1" = "--install" ]; then
	#if [ $# -eq 2 ]; then
	#install_packages_sh $2
	#else
	#printHelp
	#fi
    elif [ "$1" = "--fm" ]; then
	finalMerge
    else
        printHelp
    fi
fi

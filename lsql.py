#!/usr/bin/env python
# lsql.py
#
# Format your sql code 
#

import sys
import getopt
import sqlparse
import shutil


sqlfile = '' 

def format_sql(filename):
    shutil.copy2(filename, filename + '.bak')
    n = open(filename, 'w')
    f = open(filename + '.bak', 'r')
    tobeparsed = f.read()
    n.write(sqlparse.format(tobeparsed, reindent=True, keyword_case='upper'))
    f.close()
    n.close()

def main(argv):
    try:                                
        opts, args = getopt.getopt(argv, "f:", ["file="]) 
        
        for opt, arg in opts:    
            if opt in ("-f", "--file"):
                global sqlfile
                sqlfile = arg

    except getopt.GetoptError, err:           
        print str(err)
        usage()                         
        sys.exit(2)     

def usage():
    print "lsql.py <sql_filename>"

if __name__ == "__main__":
    main(sys.argv[1:])
    format_sql(sqlfile)


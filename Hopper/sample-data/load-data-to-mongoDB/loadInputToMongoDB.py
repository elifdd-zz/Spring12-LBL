
import sys

if (len(sys.argv) < 4):
        print("Usage python loadInputtoMongoDB.py <hostname><dbname><filename>")
else:
	DATABASE_HOST =sys.argv[1]
	DATABASE_NAME =sys.argv[2]
	DATABASE_PORT = 27017

#        for line in open(sys.argv[3],'r'):print(line)
	import pymongo
	from pymongo import Connection
	connection = Connection(DATABASE_HOST, DATABASE_PORT)
	db = connection[DATABASE_NAME]
	incol = db["in"]
	for line in open(sys.argv[3],'r'):
		#print(line)
		incol.insert({ "x": line } )
		
#for line in file("myfile.txt"): collection.insert({ "line": line } )

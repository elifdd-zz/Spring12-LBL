import java.net.UnknownHostException;

import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.DBCursor;
import com.mongodb.Mongo;
import com.mongodb.MongoException;
import java.io.*;

/**
 * Java + MongoDB Hello world Example
 *
 */
public class MongoClient 
{
	public static void main(String[] args) {

		if(args.length <2)
		{
			System.out.println("Missing arguments to put the data to db");
			System.exit(-1);
		}
		String server = args[0];
	    String str = "";
	    BufferedReader inputfile = null;

final long startTime = System.currentTimeMillis(); 

		try {
			// connect to mongoDB, ip and port number
			Mongo mongo = new Mongo(server, 27017);
			//Mongo mongo = new Mongo("localhost", 27017);

			// get database from MongoDB,
			// if database doesn't exists, mongoDB will create it automatically
			DB db = mongo.getDB("test");

			// Get collection from MongoDB, database named "yourDB"
			// if collection doesn't exists, mongoDB will create it automatically
			DBCollection collection = db.getCollection("in");

// while loop into input file, put every line preceded by field line
////

		   
			 inputfile  = new BufferedReader(new FileReader(args[1]));
			 //outputfile = new BufferedWriter(new FileWriter(this_directory+"/"+"outPut_core_"+thread_id,true));

			 while ((str = inputfile.readLine()) != null)
			     {
				 // create a document to store key and value                                                                                                                                         
				 BasicDBObject document1 = new BasicDBObject();
				 document1.put("x", str);
				 collection.insert(document1);

//				 System.out.println(     document1.get("x").toString() );
			     } // end while
			 //fromSource.map(str);
			 inputfile.close();

////

final double duration = (System.currentTimeMillis() - startTime)/1000.0; // after
                System.out.println(" --- Job Finished in " + duration + " seconds");

//			System.out.println("Done");

		} catch (UnknownHostException e) {
			e.printStackTrace();
		} catch (MongoException e) {
			e.printStackTrace();
		}catch (IOException e) {
		    System.out.println("Got an IOException: " + e.getMessage());
		}  



	}
}

MongoDB notes
=============

sleepy.mongoose is an HTTP REST API that allows more connections.
I got it working but I needed to fix a little bug first.
Use my fork:

    git clone git@github.com:dangunter/sleepy.mongoose.git

Then install it, and run simply as:

    httpd

You will need to have mongod bound to port 27017 on localhost.
You can do this on the command line or by editing /etc/mongod.conf

To use from Python, install the mongate package.

    pip install mongate

Then the code goes like this, where 'host' is the mongodb host
and 'port' is the mongodb port (e.g. 27017)

     import mongate
     from mongate import connection
     conn = connection.Connection(host, 27080)
     conn.connect_to_mongo("mongodb://localhost", port)

After that, you should be able to use 'conn' just like a connection
in the pymongo package

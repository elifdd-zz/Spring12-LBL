#!/bin/bash 

#PBS -l mppwidth=24
#PBS -q debug
#PBS -V
#PBS -j oe
#PBS -l walltime=00:01:30
#PBS -N java-load-data
#PBS -A m1104 
#PBS -S /bin/bash

#ARGUMENTS:

export outputdir="/scratch/scratchdirs/edede/MyHadoop/hadoop-data/output/ZachsBenchMarkData/censusdata/genderfilter"
export inputdir="/scratch/scratchdirs/edede/MyHadoop/hadoop-data/input/ZachsBenchMarkData/censusdata/censusdata.sample"
export TESTNAME="Putting data"
export DBPATH="test"
export numNodes="1"
export datasize=""
#export PYTHONPATH="/global/homes/e/edede/local/lib/python2.7/site-packages"
echo "=== data_size : "$datasize
echo "=== db_path : "$DBPATH
echo "=== test_name : "$TESTNAME
echo "=== input_dir : "$inputdir
echo "=== output_dir : "$outputdir
echo "=== input_size" : `ls -al $inputdir`


export MONGODB_HOST=`head -n 1 $PBS_NODEFILE`
echo "===  Mongo server	:	"$MONGODB_HOST

echo "Starting MongoDB Server"
/global/homes/e/edede/Hopper/hadoop-moduled/./mongo-server.start $DBPATH
echo "--------------------------------------------"
sleep 2

echo "Loading modules..."
module use --append /usr/common/tig/Modules/modulefiles
module load hadoop
#module load python

echo "--------------------------------------------"
echo "Putting data to mongo"
cd $PBS_O_WORKDIR
cd mongo-java
time java -classpath ":mongo-2.7.2.jar" MongoClient $MONGODB_HOST $inputdir
#python loadInputToMongoDB.py $MONGODB_HOST $DBPATH $inputdir

sleep 2

echo "--------------------------------------------"
echo "Checking input data of mongo"
/global/homes/e/edede/Hopper/hadoop-moduled/mongodb-linux-x86_64-1.8.1/bin/./mongo --host $MONGODB_HOST $DBPATH /global/homes/e/edede/Hopper/hadoop-moduled/mongodb-linux-x86_64-1.8.1/bin/input-datacheck.js
echo "--------------------------------------------"
#sleep 2

echo "========================== MONGO LOAD JOB ENDS =============================="


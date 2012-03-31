#!/bin/bash 

#PBS -l mppwidth=120
#PBS -q debug
#PBS -V
#PBS -j oe
#PBS -l walltime=00:03:30
#PBS -N labellingWgR-local
#PBS -A m1104 
#PBS -S /bin/bash

#ARGUMENTS:

export outputdir="/scratch/scratchdirs/edede/MyHadoop/hadoop-data/output/ZachsBenchMarkData/censusdata/labellingWgR"
export inputdir="/scratch/scratchdirs/edede/MyHadoop/hadoop-data/input/ZachsBenchMarkData/censusdata/censusdata.sample"
export TESTNAME="Local fs labelling filter on census data"
export DBPATH="test"
export numNodes="5"
export mapsPerNode="18"
export totalmaps="90"  ##do the multiplication

echo "=== db_path : "$DBPATH
echo "=== number of nodes: "$numNodes
echo "=== maps per node : "$mapsPerNode
echo "=== test_name : "$TESTNAME
echo "=== input_dir : "$inputdir
echo "=== output_dir : "$outputdir
echo "=== total_num_maps" : $totalmap
echo "=== input_size" : `ls -al $inputdir`

echo "--------------------------------------------"
echo "Loading hadoop modules..."
module use --append /usr/common/tig/Modules/modulefiles
module load hadoop

echo "Cleanup Previous Hadoop..."
#./cleanup_hadoop_elif
cleanup_hadoop
sleep 5

echo "Starting Hadoop..."
rm exportpath
#./start_hadoop_elif > exportpath
start_hadoop > exportpath
export hh=`cat exportpath`

echo "--------------------------------------------"
export path=`echo $hh | sed -e "s/.*IR=//;s/Starting.*//"`
echo " hadoop_conf_dir :"$path
export HADOOP_CONF_DIR=$path

sleep 2

echo "hadoop_conf_dir :"$HADOOP_CONF_DIR

cd $PBS_O_WORKDIR

#make
#sleep 2

echo "--------------------------------------------"
echo "Clean Hadoop output directory"
rm -r $outputdir
#mkdir $outputdir

echo "--------------------------------------------"
echo "Running Hadoop"
hadoop jar HadoopLabellingWgR.jar HadoopLabellingWgR $totalmaps $inputdir $outputdir

#input/censusdata.sample output
#hadoop jar /global/homes/e/edede/Hopper/hadoop-moduled/mongo-hadoop/lib/WordCountExample.jar com.mongodb.hadoop.examples.wordcount.WordCount $MONGODB_HOST $DBPATH 
#>output.$PBS_JOBID

echo "--------------------------------------------"
echo "Cleaning Hadoop..."
#./cleanup_hadoop_elif
cleanup_hadoop

echo "========================== HADOOP ON LOCAL ON FS JOB ENDS =============================="


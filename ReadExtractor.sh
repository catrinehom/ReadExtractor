#!/usr/bin/env bash

#Program: ReadsExtractor
#Description: This program can find ID corresponding to reads from a input references in your MinION data.
#Version: 1.0
#Author: Catrine Ahrens Høm

#Usage:
    ## ReadsExtractor.sh [-i] <MinION reads in fastq format> [-r] <Reference(s) of wanted contigs in fasta format>
    ## -i, fastq path
    ## -r, reference path
    ## ID.txt will be available in the working directory after run.

#This pipeline consists of 5 steps:
    ## STEP 1:  Unicycler (Skipped if assembly file is supplied)
    ## STEP 2:  Find the contigs which match references
    ## STEP 3:  Choose these contigs in fasta format
    ## STEP 4:  Align fastq reads against contigs
    ## STEP 5:  Find IDs for aligned fastq reads


###########################################################################
# GET INPUT
###########################################################################
# load an enviroment (to be deleted in final pipeline)
source activate unicycler_v0.4.7_no_stall

# Start timer for logfile
SECONDS=0
echo "Time stamp: $SECONDS seconds."
echo "Time stamp: $SECONDS seconds." >> ${o}/${o}.log

# How to use program
usage() { echo "Usage: $0 [-i <fastq filename>] [-r <references filename>] [-o <outputname>] [-g <optional Unicycler assembly.gfa>] [-f <optional Unicycler assembly.fasta>]" 1>&2; exit 1; }

# Default values
t=8
c='True'
l=500000

# Parse flags
while getopts ":i:r:o:h" opt; do
    case "${opt}" in
        i)
            i=${OPTARG}
            ;;
        r)
            r=${OPTARG}
            ;;
        o)
            o=${OPTARG}
            ;;
        h)
            usage
            ;;
        *)
            echo "Invalid option: ${OPTARG}"
            usage
            ;;
    esac
done
shift $((OPTIND-1))

# Check if required flags are empty
if [ -z "${i}" ] || [ -z "${r}" ] || [ -z "${o}" ]; then
    echo "i, r and o are required flags"
    usage
fi


# Make output directory
[ -d $o ] && echo "Output directory: ${o} already exists. Files will be overwritten." || mkdir $o

# Make logfile and empty it
touch ${o}/${o}.log
cat /dev/null > ${o}/${o}.log

date=$(date '+%Y-%m-%d %H:%M:%S')
echo "Starting ReadExtractor ($date)"
echo "Starting ReadExtractor ($date)" >> ${o}/${o}.log
echo "-----------------------------------------------"
echo "-----------------------------------------------" >> ${o}/${o}.log
echo "ReadExtractor is a pipeline to find read ID's from reads from Nanopore MinION sequencing matching input references."
echo "ReadExtractor is a pipeline to find read ID's from reads from Nanopore MinION sequencing matching input references." >> ${o}/${o}.log
echo ""
echo "" >> ${o}/${o}.log

# Check format and that the files exists
./ErrorHandling.py -i $i -r $r -o $o

# Check if python script exited with an error
if [ $? -eq 0 ]
then
  echo "Error handling of input done."
  echo "Error handling of input done." >> ${o}/${o}.log
else
  # Redirect stdout from echo command to stderr.
  echo "Script exited due to input error."
  echo "Script exited due to input error." >> ${o}/${o}.log
  exit 1
fi

# Print files used
echo "Input used is ${i}"
echo "References used is ${r}"
echo "Input used is ${i}" >> ${o}/${o}.log
echo "References used is ${r}" >> ${o}/${o}.log

echo "Time stamp: $SECONDS seconds."
echo "Time stamp: $SECONDS seconds." >> ${o}/${o}.log
echo ""
echo "" >> ${o}/${o}.log

###########################################################################
# STEP 4:  KMA READS AGAINST CONTIGS
###########################################################################

echo "Starting STEP 4: KMA reads against contigs."
echo "Starting STEP 4: KMA reads against contigs." >> ${o}/${o}.log

#Command used to index plasmid database:
kma index -i $r -o $o/databases/reads_database

#Command to run KMA:
kma -i $i -o $o/reads_alignment -t_db $o/databases/reads_database -mrs 0.1 -bcNano -mp 20 -mem_mode

echo "Time stamp: $SECONDS seconds."
echo "Time stamp: $SECONDS seconds." >> ${o}/${o}.log
echo ""
echo "" >> ${o}/${o}.log

###########################################################################
# STEP 5:  FIND IDs
###########################################################################

echo "Starting STEP 5: Find IDs"
echo "Starting STEP 5: Find IDs" >> ${o}/${o}.log

./IDFinder.py -i $o/reads_alignment.frag.gz -o $o

# Check if python script exited with an error
if [ $? -eq 0 ]
then
  echo "IDs found! ${o}_ID.txt is saved in ${o} directory."
  echo "IDs found! ${o}_ID.txt is saved in ${o} directory." >> ${o}/${o}.log
else
  echo "No IDs found!"
  echo "No IDs found!" >> ${o}/${o}.log
fi

echo "Time stamp: $SECONDS seconds."
echo "Time stamp: $SECONDS seconds." >> ${o}/${o}.log

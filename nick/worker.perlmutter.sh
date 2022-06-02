#!/bin/bash -l
#SBATCH -N 1
#SBATCH -C cpu
#SBATCH -q regular
#SBATCH -A m4170
#SBATCH -t 02:45:00
#SBATCH --job-name=clas12_clara
#SBATCH --exclusive

#SBATCH -e logs/clara_%j.err
#SBATCH -o logs/clara_%j.out

# Envs to easily change run number and threading
export RUN_NUM=006302
export NUM_THREADS=256

# Make a working dir in scratch for processing and cd into it
export WORKING_DIR=${SCRATCH}/clas12/recon/testing/${RUN_NUM}
mkdir -p $WORKING_DIR
rm -rf ${WORKING_DIR}/*
cd ${WORKING_DIR}

# copy in some files to working dir
cp /global/homes/t/tylern/clas12/clara.sh .
cp /global/homes/t/tylern/clas12/data-ai.yaml .

# Put a link to the files to process in woring dir
ln -s ${SCRATCH}/clas12/recon/staging/${RUN_NUM}/clas_${RUN_NUM}.evio.00000-00004.hipo .

# Set envs for clara
export CLARA_HOME=/cvmfs/oasis.opensciencegrid.org/jlab/hallb/clas12/soft/linux-64/clara/5.0.2_8.0.0
export JAVA_TOOL_OPTIONS="-XX:+UnlockExperimentalVMOptions -XX:+EnableJVMCI -XX:+UseJVMCICompiler"
export CCDB_CONNECTION=sqlite:////cvmfs/oasis.opensciencegrid.org/jlab/hallb/clas12/soft/noarch/data/ccdb/ccdb_latest.sqlite
export RCDB_CONNECTION=mysql://rcdb@clasdb.jlab.org/rcdb
# Print the env
env

# Start clara
./clara.sh -p nersc_${NUM_THREADS}_ -t ${NUM_THREADS} -y data-ai.yaml $RUN_NUM

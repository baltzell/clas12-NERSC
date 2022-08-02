#!/bin/bash
#SBATCH -N 1
#SBATCH -C cpu
#SBATCH -q regular
#SBATCH -A nstaff
#SBATCH -t 12:00:00
#SBATCH --job-name=clas12_clara
#SBATCH -n 1
#SBATCH -c 256
#SBATCH --mail-type=ALL

#SBATCH -e slurm_logs/clara_shared_%j.err
#SBATCH -o slurm_logs/clara_shared_%j.out

/global/cfs/projectdirs/m3792/tylern/local/bin/pagurus \
--move \
--path $SCRATCH/clas12-nersc/performance \
--outfile clas12_$(hostname)_$SLURM_JOB_ID.csv &


# Envs to easily change run number and threading
export RUN_NUM=006302
export NUM_THREADS=256

# Make a working dir in scratch for processing and cd into it
export WORKING_DIR=${SCRATCH}/clas12/recon/stress_testing/${RUN_NUM}
mkdir -p $WORKING_DIR
rm -rf ${WORKING_DIR}/*
cd ${WORKING_DIR}

# copy in some files to working dir
cp $SLURM_SUBMIT_DIR/data-ai-multicore.yaml .
cp $SLURM_SUBMIT_DIR/env.sh .
cp $SLURM_SUBMIT_DIR/logging.properties .
cp $SLURM_SUBMIT_DIR/multicore-test-bind .

# Put a link to the files to process in woring dir
ln -s ${SCRATCH}/clas12/recon/staging/${RUN_NUM}/clas_${RUN_NUM}.evio.00005-00009.hipo .

source ./env.sh
# Print the env
# env
export SLURM_CPU_BIND=verbose


# Start clara
# srun --cpu-bind=rank_ldom --cpus-per-task=32
# srun -n 1 -c 32 --cpu_bind=rank_ldom
$CLARA_HOME/bin/j_dpe &

sleep 10

rm -rf /pscratch/sd/t/tylern/clas12/recon/test.hipo;

# srun -n 1 -c 256 --cpu_bind=rank_ldom --overlap
./multicore-test-bind -e 2000 -s 2 -t $NUM_THREADS ./data-ai-multicore.yaml ./clas_006302.evio.00005-00009.hipo /pscratch/sd/t/tylern/clas12/recon/test.hipo

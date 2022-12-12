#!/bin/bash
#SBATCH --time=02:00:00                  # Job run time (hh:mm:ss)
#SBATCH --nodes=1                        # Number of nodes
#SBATCH --ntasks-per-node=1              # Number of task (cores/ppn) per node
#SBATCH --job-name=magus_job             # Name of batch job
#SBATCH --partition=secondary            # Partition (queue)
#SBATCH --output=multi-serial.o%j        # Name of batch job output file

infile=data/amino_acid/BBA0039.tfa
numsubsets=24

echo $infile
echo $numsubsets

cd ${SLURM_SUBMIT_DIR}

module load python/3
python3 -m pip install -U dendropy

start=`date +%s`
$(python3 MAGUS/magus.py -i $infile -o result_baseline.txt --maxnumsubsets $numsubsets)
end=`date +%s`

runtime=$((end-start))
echo "MAGUS Runtime: $runtime seconds"

./clean.sh
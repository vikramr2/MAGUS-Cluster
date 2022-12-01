#!/bin/bash
#SBATCH --time=00:30:00                  # Job run time (hh:mm:ss)
#SBATCH --nodes=1                        # Number of nodes
#SBATCH --ntasks-per-node=16             # Number of task (cores/ppn) per node
#SBATCH --job-name=matlab_job            # Name of batch job
#SBATCH --partition=secondary            # Partition (queue)
#SBATCH --output=multi-serial.o%j        # Name of batch job output file

start=`date +%s`

infile=magus_decompose/unaligned_sequences.txt
numsubsets=25

echo $infile
echo $numsubsets

cd ${SLURM_SUBMIT_DIR}

module load python/3
python3 -m pip install -U dendropy

$(python3 magus_decompose/magus.py -i $infile -o result.txt -t random --maxnumsubsets $numsubsets)

mkdir tmp
cd mafft

for (( i=1; i<=$numsubsets; i++))
do
    ./mafft --localpair --maxiterate 100 --ep 0.123 --quiet --anysymbol ../magus_working_dir/decomposition/subset_$i.txt > ../tmp/$i.txt &
done
wait

cd ..

python3 MAGUS/magus.py -s tmp/ -o magus_result.txt

./clean.sh

end=`date +%s`
runtime=$((end-start))

echo "MAGUS-Cluster Runtime: $runtime seconds"
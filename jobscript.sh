#!/bin/bash
#SBATCH --time=02:00:00                  # Job run time (hh:mm:ss)
#SBATCH --nodes=2                        # Number of nodes
#SBATCH --ntasks-per-node=20             # Number of task (cores/ppn) per node
#SBATCH --job-name=magus_job             # Name of batch job
#SBATCH --partition=secondary            # Partition (queue)
#SBATCH --output=multi-serial.o%j        # Name of batch job output file

infile=data/amino_acid/BBA0081.tfa
numsubsets=24

echo $infile
echo $numsubsets

cd ${SLURM_SUBMIT_DIR}

module load python/3
python3 -m pip install -U dendropy

start=`date +%s`
$(python3 magus_decompose/magus.py -i $infile -o result.txt --maxnumsubsets $numsubsets)

mkdir tmp
cd mafft

mafft_start=`date +%s` 
for (( i=1; i<=$numsubsets; i++))
do
    ./mafft --localpair --maxiterate 1000 --ep 0.123 --quiet --thread 28 --anysymbol ../magus_working_dir/decomposition/subset_$i.txt > ../tmp/$i.txt &
done
wait
mafft_end=`date +%s`

cd ../tmp
find . -maxdepth 1 -type f -empty -print -delete

cd ..

python3 MAGUS/magus.py -s tmp/ -o magus_result_20core.txt
end=`date +%s`


./clean.sh

runtime=$((end-start))
mafftruntime=$((mafft_end-mafft_start))

echo "MAGUS-Cluster Runtime: $runtime seconds"
echo "Batch MAFFT Runtime: $mafftruntime seconds"
for (( i=$2*($1-1)+1; i<=$2*$1; i++))
do
    ./mafft --localpair --maxiterate 1000 --ep 0.123 --quiet --thread 28 --anysymbol ../magus_working_dir/decomposition/subset_$i.txt > ../tmp/$i.txt &
done
wait
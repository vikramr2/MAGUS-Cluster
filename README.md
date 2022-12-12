# MAGUS-Cluster
Parallelized multiple sequence alignment using MAGUS (Vladmir Smirnov, Tandy Warnow, 2021) on a compute cluster.
## How to use this program
- Clone this repository on a compute cluster.
- Modify the `--nodes` and `--tasks-per-node` in the `jobscript.sh` file to adjust the number of nodes and the number of cores per node used to run MAGUS
- Run via `sbatch jobscript.sh`
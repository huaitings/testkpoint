#!/bin/sh
#sed_anchor01
#SBATCH --job-name=25
#SBATCH --output=AlMoNbTaTiZr1000k100kbar.out
##SBATCH --nodes=6
#~ ##SBATCH --ntasks-per-node=12 
#SBATCH --partition=16Cores
##SBATCH --nodelist=node09

export LD_LIBRARY_PATH=/opt/mpich-3.3.2/lib:/opt/intel/mkl/lib/intel64:$LD_LIBRARY_PATH
export PATH=/opt/mpich-3.3.2/bin:$PATH
#sed_anchor02
mpiexec /opt/QEGCC/bin/pw.x -in AlMoNbTaTiZr1000k100kbar.in
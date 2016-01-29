#!/bin/bash
#SBATCH -J mpi-phyml
#SBATCH -o output_%j.txt
#SBATCH -e errors_%j.txt
#SBATCH -n 20
#SBATCH --mem-per-cpu=5000
#SBATCH -p longrun
#SBATCH --mail-type=ALL
#SBATCH --mail-user=ggithinji@kemri-wellcome.org

# The MIT License
# Copyright (c) 2016 George Githinji

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

## Author: George Githinji
## Email: ggithinji[at]kemri-wellcome.org

## This program runs the parallel version of phyml using  openmpi
## NOTE: The number of bootstrap replicates must be a multiple of the number of CPUs required in the mpirun command.
set -e 

#Dependencies
# 1. PhyML (compiled with openmpi)
# 2. openmpi

#read the parameters from the command lines    
USAGE="Usage: $0 -i input_file -b boostraps -d datatype -m model_name"

# A commandline with getopts
# TODO 
    #Support all phyml options and set defaults 
while getopts i:b:d:m:h options
do
   case "$options" in
        i) INPUTFILE="$OPTARG";;
        b) BOOTSTRAPS="$OPTARG";;
        d) DATATYPE="$OPTARG";;
        m) MODELNAME="$OPTARG";;
        h) echo $USAGE
              exit 1;;
    esac
done

# ensure that the input file and parameters are provided before running the script
if [[ $INPUTFILE == "" || $DATATYPE == "" || $MODELNAME == "" || $BOOTSTRAPS == "" ]]; then
    echo $USAGE
    exit 0
fi

#load the phyml
module purge
module load openmpi
module load phyml/3.2.0

#run phyml 
mpirun -np 20 phyml-mpi --input "$INPUTFILE" --datatype "$DATATYPE" --bootstrap "$BOOTSTRAPS" --pinv e --model "$MODELNAME" --no_memory_check  

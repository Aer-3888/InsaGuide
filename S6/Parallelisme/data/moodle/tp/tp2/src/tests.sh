#!/bin/bash
#

for i in {1..8}
do
	export OMP_NUM_THREADS=$i
	bin/exo$1 
done

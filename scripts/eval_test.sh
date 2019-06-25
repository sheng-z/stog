#!/bin/bash

smatch_dir=$1
cp $2 ${smatch_dir}
cp $3 ${smatch_dir}
cd ${smatch_dir}
gold=$(basename $2)
pred=$(basename $3)
out=`python2 smatch/smatch.py --pr -f "$gold" "$pred"`
out=($out)
rm $gold $pred
echo ${out[1]} ${out[3]} ${out[6]} | sed 's/.$//'


#!/usr/bin/env bash

# Directory where intermediate utils will be saved to speed up processing.
util_dir=data/AMR/amr_1.0_utils

# AMR data with **features**
test_data=$1

# ========== Set the above variables correctly ==========

printf "Frame lookup...`date`\n"
python -u -m stog.data.dataset_readers.amr_parsing.postprocess.node_restore \
    --amr_files ${test_data} \
    --util_dir ${util_dir} || exit
printf "Done.`date`\n\n"

printf "Expanding nodes...`date`\n"
python -u -m stog.data.dataset_readers.amr_parsing.postprocess.expander \
    --amr_files ${test_data}.frame \
    --util_dir ${util_dir} || exit
printf "Done.`date`\n\n"

mv ${test_data}.frame.expand ${test_data}
rm ${test_data}.frame*

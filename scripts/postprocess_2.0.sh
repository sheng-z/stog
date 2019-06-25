#!/usr/bin/env bash

set -e

# Directory where intermediate utils will be saved to speed up processing.
util_dir=data/AMR/amr_2.0_utils

# AMR data with **features**
data_dir=data/AMR/amr_2.0
test_data=$1

# ========== Set the above variables correctly ==========

printf "Frame lookup...`date`\n"
python -u -m stog.data.dataset_readers.amr_parsing.postprocess.node_restore \
    --amr_files ${test_data} \
    --util_dir ${util_dir}
printf "Done.`date`\n\n"

printf "Wikification...`date`\n"
python -u -m stog.data.dataset_readers.amr_parsing.postprocess.wikification \
    --amr_files ${test_data}.frame \
    --util_dir ${util_dir}
printf "Done.`date`\n\n"

printf "Expanding nodes...`date`\n"
python -u -m stog.data.dataset_readers.amr_parsing.postprocess.expander \
    --amr_files ${test_data}.frame.wiki \
    --util_dir ${util_dir}
printf "Done.`date`\n\n"

mv ${test_data}.frame.wiki.expand ${test_data}
rm ${test_data}.frame*

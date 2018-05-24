# CellSegmentation

This project contains the functions used for cell segmentation. In general, functions are quite general (smoothing, morphological transformations, analysis of binary masks and local thresholds). Some of them are *optimized* for specific ways in which the data was gathered or was going to be analyzed. 

## DAPI_segmentation

This functions are tunned for DAPI in blue channel (discards everything else). 
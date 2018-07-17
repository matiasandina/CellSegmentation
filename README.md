# CellSegmentation

This project contains the functions used for cell segmentation. In general, functions are quite general (smoothing, morphological transformations, analysis of binary masks and local thresholds). Some of them are *optimized* for specific ways in which the data was gathered or was going to be analyzed. They normally need `bfmatlab` on path to work.

Because this method relies heavily on thresholding and binary image operations, a good SNR is vital.  

This folder also contains useful functions: 

* Match sets of XY coordinate points. Check the `hungarianlinker.m` function and `align_manual_automatic_counts.m` for a practical example. 
* Median filter with plotting options (`my_medfilt2.m`)
* A very rudimentary function to split RGB channels (`split_RGB.m`)

## Channel segment

The function `channel_segment.m` implements a general pipeline for segmentation of an image in one channel.


## DAPI_segmentation

These functions are tunned for DAPI in blue channel (discards everything else). 
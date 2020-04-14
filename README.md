# Photometry Pipeline

This pipeline was developed to process, analyze, and visualize data acquired during fiber photometry experiments. This pipeline includes the following processing / analysis:

* Fiber Photometry
** Filtering
** Downsampling
** Demodulation
** Deconvolution *In Progress*


## Dependencies:

The pipeline was written using MATLAB2018a

The Tritsch Lab Toolbox available at: https://github.com/TritschLab/TLab_Toolbox

Please download the toolbox and add it to your path.

## Installation:

Download the repository and add it to your MATLAB path

## Steps:

1. Convert h5 files

      From the TLab Toolbox, run **convertH5** to convert h5 files from wavesurfer into the format required for analysis

       >> convertH5

2. Edit Parameters
      
      Open the processParams file and adjust the parameters accordingly

       >> edit processParams

      Save the file with a new name

3. Process Data

      Select the desired parameter file for the experiment

       >> processData
    
4. Analyze Data

       >> analyzeData

5. Visual Data

       >> plotData

## Author:

Name: Pratik Mistry
Email: pratik.mistry@nyulangone.org



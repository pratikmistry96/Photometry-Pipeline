# Photometry Pipeline

This pipeline was developed to process, analyze, and visualize 

## Dependencies:

The pipeline was written using MATLAB2018a

The Tritsch Lab Toolbox available at: https://github.com/TritschLab/TLab_Toolbox

Please download the toolbox and add it to your path.

## Installation:

Download the repository and add it to your MATLAB path

## How to Use:

### Step 1: Convert Files

From the TLab Toolbox, run **convertH5** to convert h5 files from wavesurfer into the format required for analysis

      >> convertH5

### Step 2: Set Parameters

Open the processParams file and adjust the parameters accordingly

      >> edit processParams

Save the file with a new filename

### Step 3: Process Data

Run the processData function

      >> processData
    
### Step 4: Analyze Data

Run the analyzeData function

      >> analyzeData

### Step 5: Visualize Data

Run the plotData function

      >> plotData


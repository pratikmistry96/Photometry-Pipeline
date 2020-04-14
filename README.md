# Photometry Pipeline

A pipeline to process data acquired during fiber photometry experiments
Dependencies: Tritsch Lab ToolBox 

## Dependencies:

The pipeline was written using MATLAB2018a

The Tritsch Lab Toolbox available at: https://github.com/TritschLab/TLab_Toolbox

Please download the toolbox and add it to your path.

## Installation:

Download the 

## How to Use:

### Step 1: Convert Files

From the TLab Toolbox, run **convertH5** to convert h5 files from wavesurfer into the format required for analysis

    >> convertH5

### Step 2: Set Parameters

Open the processParams file



Description: This pipeline was created by Pratik Mistry to process, analyze, and visualize Photometry data and any other behavioral data gathered. These analyzes performed in this pipeline require the data structure that is outputted from the "convertH5" function found in the Tritsch Lab ToolBox Repo.




function [data] = processDual(data,params)
%Process Dual Color Photometry
%
%   [data] = processDual(data,params)
%
%   Description: This function is designed to process dual-color or dual-fiber
%   photometry experiments. These experiments require demodulation, and
%   this code will find the acquired reference frequency and use that for
%   demodulation.
%
%   Input:
%   - data - A data structure specific to the Tritsch Lab. Created using
%   the convertH5_FP script
%   - params - A structure created from a variant of the processParams
%   script
%
%   Output:
%   - data - Updated data structure containing processed data
%
%   Author: Pratik Mistry 2019

%Pull parameters required for this analysis
nAcq = length(data.acq);
%Filter Properties
lpCut = params.FP.lpCut; filtOrder = params.FP.filtOrder;
%General downsampling parameter
dsRate = params.dsRate;
dsType = params.dsType;
%Baselining parameters
interpType = params.FP.interpType;
fitType = params.FP.fitType; winSize = params.FP.winSize;
winOv = params.FP.winOv;
basePrc = params.FP.basePrc;
%Demodulation-specific property
sigEdge = params.FP.sigEdge;

rawFs = data.gen.acqFs;
Fs = rawFs/dsRate;
data.gen.Fs = Fs;

%This outer for-loop goes performs the analysis on each sweep acquired
%during the experiment
for x = 1:nAcq
    Ls = length(data.acq(x).time); %Get length of data in samples
    L = 1:Ls;
    nFP = length(data.acq(x).FP); %Obtain number of FP channels (Includes red control)
    FPnames = data.acq(x).FPnames; %Pull names of the FP channels
    data.final(x).FPnames = FPnames;
    data.final(x).nFPchan = nFP;
    refSig = data.acq(x).refSig; %Pull reference signals
    %The following line initializes the cell array for the final photometry
    %data
    data.final(x).FP = cell(nFP,1); data.final(x).nbFP = cell(nFP,1); data.final(x).FPbaseline = cell(nFP,1);
    %The following for loop will go through all photometry traces and ask
    %for the modulation frequency required for demodulation
    for y = 1:nFP
        rawFP = data.acq(x).FP{y,1}; %Extract FP trace
        modFreq = inputdlg(['Enter Modulation Frequency for: ',FPnames{y}]); %Ask for modulation frequency
        modFreq = str2double(modFreq{1}); %Convert string input to a double
        ref = findRef(modFreq,refSig,rawFs); %Find the reference signal from the refsig array using modulation frequency
        demod = digitalLIA(rawFP,ref,modFreq,rawFs,lpCut,filtOrder); %Peform the demodulation
        if sigEdge ~= 0 %Remove the beginning and the edge if the setting isn't 0
            demod = demod((sigEdge*rawFs)+1:end-(sigEdge*rawFs));
        end
        demod = downsampleTLab(demod,dsRate,dsType); %Downsample the data
        data.final(x).nbFP{y} = demod; %Store the demodulated signal in the non-baseline data
        [FP,baseline] = baselineFP(demod,interpType,fitType,basePrc,winSize,winOv,Fs); %Baseline Photometry
        data.final(x).FP{y} = FP;
        data.final(x).FPbaseline{y} = baseline;
    end
    %Create the time vector based on the new length of the photometry
    %signal and store new photometry signal
    if sigEdge ~= 0
        L = L((sigEdge*rawFs)+1:end-(sigEdge*rawFs));
        Ls = length(L);
    end
    Ls = length(1:dsRate:Ls); timeVec = [1:Ls]/Fs;
    data.final(x).time = timeVec';
end
end

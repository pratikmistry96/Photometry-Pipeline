function [data] = processIso(data,params)
%Process Dual Color Photometry
%
%   [data] = processDual(data,params)
%
%   Description: This function is designed to process photometry
%   experiments with an isosbestic control. The code takes the photometry
%   channel and asks the user for the modulation frequencies of the
%   excitation 470 and the isosbestic control 405
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
    Ls = length(data.acq(x).time);
    L = 1:Ls;
    nFP = length(data.acq(x).FP);
    FPnames = data.acq(x).FPnames;
    data.final(x).FPnames = FPnames;
    data.fina(x).nFPchan = nFP;
    refSig = data.acq(x).refSig;
    data.final(x).FP = cell(nFP,1); data.final(x).nbFP = cell(nFP,1); data.final(x).FPbaseline = cell(nFP,1);
    %The for loop will go through all FP traces assuming all of them were
    %recorded using an isosbestic control. The user will need to input the
    %modulation frequencies for excitation and isosbestic
    for y = 1:nFP
        rawFP = data.acq(x).FP{y,1};
        modFreq = inputdlg({['Enter Isosbestic Mod Freq for: ',FPnames{y}],['Enter Excitation Mod Freq for: ',FPnames{y}]});
        isoFreq = str2double(modFreq{1}); excFreq = str2double(modFreq{2});
        isoRef = findRef(isoFreq,refSig,rawFs); excRef = findRef(excFreq,refSig,rawFs);
        isoDemod = digitalLIA(rawFP,isoRef,rawFs,lpCut,filtOrder);
        excDemod = digitalLIA(rawFP,excRef,rawFs,lpCut,filtOrder);
        if sigEdge ~= 0
            isoDemod = isoDemod((sigEdge*rawFs)+1:end-(sigEdge*rawFs));
            excDemod = excDemod((sigEdge*rawFs)+1:end-(sigEdge*rawFs));
        end
        excDemod = downsampleTLab(excDemod,dsRate,dsType); isoDemod = downsampleTLab(isoDemod,dsRate,dsType);
        data.final(x).nbFP{y} = excDemod;
        data.final(x).iso{y} = isoDemod;
        %This code will also ask the user if they will want to use the
        %isosbestic signal to baseline the signal using linear regression
        baseOption = menu('Do you want to use the Isosbestic for Baselining?','Yes','No');
        if baseOption == 1 || baseOption == 0
            [FP,baseline] = linregFP(isoDemod,excDemod,basePrc);
        elseif baseOption == 2
            [FP,baseline] = baselineFP(excDemod,interpType,fitType,basePrc,winSize,winOv,Fs);
        end
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

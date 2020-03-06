function data = processOnsetOffset(data,params)
%Process Onset and Offset Data
%
%   data = processOnsetOffset(data,params)
%
%   Description: This function takes a data structure with velocity traces,
%   onset and offset indicies, and fiber photometry data and aligns
%   photometry to movement onset and offset. This code was organized using
%   functions and lines of code already created by Jeffrey March
%
%   Input:
%   - data - A data structure specific to the Tritsch Lab. Created using
%   the convertH5_FP script that is included in the analysis package
%   - params - A structure created from a variant of the processParams
%   script
%
%   Output:
%   - data - Updated data structure containing final data
%
%   Author: Pratik Mistry, 2019
%
nAcq = length(data.acq);
iterSTD = params.mov.iterSTD;
iterWin = params.mov.iterWin;
velThres = params.mov.velThres;
finalOnset = params.mov.finalOnset;
Fs = data.gen.Fs;
for n = 1:nAcq
    timeThres = params.mov.timeThres * Fs; %Get time threshold in samples
    vel = data.final(n).vel; vel = abs(vel); %Get absolute value of velocity
    minRest = params.mov.minRestTime * Fs; minRun = params.mov.minRunTime * Fs;
    [onSetsInd,offSetsInd] = getOnsetOffset(abs(vel),velThres,minRest,minRun,finalOnset);
    %onSetsInd = data.final(n).mov.onsets; offSetsInd = data.final(n).mov.offsets;
    %Adjust onset and offset according to time threshold
    [onSetsInd,offSetsInd] = adjOnsetOffset(onSetsInd,offSetsInd,timeThres,vel);
    %The following two lines will find proper onset and offset
    %thresholds by using a percent of the std from a window
    onsetThres = getIterThres(vel,onSetsInd,iterWin,Fs,iterSTD,0);
    offsetThres = getIterThres(vel,offSetsInd,iterWin,Fs,iterSTD,1);
    %The following line adjusts the onsets and offsets to a new min
    onSetsInd = iterToMin(vel,onSetsInd,onsetThres,1); offSetsInd = iterToMin(vel,offSetsInd,offsetThres,0);
    [onSetsInd,offSetsInd] = adjOnsetOffset(onSetsInd,offSetsInd,timeThres,vel);
    data.final(n).mov.onsets = onSetsInd; data.final(n).mov.offsets = offSetsInd;
    data.final(n).mov.numBouts = length(onSetsInd);
    data.final(n).mov.avgBoutDuration = mean(offSetsInd - onSetsInd)/Fs;
    data.final(n).mov.stdBoutDuration = std(offSetsInd - onSetsInd)/Fs;
end
end


function thresVec = getIterThres(vel,indVec,winSize,Fs,nStd,flag)
thresVec = zeros(size(indVec));
if flag == 0
    for n = 1:length(indVec)
        ind = indVec(n)-(winSize*Fs);
        if ind<1; ind = 1; end
        thresVec(n) = nStd*std(vel(ind:indVec(n)));
    end
else
    for n = 1:length(indVec)
        ind = indVec(n)+(winSize*Fs);
        if ind<length(vel); ind = length(vel); end
        thresVec(n) = nStd*std(vel(indVec(n):ind));
    end
end
end

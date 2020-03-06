function data = processRestOnsetOffset(data,params)
%Process Rest Onset and Offset Data
%
%   data = processRestOnsetOffset(data,params)
%
%   Description: This function takes a data structure with velocity traces,
%   onset and offset indicies, and fiber photometry data and aligns
%   photometry to rest onset and offset. This code was organized using
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
velThres = params.mov.velThres_rest;
nAcq = length(data.acq);
Fs = data.gen.Fs;

for n = 1:nAcq
    vel = data.final(n).vel; vel = abs(vel);
    minRestTime = params.mov.minRestTime_rest*Fs;
    timeThres = params.mov.timeThres_rest *Fs;
    timeShift = params.mov.timeShift_rest*Fs;
    minRunTime = params.mov.minRunTime_rest * Fs;
    [onsetInd,offsetInd] = getOnsetOffset(-vel,-velThres,minRunTime,minRestTime,1);
    [onsetInd,offsetInd] = adjOnsetOffset(onsetInd,offsetInd,timeThres,vel);
    onsetInd = onsetInd+timeShift; offsetInd = offsetInd-timeShift;
    data.final(n).mov.onsetsRest = onsetInd;
    data.final(n).mov.offsetsRest = offsetInd;
end
end


function data = processMov(data,params)
%Process Behavior
%
%   [data] = processMov(data,params)
%
%   Description: This function is designed to convert rotary encoder information into velocity
%   traces and quickly find onsets. The parameters for the analysis are found in the params
%   structure, which is created from a user-created scripted based on the
%   processParam.m file.
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

%Pull parameters from the params structure
circum = 2*pi*params.mov.radius; velThres = params.mov.velThres;
winSize = params.mov.winSize;
finalOnset = params.mov.finalOnset;
nAcq = length(data.acq);
sigEdge = params.FP.sigEdge;
dsRate = params.dsRate;
dsType = params.dsType;
rawFs = data.gen.acqFs;
Fs = rawFs/dsRate;
data.gen.Fs = Fs;
%The following for-loop will run the behavior analysis on each sweep in the
%acquisition
for n = 1:nAcq
    wheel = data.acq(n).wheel;
    if sigEdge ~= 0
        wheel = wheel((sigEdge*rawFs)+1:end-(sigEdge*rawFs));
    end
    wheel = unwrapBeh(wheel);
    if size(wheel,1) == 1
        wheel = wheel';
    end
%    lpFilt = designfilt('lowpassiir','SampleRate',rawFs,'FilterOrder',10,'HalfPowerFrequency',10);
%    wheel = filtfilt(lpFilt,wheel);
%   Filtering the raw encoder data caused damping effects at high frequency
%   transitions that affect data processing
    wheel = downsampleTLab(wheel,dsRate,dsType);
    wheel = wheel*circum;
    data.final(n).wheel = wheel;
    vel = getVel(wheel,Fs,winSize);
        data.final(n).vel = vel;
    L = length(wheel);
    timeVec = [1:L]/Fs;
    data.final(n).time = timeVec';
    %{
    if isfield(data.final(n),'time')
        if isempty(data.final(n).time)
            timeVec = [1:L]/Fs;
            data.final(n).time = timeVec';
        end
    else
        timeVec = [1:L]/Fs;
        data.final(n).time = timeVec';
    end
    %}
    try
        minRest = params.mov.minRestTime * Fs; minRun = params.mov.minRunTime * Fs;
        [onsets,offsets] = getOnsetOffset(abs(vel),velThres,minRest,minRun,finalOnset);
        data.final(n).mov.onsets = onsets;
        data.final(n).mov.offsets = offsets;
    end
end

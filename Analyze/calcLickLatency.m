function data = calcLickLatency(data)
%calcLickLatency - Calculate lick latency
%
%   Usage:
%       data = calcLickLatency(data)
%
%   Description: This function find the first lick onset after the reward
%   delivery and calculates the latency / delivery from the delivery of a
%   reward to consumption
%   
%   Input:
%       data - Data structure containing reward information and lick
%       information
%
%   Output:
%       data - Updated data structure containing lick latencies from all
%       trials
%
%   Author: Pratik Mistry, 2020
%
if isfield(data,'final')
    nSweeps = size(data.final,2);
    Fs = data.gen.Fs;
    for n = 1:nSweeps
        rewOffset = data.final(n).rew.offset;
        lickOnset = data.final(n).lick.onset;
        if ~isempty(lickOnset)
            logVec = lickOnset>rewOffset;
            lickOnset = lickOnset(logVec);
            data.rew.lickLat(n) = (lickOnset(1) - rewOffset)/Fs;
        else
            data.rew.lickLat(n) = 0;
        end
    end
    data.rew.avglickLat = mean(data.rew.lickLat);
else
    fprintf('Data not analyzed to find event times!\n');
    return
end
end
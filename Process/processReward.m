function data = processReward(data,params)
%Process Reward Delivery
%
%   Usage:
%       data = processReward(data,params);
%
%   Description:
%       This function will pull onset and offset times from reward
%       experiments
%
%   Input:
%       data - TLab data structure
%       params - A structure created from a script that contains parameters
%       for analysis
%
%   Output:
%       data - Updated data structure
%
%   Author: Pratik Mistry, 2020


nAcq = length(data.acq);
dsRate = params.dsRate;
rawFs = data.gen.acqFs;
Fs = rawFs/dsRate;
data.gen.Fs = Fs;
for n = 1:nAcq
    L = size(data.acq(n).time,1);
    L = length(1:dsRate:L);
    lick = data.acq(n).lick.trace;
    lick = lick(1:dsRate:end);
    data.final(n).lick.trace = lick;
    [data.final(n).lick.onset,~] = getPulseOnsetOffset(lick,0.5);
    rewDelivery = data.acq(n).rew.trace;
    rewDelivery = rewDelivery(1:dsRate:end);
    data.final(n).rew.trace = rewDelivery;
    [~,data.final(n).rew.offset] = getPulseOnsetOffset(rewDelivery,0.5);
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
end
end
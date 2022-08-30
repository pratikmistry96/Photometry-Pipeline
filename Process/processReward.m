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
sigEdge = params.FP.sigEdge;
for n = 1:nAcq
    if isfield(data.acq(n),'lick')
        if length(data.acq(n).lick) > 1
            choice = menu('Choose lick signal to process:',data.acq(n).lickNames); % Select signal to extract
        else; choice = 1;
        end
        lick = data.acq(n).lick{choice}; % Extract raw lick trace from data structure for processing
        if sigEdge ~= 0 % Remove the beginning and the edge if the setting isn't 0
            lick = lick((sigEdge*rawFs)+1:end-(sigEdge*rawFs));
        end
        data.final(n).lick.trace = lick(1:dsRate:end); % Downsample lick trace to match Fs of photometry signal
        data.final(n).lick.onset = getPulseOnsetOffset(lick, 0.5)'/dsRate; % Extract lick onset times from raw lick signal/dsRate
    end
    if isfield(data.acq(n),'rew')
        if length(data.acq(n).rew) > 1
            choice = menu('Choose reward signal to process (includes cue, solenoid):',data.acq(n).rewNames); % Select signal to extract
        else; choice = 1;
        end
        rewDelivery = data.acq(n).rew{choice}; % Extract raw cue/reward trace from data structure for processing
        if sigEdge ~= 0 % Remove the beginning and the edge if the setting isn't 0
            rewDelivery = rewDelivery((sigEdge*rawFs)+1:end-(sigEdge*rawFs));
        end
        data.final(n).rew.trace = rewDelivery(1:dsRate:end); % Downsample reward trace to match Fs of photometry signal
        [onset, offset] = getPulseOnsetOffset(rewDelivery, 0.5); % Extract cue and reward onset times from raw signal
        onset = onset/dsRate; offset = offset/dsRate; % Adjust trace rise and falls for Fs
        data.final(n).rew.onset = onset(:);
        % data.final(n).rew.cue = onset( offset-onset > mean(offset-onset) ); % Long pulses are cue signal
        % data.final(n).rew.onset = onset( offset-onset < mean(offset-onset) ); % Short pulses are reward delivery signal
        if ~isfield(data.final(n),'time')
            timeVec = [1/Fs : 1/Fs : (length(rewDelivery)/dsRate/Fs)]'; % Generate time vector using length of signal, Fs of downsampled signal
            data.final(n).time = timeVec; % Load time vector into data structure
            try data.final.lick.trace = data.final.lick.trace(1:length(data.final.time)); end
            try data.final.rew.trace = data.final.rew.trace(1:length(data.final.time)); end
        end
    end
end
end

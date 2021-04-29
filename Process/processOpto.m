function [data] = processOpto (data, params)
%Created By: Anya Krok
%Created On: 18 June 2019
%Description: T-Lab specific code for processing optogenetic stimulation
%signal into general T-Lab data structure
%Updated On: 31 October 2019 - added new filter+downsampling
%Updated On: 29 April 2021 - added sigEdge
%
% [data] = processOpto (data, params)
%
% INPUT
%   'data'    - T-Lab data file with data.acq.Fs and data.acq.opto
%   'params'  - T-Lab optogenetic stimulation parameters
%
% OUTPUT
%   'data'  - data structure containing new data.opto sub-structure
%

%% Parameters, extracted from params
thres = params.opto.threshold;      % threshold for pulse onset/offset
cutoff = params.opto.cutoff;        % filter cutoff freq
order = params.opto.order;          % filter order
filtType = params.opto.filtType;    % filter type
rawFs = params.acqFs;               % acquistion sampling rate
dsRate = params.dsRate;             % downsampling rate
dsType = params.dsType;

%% Process opto signal
for n = 1:length(data.acq)
    data.final(n).opto = struct; % Initialize structure
    signal = data.acq(n).opto; % Extract signal from data structure
    
    if sigEdge ~= 0 % Remove signal from beginning and end
        signal = signal((sigEdge*rawFs)+1:end-(sigEdge*rawFs));
    end
    
    [pulseOnset, pulseOffset] = getPulseOnsetOffset (signal, thres); % Onset and offset times for opto pulses
    
    optoNew = filterFP(signal,rawFs,cutoff,order,filtType); % Filter before downsampling
    optoNew = downsample_TLab(optoNew,dsRate,dsType); % Downsample signal to match data.gen.Fs
    
    %vestigial code to extract only first and last stimuli of pulse train
    %if isfield(params.opto,'stimtype')
    %    switch params.opto.stimtype
    %        case 'excitation'
    %            %excitatory optostim protocol: 5Hz, 5sec = 25 pulses per pattern repeat
    %            pulseOnset = pulseOnset(:,1:25:end) + 1; %extract every 25th value starting from 1st
    %            pulseOffset = pulseOffset(:,25:25:end); %extract every 25th value starting from 25th
    %    end
    %end

    data.final(n).opto.on  = pulseOnset/dsRate;  % Pulse onset in samples, matching data.gen.Fs
    data.final(n).opto.off = pulseOffset/dsRate; % Pulse offset in samples, matching data.gen.Fs
    data.final(n).opto.trace = optoNew;          % Downsampled pulse vector 
end      

end

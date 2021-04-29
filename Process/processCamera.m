function [data] = processCamera (data, params)
%Created By: Anya Krok
%Created On: 29 April 2021
%Description: T-Lab specific code for processing camera trigger
%signal into general T-Lab data structure
%
% [data] = processCamera (data, params)
%
% INPUT
%   'data'    - T-Lab data file with data.acq.Fs and data.acq.cam
%   'params'  - T-Lab parameters
%
% OUTPUT
%   'data'  - data structure containing new data.cam sub-structure
%

%% Parameters, from params
    thres = 0.5;            % Threshold for camera trigger times, set to 0.5 because digital input is binary
    dsRate = params.dsRate; % Downsampling rate
    sigEdge = params.FP.sigEdge; % Time in seconds of data to be removed from beginning and end of signal
    rawFs = params.acqFs;   % Acquisition sampling rate

%%
    for n = 1:length(data.acq)
        data.final(n).cam = struct; % Initialize structure
        signal = data.acq(n).cam; % Extract signal from data structure
        if sigEdge ~= 0
            signal = signal((sigEdge*rawFs)+1:end-(sigEdge*rawFs));
        end
        camOn = getPulseOnsetOffset (signal, thres); % Extract camera trigger times from original signal 
        camOn_adjFs = round(camOn/dsRate); % Adjust times to match data.gen.Fs of final data
        data.final(n).cam.on = camOn_adjFs; % Save into data structure
    end      
end

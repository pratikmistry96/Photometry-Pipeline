function data = processCC(data,params)
%Process Cross-Correlations
%
%   [data] = processCC(data,params)
%
%   Description: This function is designed to process the cross correlation between fiber photometry 
%   traces and velocity data. The parameters for the analysis are found in the params
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

nAcq = length(data.final);
ccType = params.cc.type;
lagVal = params.cc.lag;
Fs = data.gen.Fs;
for x = 1:nAcq
    if isfield(data.final(x),'FP') || isfield(data.final(x),'vel')
        nFP = length(data.final(x).FP);
        vel = data.final(x).vel;
        for y = 1:nFP
            FP = data.final(x).FP{y};
            if ccType == 1
                [data.final(x).cc{y},ccLag] = xcorr(FP,vel,lagVal*Fs,'coeff');
            elseif ccType == 2
                [data.final(x).cc{y},ccLag] = xcov(FP,vel,lagVal*Fs,'coeff');
            else
                errordlg('Not a value correlation options');
            end
        end
        data.final(x).ccLag = ccLag/Fs;
    else
        errordlg('Cannot perform cross-correlation');
    end 
end
end
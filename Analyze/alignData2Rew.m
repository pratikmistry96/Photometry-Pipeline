function data = alignData2Rew(data,tBefore,tAfter)
%alignData2Rew - Align photometry and velocity data to reward delivery
%
%   Usage:
%       data = alignData2Rew(data,tBefore,tAfter)
%
%   Description: This function aligns data to the delivery of a reward
%   within a specified window.
%
%   NOTE: If you perform the reward delivery experiments in the same manner
%   as Pratik and Zander, then this function will work for you. Otherwise,
%   you will need to create new code to align the data.
%
%   Input:
%       data - Lab specific data structure
%       tBefore - Amount of time before the event time to capture
%       tAfter - Amount of time after the event time to capture
%
%   Output:
%       data - Adjusted data structure with new data
%
%   Author: Pratik Mistry, 2020
%   Updated: Anya Krok, June 2021. Code now works for output from
%   processReward and accounts for multi-sweep recordings.
%
if isfield(data,'final')
    Fs = data.gen.Fs;
    if tBefore > 0
        tBefore = tBefore*-1;
    end
    tBefore = tBefore * Fs; tAfter = tAfter * Fs;
    nSamp = length(tBefore:tAfter);
    data.rew.time = [tBefore:tAfter]'/Fs;
    if isfield(data.final,'rew')
        nSweeps = size(data.final,2);
        for n = 1:nSweeps
            tmpVel = data.final(n).vel;
            totSamp = length(tmpVel);
            rewTime = data.final(n).rew.delivery;
            % rewTime = adjEvtTimes(rewTime,tBefore,tAfter,totSamp);
            data.rew.events{n} = rewTime; % Save event times signal is aligned to into new rew structure
            data.rew.vel{n} = alignTrace2Event(tmpVel,rewTime,tBefore,tAfter,nSamp); % Velocity signal aligned to reward delivery event times
            nFP = data.final(n).nFPchan;
            for m = 1:nFP
                tmpFP = data.final(n).FP{m};
                data.rew.FP{m,n} = alignTrace2Event(tmpFP,rewTime,tBefore,tAfter,nSamp);
            end
%             if isfield(data.final,'lick')
%                 lickOnset = data.final(n).lick.onset;
%                 if ~isempty(lickOnset)
%                     lickLogVec = lickOnset > (rewTime + tBefore) & lickOnset < (rewTime + tAfter);
%                     lickOnset = lickOnset(lickLogVec);
%                     data.rew.lickRew{n} = lickOnset;
%                 else
%                     data.rew.lickRew{n} = [];
%                 end
%             end
        end
        FPcell = data.rew.FP;
        nFP = length(FPcell);
        for m = 1:nFP
            tmpFP = FPcell{m,n};
            data.rew.avgFP{m,n} = mean(tmpFP,2);
        end
        data.rew.avgVel{n} = mean(data.rew.vel{n},2);
    else
        fprintf('No Analyzed Reward Data Found');
    end
else
    fprintf('No Analyzed Data');
    return;
end
end

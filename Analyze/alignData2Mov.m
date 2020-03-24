function data = alignData2Mov(data,tBefore,tAfter)
%alignData2Mov - Align photometry and velocity data to movement onset and
%offset
%
%   Usage:
%       data = alignData2Mov(data,tBefore,tAfter)
%
%   Description: This function aligns data to movement bouts
%   within a specified window.
%
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
%
if isfield(data,'final')
    Fs = data.gen.Fs;
    if tBefore > 0
        tBefore = tBefore*-1;
    end
    tBefore = tBefore * Fs; tAfter = tAfter * Fs;
    nSamp = length(tBefore:tAfter);
    data.mov.time = [tBefore:tAfter]'/Fs;
    if isfield(data.final,'mov')
        nSweeps = size(data.final,2);
        allOnsetVel = [];
        allOffsetVel = [];
        nFP = data.final(1).nFPchan;
        allOnsetFP{nFP} = [];
        allOffsetFP{nFP} = [];
        data.mov.onset.ind = [];
        data.mov.offset.ind = [];
        for n = 1:nSweeps
            tmpVel = data.final(n).vel;
            totSamp = length(tmpVel);
            onSetInd = data.final(n).mov.onsets; onSetInd = adjEvtTimes(onSetInd,tBefore,tAfter,totSamp);
            offSetInd = data.final(n).mov.offsets; offSetInd = adjEvtTimes(offSetInd,tBefore,tAfter,totSamp);
            data.mov.onset.ind = [data.mov.onset.ind;onSetInd]; data.mov.offset.ind = [data.mov.offset.ind;offSetInd];
            velOnsetMat = alignTrace2Event(tmpVel,onSetInd,tBefore,tAfter,nSamp);
            velOffsetMat = alignTrace2Event(tmpVel,offSetInd,tBefore,tAfter,nSamp);
            data.mov.onset.vel{n} = velOnsetMat;
            data.mov.offset.vel{n} = velOffsetMat;
            allOnsetVel = [allOnsetVel,velOnsetMat];
            allOffsetVel = [allOffsetVel,velOffsetMat];
            for m = 1:nFP
                tmpFP = data.final(n).FP{m};
                FPonsetMat = alignTrace2Event(tmpFP,onSetInd,tBefore,tAfter,nSamp);
                FPoffsetMat = alignTrace2Event(tmpFP,offSetInd,tBefore,tAfter,nSamp);
                data.mov.onset.FP{m,n} = FPonsetMat;
                data.mov.offset.FP{m,n} = FPoffsetMat;
                allOnsetFP{m} = [allOnsetFP{m},FPonsetMat];
                allOffsetFP{m} = [allOffsetFP{m},FPoffsetMat];
            end
        end
        data.mov.onset.allVel = allOnsetVel; data.mov.offset.allVel = allOffsetVel;
        data.mov.onset.allFP = allOnsetFP; data.mov.offset.allFP = allOffsetFP;
        for x = 1:nFP
            data.mov.onset.avgFP{x} = mean(allOnsetFP{x},2);
            data.mov.offset.avgFP{x} = mean(allOffsetFP{x},2);
        end
        data.mov.onset.avgVel = mean(allOnsetVel,2);
        data.mov.offset.avgVel = mean(allOffsetVel,2);
    else
        fprintf('No Analyzed Reward Data Found');
    end
else
    fprintf('No Analyzed Data');
    return;
end
end
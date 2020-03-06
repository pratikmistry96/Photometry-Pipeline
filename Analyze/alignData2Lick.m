function data = alignData2Lick(data,tBefore,tAfter)
if isfield(data,'final')
    Fs = data.gen.Fs;
    tBefore = tBefore * Fs; tAfter = tAfter * Fs;
    nSamp = length(tBefore:tAfter);
    data.lick.time = [tBefore:tAfter]'/Fs;
    if isfield(data.final,'lick')
        nSweeps = size(data.final,2);
        for n = 1:nSweeps
            nFP = data.final(n).nFPchan;
            tmpVel = data.final(n).vel;
            totSamp = length(tmpVel);
            allLicks = data.final(n).lick.onset; 
            if ~isempty(allLicks)
                rewTime = data.final(n).rew.offset;
                logVec = allLicks > rewTime; postLick = allLicks(logVec); firstLick = postLick(1);
                if (firstLick+tAfter)>totSamp || (firstLick+tBefore)<1
                    data.lick.vel(:,n) = nan(nSamp,1);
                    for x = 1:nFP
                        data.lick.FP{x}(:,n) = nan(nSamp,1);
                    end
                    data.lick.onset(n) = NaN;
                else
                    data.lick.vel(:,n) = alignTrace2Event(tmpVel,firstLick,tBefore,tAfter,nSamp);
                    for x = 1:nFP
                        tmpFP = data.final(n).FP{x};
                        data.lick.FP{x}(:,n) = alignTrace2Event(tmpFP,firstLick,tBefore,tAfter,nSamp);
                    end
                    data.lick.onset(n) = firstLick;
                end
            else
                data.lick.vel(:,n) = nan(nSamp,1);
                for x = 1:nFP
                    data.lick.FP{x}(:,n) = nan(nSamp,1);
                end
                data.lick.onset(n) = NaN;
            end
        end
        nFP = length(data.lick.FP);
        for x = 1:nFP
            tmpFP = data.lick.FP{x};
            data.lick.avgFP{x} = nanmean(tmpFP,2);
        end
        data.lick.avgVel = nanmean(data.lick.vel,2);
    else
        fprintf('No Analyzed Reward Data Found');
    end
else
    fprintf('No Analyzed Data');
    return;
end
end
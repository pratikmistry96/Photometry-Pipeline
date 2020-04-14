function plotFullSweeps(data,incldVel)
if isfield(data,'final')
    mouseName = data.mouse;
    expDate = data.date;
    nSweeps = size(data.final,2);
    left_color = [0 0.7 0];
    right_color = [0 0 0];
    for n = 1:nSweeps
        allFPnames = data.final(n).FPnames;
        nFP = data.final(n).nFPchan;
        time = data.final(n).time;
        FP = data.final(n).FP;
        end
        for x = 1:nFP
            tmpFP = FP{x}; FPname = allFPnames{x};
            tmpFig = figure; set(tmpFig,'defaultAxesColorOrder',[left_color;right_color]); hold on;
            yyaxis left; plot(time,tmpFP,'-','color',left_color); ylabel(['dF/F','-',FPname]);
            if incldVel == 1
                vel = data.final(n).vel;
                yyaxis right; plot(time,vel,'-','color',right_color); ylabel('Velocity cm/s');
            end
            xlabel('Time(s)'); title([expDate,'-',mouseName,sprintf(' Sweep # %d',n)]);
        end
    end
else
    fprintf('No processed data found\n');
end
end
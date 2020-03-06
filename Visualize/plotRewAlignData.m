function plotRewAlignData(data,choice)
if isfield(data,'rew')
    mouseName = data.mouse;
    expDate = data.date;
    nFP = data.final(1).nFPchan;
    nSweeps = size(data.final,2);
    left_color = [0 0.7 0];
    right_color = [0 0 0];
    time = data.rew.time;
    avgVel = data.rew.avgVel;
    velMat = data.rew.vel;
    for n = 1:nFP
        FPmat = data.rew.FP{n};
        FPname = data.final(1).FPnames{n};
        if choice == 1 || choice == 3
            tmpFig = figure; set(tmpFig,'defaultAxesColorOrder',[left_color;right_color]); hold on;
            for m = 1:nSweeps
                tmpFP = FPmat(:,m); tmpVel = velMat(:,m);
                yyaxis left; plot(time,tmpFP,'-','color',left_color); ylabel(['dF/F','-',FPname]);
                yyaxis right; plot(time,tmpVel,'-','color',right_color); ylabel('Velocity cm/s');
                xlabel('Time(s)');
            end
            title([expDate,'-',mouseName,' Trial Overlap']);
            figure(tmpFig); hold on; onLine = line([0 0],ylim,'color',[0 0 0.7]); hold off;
            legend(onLine,'Reward Delivery');
        end
        if choice == 2 || choice == 3
            avgFP = data.rew.avgFP{n};
            tmpFig = figure; set(tmpFig,'defaultAxesColorOrder',[left_color;right_color]);
            yyaxis left; shadederrbar(time,avgFP,SEM(FPmat,2),left_color); ylabel(['dF/F','-',FPname]);
            yyaxis right; shadederrbar(time,avgVel,SEM(velMat,2),right_color); ylabel('Velocity cm/s');
            xlabel('Time(s)'); title([expDate,'-',mouseName,'- Reward Aligned Avg']);
            figure(tmpFig); hold on; onLine=line([0 0],ylim,'color',[0 0 0.7]); hold off;
            legend(onLine,'Reward Delivery');
        end
    end
else
    fprintf('Data is not aligned to Reward Delivery');
end
end
function plotMovAlignData(data,choice)
if isfield(data,'mov')
    mouseName = data.mouse;
    expDate = data.date;
    nFP = data.final(1).nFPchan;
    nEvents = length(data.mov.onset.ind);
    left_color = [0 0.7 0];
    right_color = [0 0 0];
    time = data.mov.time;
    onsetAvgVel = data.mov.onset.avgVel; offsetAvgVel = data.mov.offset.avgVel;
    onsetVelMat = data.mov.onset.allVel; offsetVelMat = data.mov.offset.allVel; 
    for n = 1:nFP
        onsetFPmat = data.mov.onset.allFP{n}; offsetFPmat = data.mov.offset.allFP{n};
        FPname = data.final(1).FPnames{n};
        if choice == 1 || choice == 3
            tmpFig = figure; set(tmpFig,'defaultAxesColorOrder',[left_color;right_color]); hold on;
            for m = 1:nEvents
                tmpFP = onsetFPmat(:,m); tmpVel = onsetVelMat(:,m);
                yyaxis left; plot(time,tmpFP,'-','color',left_color); ylabel(['dF/F','-',FPname]);
                yyaxis right; plot(time,tmpVel,'-','color',right_color); ylabel('Velocity cm/s');
                xlabel('Time(s)');
            end
            title([expDate,'-',mouseName,' Movement Onset Overlap']);
            figure(tmpFig); hold on; onLine = line([0 0],ylim,'color',[0 0 0.7]); hold off;
            legend(onLine,'Movement Onset');
            tmpFig = figure; set(tmpFig,'defaultAxesColorOrder',[left_color;right_color]); hold on;
            for m = 1:nEvents
                tmpFP = offsetFPmat(:,m); tmpVel = offsetVelMat(:,m);
                yyaxis left; plot(time,tmpFP,'-','color',left_color); ylabel(['dF/F','-',FPname]);
                yyaxis right; plot(time,tmpVel,'-','color',right_color); ylabel('Velocity cm/s');
                xlabel('Time(s)');
            end
            title([expDate,'-',mouseName,' Movement Offset Overlap']);
            figure(tmpFig); hold on; onLine = line([0 0],ylim,'color',[0 0 0.7]); hold off;
            legend(onLine,'Movement Offset');
        end
        if choice == 2 || choice == 3
            onsetAvgFP = data.mov.onset.avgFP{n}; offsetAvgFP = data.mov.offset.avgFP{n};
            
            tmpFig = figure; set(tmpFig,'defaultAxesColorOrder',[left_color;right_color]);
            yyaxis left; shadederrbar(time,onsetAvgFP,SEM(onsetFPmat,2),left_color); ylabel(['dF/F','-',FPname]);
            yyaxis right; shadederrbar(time,onsetAvgVel,SEM(onsetVelMat,2),right_color); ylabel('Velocity cm/s');
            xlabel('Time(s)'); title([expDate,'-',mouseName,'- Mov Onset Avg']);
            figure(tmpFig); hold on; onLine=line([0 0],ylim,'color',[0 0 0.7]); hold off;
            legend(onLine,'Movement Onset');
            
            tmpFig = figure; set(tmpFig,'defaultAxesColorOrder',[left_color;right_color]);
            yyaxis left; shadederrbar(time,offsetAvgFP,SEM(offsetFPmat,2),left_color); ylabel(['dF/F','-',FPname]);
            yyaxis right; shadederrbar(time,offsetAvgVel,SEM(offsetVelMat,2),right_color); ylabel('Velocity cm/s');
            xlabel('Time(s)'); title([expDate,'-',mouseName,'- Mov Offset Avg']);
            figure(tmpFig); hold on; onLine=line([0 0],ylim,'color',[0 0 0.7]); hold off;
            legend(onLine,'Movement Offset');
        end
    end
else
    fprintf('Data is not aligned to Movement Bouts');
end
end
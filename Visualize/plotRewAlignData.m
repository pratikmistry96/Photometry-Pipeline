function plotRewAlignData(data,choice)
%   Author: Pratik Mistry, 2020
%   Updated: Anya Krok, June 2021. Code now works for output from
%   processReward and accounts for multi-sweep recordings. Updated to match
%   updated alignData2Rew
%
if isfield(data,'rew')
    incldVel = menu('Include Velocity in Plot?','Yes','No');
    mouseName = data.mouse;
    expDate = data.date;
    for n = 1:length(data.final)
        nFP = data.final(n).nFPchan;
        nTrials = length(data.rew.events{n});
        left_color = [0 0.7 0];
        right_color = [0 0 0];
        time = data.rew.time;
        avgVel = data.rew.avgVel{n};
        velMat = data.rew.vel{n};
        for m = 1:nFP
            FPmat = data.rew.FP{m,n};
            FPname = data.final(n).FPnames{m};
            if choice == 1 || choice == 3 % Overlapped Trials
                tmpFig = figure; set(tmpFig,'defaultAxesColorOrder',[left_color;right_color]); hold on;
                for a = 1:nTrials
                    tmpFP = FPmat(:,a); tmpVel = velMat(:,a);
                    yyaxis left; plot(time,tmpFP,'-','color',left_color); ylabel([FPname,' (% dF/F)']);
                    switch incldVel; case 1
                        yyaxis right; plot(time,tmpVel,'-','color',right_color); ylabel('Velocity (cm/s)');
                    end
                    xlabel('Time(s)');
                end
                title([expDate,'-',mouseName,'-',FPname,' - Trial Overlap']);
                figure(tmpFig); hold on; onLine = line([0 0],ylim,'color',[0 0 0.7]); hold off;
                legend(onLine,'Reward Delivery');
            end
            if choice == 2 || choice == 3 % Averaged Traces
                avgFP = data.rew.avgFP{m,n};
                tmpFig = figure; set(tmpFig,'defaultAxesColorOrder',[left_color;right_color]);
                yyaxis left; shadederrbar(time,avgFP,SEM(FPmat,2),left_color); ylabel([FPname,' (% dF/F)']);
                switch incldVel; case 1
                    yyaxis right; shadederrbar(time,avgVel,SEM(velMat,2),right_color); ylabel('Velocity (cm/s)');
                end
                xlabel('Time(s)'); title([expDate,'-',mouseName,'-',FPname,' - Reward Aligned Avg']);
                figure(tmpFig); hold on; onLine=line([0 0],ylim,'color',[0 0 0.7]); hold off;
                legend(onLine,'Reward Delivery');
            end
        end
    end
else
    fprintf('Data is not aligned to Reward Delivery');
end
end

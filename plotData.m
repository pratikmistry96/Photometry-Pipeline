%% Plot Data
clear all;
[FPfiles,FPpath] = uigetfile('*.mat','Select FP Files to Analyze','MultiSelect','On');
if isempty(FPfiles)
    fprintf('No Files Selected');
else
    if (~iscell(FPfiles))
        FPfiles = {FPfiles};
    end
    nFiles = length(FPfiles);
    [analysisOpt,ind] = listdlg('PromptString',{'Select Data to Plotw',...
        'For Multiple Methods: Hold Ctrl and Select'},'ListString',{'Photometry',...
        'Movement Aligned Data','Reward Delivery Aligned Data','Lick Aligned Data'});
    if ind == 0
        fprintf('No Plot Type Selected');
    else
        if any(analysisOpt==2) || any(analysisOpt==3) || any(analysisOpt==4)
            plotType = menu('For Event Aligned Plots: Select One','Overlapped Trials',...
                'Averaged Traces','Both');
        end
        for x = 1:nFiles
            load(fullfile(FPpath,FPfiles{x}));
            for y = 1:length(analysisOpt)
                switch analysisOpt(y)
                    case 2
                        plotMovAlignData(data,plotType);
                    case 3
                        plotRewAlignData(data,plotType);
                    case 4
                        plotLickAlignData(data,plotType);
                end
            end
        end
    end
    clear all;
end
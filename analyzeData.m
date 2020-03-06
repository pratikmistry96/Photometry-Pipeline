%% Analyze Data

clear all;
[FPfiles,FPpath] = uigetfile('*.mat','Select FP Files to Analyze','MultiSelect','On');
if isempty(FPfiles)
    fprintf('No Files Selected');
else
    if (~iscell(FPfiles))
        FPfiles = {FPfiles};
    end
    nFiles = length(FPfiles);
    [analysisOpt,ind] = listdlg('PromptString',{'Select All Analyzes to Perform',...
        'For Multiple Methods: Hold Ctrl and Select'},'ListString',{'Align Data to Reward',...
        'Align Data to Movement','Calculate Lick Latency','Align Data to First Lick'});
    if ind == 0
        fprintf('Analysis Aborted');
    else
        for x = 1:nFiles
            load(fullfile(FPpath,FPfiles{x}));
            fprintf(['Analyzing File: ',FPfiles{x},'....\n\n']);
            params = data.gen.params;
            for y = 1:length(analysisOpt)
                switch analysisOpt(y)
                    case 1
                        fprintf('Aligning Data to Reward....\n');
                        try
                            timeBefore = params.rew.timeBefore;
                            timeAfter = params.rew.timeAfter;
                            data = alignData2Rew(data,timeBefore,timeAfter);
                            fprintf('Finished Aligning Data to Reward\n\n');
                        catch
                            fprintf('Error Aligning Data to Reward\n\n');
                        end
                    case 2
                        fprintf('Aligning Data to Movement....\n');
                        try
                            timeBefore = params.mov.timeBefore;
                            timeAfter = params.mov.timeAfter;
                            data = alignData2Mov(data,timeBefore,timeAfter);
                            fprintf('Finished Aligning Data to Movement\n\n');
                        catch
                            fprintf('Error Aligning Data to Movement\n\n');
                        end
                    case 3
                        fprintf('Calculating Lick Latency....\n');
                        try
                            data = calcLickLatency(data);
                            fprintf('Finished Calculating Lick Latency\n\n');
                        catch
                            fprintf('Error Calculating Lick Latency\n\n');
                        end
                    case 4
                        fprintf('Aligning Data to First Lick....\n');
                        try
                            timeBefore = params.lick.timeBefore;
                            timeAfter = params.lick.timeAfter;
                            data = alignData2Lick(data,timeBefore,timeAfter);
                            fprintf('Finished Aligning Data to First Lick\n\n');
                        catch
                            fprintf('Error Aligning Data to First Lick\n\n');
                        end
                end
            end
            save(fullfile(FPpath,FPfiles{x}),'data');
        end
        clear all;
    end
end

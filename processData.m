%% Process Data


clear all;
[FPfiles,FPpath] = uigetfile('*.mat','Select FP Files to Analyze','MultiSelect','On');
if isempty(FPfiles)
    fprintf('No Photometry File Selected!\n');
else
    [paramFile,paramPath] = uigetfile('*.m','Select FP Parameters File');
    if isempty(paramFile)
        fprintf('No Parameter File Selected!\n');
    else
        run(fullfile(paramPath,paramFile));
        if (~iscell(FPfiles))
            FPfiles = {FPfiles};
        end
        nFiles = length(FPfiles);
        [analysisOpt,ind] = listdlg('PromptString',{'Select All Analyzes to Perform',...
            'For Multiple Methods: Hold Ctrl and Select'},'ListString',{'Photometry',...
            'Velocity','Onset/Offset','Cross-Correlations','Optogenetics','Reward Delivery','Camera Trigger'});
        if ind == 0
            msgbox('Analysis Aborted');
        else
            for x = 1:nFiles
                load(fullfile(FPpath,FPfiles{x}));
                fprintf(['Processing File: ',FPfiles{x},'....\n\n']);
                data.gen.params = params;
                for y = 1:length(analysisOpt)
                    choice = analysisOpt(y);
                    switch choice
                        case 1
                            fprintf('Processing Photometry Traces....\n');
                            try
                                modStatus = menu('Are you demodulating a signal?','Yes','No');
                                if modStatus == 1
                                    isoStatus = menu(['Does this experiment: ',FPfiles{y},...
                                        ' contain an Isosbestic Control?'],'Yes','No');
                                    if isoStatus == 1
                                        data = processIso(data,params);
                                    else
                                        data = processDual(data,params);
                                    end
                                elseif modStatus == 2
                                    data = processFP(data,params);
                                else
                                    fprintf('No Valid Photometry Analysis Type Selected\n');
                                end
                                fprintf('Finished Processing Photometry Traces!\n\n');
                            catch
                                fprintf('Error Processing Photometry for file\n\n');
                            end
                        case 2
                            fprintf('Processing Wheel Data....\n');
                            try
                                data = processMov(data,params);
                                fprintf('Finished Processing Wheel Data\n\n');
                            catch
                                fprintf('Error Processing Behavior for file\n\n');
                            end
                        case 3                            
                            try
                                fprintf('Processing Movement Onset and Offset....\n');
                                data = processOnsetOffset(data,params);
                                fprintf('Finished Processing Movment Onset and Offset!\n\n');
                            catch
                                fprintf('Error Processing Onset/Offset for file \n\n');
                            end
                            try
                                fprintf('Processing Rest Onset and Offset....\n');
                                data = processRestOnsetOffset(data,params);
                                fprintf('Finished Processing Rest Onset and Offset\n\n');
                            catch
                                fprintf('Error Processing Rest Onset/Offset for file!\n\n');
                            end
                        case 4
                            try
                                fprintf('Processing Cross Correlation....\n');
                                data = processCC(data,params);
                                fprintf('Finished Processing Cross Correlation!\n\n');
                            catch
                                fprintf('Error Processing Cross Correlation for file\n\n');
                            end
                        case 5
                            try
                                fprintf('Processing Optogenetic Pulses....\n');
                                data = processOpto(data,params);
                                fprintf('Finished Processing Optogenetic Pulses!\n\n');
                            catch
                                fprintf('Error Processing Optogenetic Pulses for file\n\n');
                            end
                        case 6
                            try
                                fprintf('Processing Reward Delivery....\n');
                                data = processReward(data,params);
                                fprintf('Finished Processing Reward Delivery!\n\n');
                            catch
                                fprintf('Error Processing Reward Delivery for file\n\n');
                            end
                        case 7
                            try
                                fprintf('Processing Camera Trigger....\n');
                                data = processCamera(data,params);
                                fprintf('Finished Processing Camera Trigger!\n\n');
                            catch
                                fprintf('Error Processing Camera Trigger for file\n\n');
                            end
                    end
                end
                data.gen = data.gen;
                save(fullfile(FPpath,FPfiles{x}),'data');
            end
            clear all
        end
    end
end

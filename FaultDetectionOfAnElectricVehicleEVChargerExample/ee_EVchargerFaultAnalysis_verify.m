%% Run validate/verify stage for the model

% Copyright 2022 The MathWorks, Inc.

gridVoltOptions = 415; % V, Line-Line rms voltage
% New data set for Load
loadOptions = [9.5 10.5 11.5]; % Ohm, System Load
tStart = 0.2; 
tEnd = 0.45;
testData = ee_EVchargerFaultAnalysis_run(...
    gridVoltOptions,loadOptions,...
    tStart,tEnd).trainingData;
save ee_EVchargerFaultAnalysis_testData.mat testData;

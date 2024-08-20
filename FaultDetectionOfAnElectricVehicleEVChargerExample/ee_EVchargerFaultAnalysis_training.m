%% Generate training data

% Copyright 2022 The MathWorks, Inc.

tStart = 0.2; 
tEnd = 0.45;
trainingData = ee_EVchargerFaultAnalysis_run(...
    gridVoltOptions,loadOptions,...
    tStart,tEnd).trainingData;
save ee_EVchargerFaultAnalysis_trainingData.mat trainingData;

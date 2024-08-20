function [predFault_a,predFault_b,predFault_c] = ee_EVchargerFaultAnalysis_codegenFunc(data) %#codegen
% ClassificationEnsemble
% This function takes sample time series data to predict or identify fault
% in gate drivers for igbts.

% Copyright 2022 The MathWorks, Inc.

    grda = rms(data(:,2));
    grdb = rms(data(:,3));
    grdc = rms(data(:,4));
    sysL = mean(data(:,1));
    sampleData = table(sysL,grda,grdb,grdc,'VariableNames',{'systemLoad','gridTHD_a','gridTHD_b','gridTHD_c'});
    %
    compactMdl = loadLearnerForCoder('ee_EVchargerFaultAnalysis_codegen'); 
    % 
    fault = double(predict(compactMdl,sampleData));
    fault_map=[1 2 3 4 5 6 7;...
               0 0 0 0 1 1 1;...
               0 0 1 1 0 0 1;...
               0 1 0 1 0 1 0];
    idx_fault = min(find(fault_map(1,:)==fault));
    predFault_a = fault_map(2,idx_fault);
    predFault_b = fault_map(3,idx_fault);
    predFault_c = fault_map(4,idx_fault);
end

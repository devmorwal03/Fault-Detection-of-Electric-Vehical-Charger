function trainingData = ee_EVchargerFaultAnalysis_run(gridVoltageOptions,loadResistanceOptions,tStart,tEnd)
    %% Pre-processing
    % Find the fault combinations that need to be run. Store the
    % fault-combination data in 'allPossibleCases'. Exclude cases where 
    % phases a, b, and c, are all faulted.
    
    % Copyright 2022 The MathWorks, Inc.

    allPossibleCases = dec2bin(0:2^6-1)-'0'; % 6 diodes in 6 columns (data)
    [dimX, ~] = size(allPossibleCases);
    rowsRemovedList = zeros(1,dimX);
    count=1;
    for itr = 1:dimX
        igbtFault = allPossibleCases(itr,:);
        valA = igbtFault(1,1)+igbtFault(1,2); % If >0, AH/AL has fault
        valB = igbtFault(1,3)+igbtFault(1,4); % If >0, BH/BL has fault
        valC = igbtFault(1,5)+igbtFault(1,6); % If >0, CH/CL has fault
        if valA>0 && valB>0 && valC>0
            rowsRemovedList(1,count) = itr;
            count = count+1;
        end
    end
    rowsRemoved = nonzeros(rowsRemovedList)';
    allPossibleCases(rowsRemoved,:) = [];
    [numCases, ~] = size(allPossibleCases);

    %% Run cases
    lenGridVal = length(gridVoltageOptions);
    lenLoadVal = length(loadResistanceOptions);
    totalNumCases = lenGridVal*lenLoadVal*numCases;
    disp(['Total number of runs = ',num2str(totalNumCases)]);
    % Define table columns
    gridDCvolt = zeros(totalNumCases,1);
    systemLoad = zeros(totalNumCases,1);
    gridTHD_a = zeros(totalNumCases,1);
    gridTHD_b = zeros(totalNumCases,1);
    gridTHD_c = zeros(totalNumCases,1);
    driverFault = zeros(totalNumCases,1);
    count = 0;
    for grdVal = 1:lenGridVal
        for loadR = 1:lenLoadVal
            systemLoadR = loadResistanceOptions(1,loadR);
            gridVoltage = gridVoltageOptions(1,grdVal);
            for itr = 1:numCases
                gateDriveFault = allPossibleCases(itr,:)'; % Input is column vector
                disp(['** Start Simulation with Fault : ',num2str(gateDriveFault')]);
                sim('ee_EVchargerFaultAnalysis.slx',0.5);
                count = count+1;
                % Store data for creating table (below)
                gridDCvolt(count,1) = gridVoltage;
                systemLoad(count,1) = systemLoadR;
                thd = load('ee_EVchargerFaultAnalysis_data.mat');
                startData = find(thd.THD.Time==tStart);
                endData = find(thd.THD.Time==tEnd);
                gridTHD_a(count,1) = rms(thd.THD.Data(startData:endData,1));
                gridTHD_b(count,1) = rms(thd.THD.Data(startData:endData,2));
                gridTHD_c(count,1) = rms(thd.THD.Data(startData:endData,3));
                tempVal_a = min(1, gateDriveFault(1,1)+gateDriveFault(2,1));
                tempVal_b = min(1, gateDriveFault(3,1)+gateDriveFault(4,1));
                tempVal_c = min(1, gateDriveFault(5,1)+gateDriveFault(6,1));
                % Labels <ABC> : A,B,C can each be 0 or 1
                %                In the 3 digit number:
                %                    A is in the 100th-unit place
                %                    B is in the 10th-unit place
                %                    C is in the units place
                driverFault(count,1) = tempVal_a*100+tempVal_b*10+tempVal_c;
                disp(['Saved results. Completed ',num2str(count),' runs...']);
            end
        end
    end
    trainingData = table(gridDCvolt,systemLoad,gridTHD_a,gridTHD_b,gridTHD_c,driverFault);
end
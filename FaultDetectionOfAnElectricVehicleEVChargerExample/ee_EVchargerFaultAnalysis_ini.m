%% Parameters for the SLX model ee_EVchargerFaultAnalysis

% Copyright 2022 The MathWorks, Inc.

gridFrequency = 50; % Hz 

% Rectifier rating
rectifier.ACVoltagePP = 415; % V % RMS value of Phase- phase voltage
rectifier.ACVoltagePN = rectifier.ACVoltagePP/sqrt(3); % V % RMS value of Phase- phase voltage
rectifier.ACVoltagePeak = rectifier.ACVoltagePN * sqrt(2); % V 
rectifier.DCCurrent = 700; % A
rectifier.DCVoltage = 800; % V

rectifier.SystemFrequency = 50; % Hz
rectifier.SwitchFrequency = 10e3; % Hz

rectifier.minVdcPossible = rectifier.ACVoltagePP*sqrt(2/3)/0.5; % V
rectifier.acCurrent = sqrt(2)*rectifier.DCCurrent*rectifier.DCVoltage/(sqrt(3)*rectifier.ACVoltagePP); % A

rectifier.maxLVal = 0.95*((rectifier.DCVoltage*0.5)-rectifier.ACVoltagePP*sqrt(2/3))/(2*pi*rectifier.SystemFrequency*rectifier.acCurrent); % H
rectifier.maxACcurrent = 100; % A
rectifier.minACcurrent = -100; % A
rectifier.maxACVoltage = 515; % V
rectifier.minACVoltage = -515; % V
rectifier.minDCVoltage = 0.5*rectifier.DCVoltage; % V

rectifier.lineInductance = 0.1e-3; % H
rectifier.lineResistance = 20e-3; % ohm
rectifier.lineT = rectifier.lineInductance/rectifier.lineResistance; % s 
rectifier.OutputCapacitance = 20e-3; % F
rectifier.a = 2; 

rectifier.VoltageSensorG = 1; 
rectifier.VoltageSensorT = 1/(10*rectifier.SwitchFrequency); % s
rectifier.CurrentSensorG = 1; 
rectifier.CurrentSensorT = 1/(10*rectifier.SwitchFrequency); % s
rectifier.G = rectifier.DCVoltage/2; 
rectifier.K = rectifier.ACVoltagePeak/rectifier.DCVoltage; 
rectifier.Td = 1/(2*rectifier.SwitchFrequency); % s
rectifier.Tphi = rectifier.Td + rectifier.CurrentSensorT; % s
rectifier.Tdel = (2*rectifier.Tphi) + rectifier.VoltageSensorT; % s

rectifier.controller.CurrentG = rectifier.lineInductance/...
    (2*rectifier.G*rectifier.CurrentSensorG*rectifier.Tphi); 
rectifier.controller.CurrentT = rectifier.lineT; % s
rectifier.controller.VoltageG = (rectifier.OutputCapacitance...
    *rectifier.CurrentSensorG)/...
    (rectifier.K*2*rectifier.VoltageSensorG*rectifier.Tdel); 
rectifier.controller.VoltageT = 4*rectifier.Tdel; % s
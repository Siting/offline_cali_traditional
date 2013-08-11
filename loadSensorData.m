function[flowDataLanes, flowDataSum] = loadSensorData(sensorID, sensorDataFolder, month, date)
% input: sensorID & the folder sensor data is in

[num,txt,raw] = xlsread(['.\' sensorDataFolder '\' num2str(sensorID) '_' num2str(month) '_' num2str(date)]);
% compute # lanes of the link
if strcmp(sensorDataFolder, 'occupancy')
    numLanes = (size(txt,2)-1);
else
    numLanes = (size(txt,2)-1) / 2;
end
% extract flow data for each lane
flowDataLanes = num(:, 1: numLanes);
flowDataSum = sum(flowDataLanes,2);

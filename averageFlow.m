clear all
clc

sensorIDs = [400468; 400739; 400363; 400698];
months = 5;
dates = [10; 11; 13; 14; 15];
sensorDataFolder = 'sensorData_flow_version2';
newSensorDataFolder = 'sensorData_flow_version3';

deltaT = 2; % unit: second
dataInterval = 0.5;  % unit: min
c = dataInterval*60/deltaT;

for i = 1 : length(months)
    month = months(i);
    for j = 1 : length(dates)
        date = dates(j);
        for k = 1 : length(sensorIDs)
            sensorID = sensorIDs(k);
            load(['.\' sensorDataFolder '\' num2str(sensorID) '_'...
                num2str(month) '_' num2str(date) '.mat']);
            flowDataSum = flowDataSum ./ c;
            flowDataLanes = flowDataLanes ./ c;
            save([num2str(newSensorDataFolder) '\' num2str(sensorID)...
                '_' num2str(month) '_' num2str(date)], 'flowDataSum', 'flowDataLanes', 'speedDataLanes');
        end
    end
end
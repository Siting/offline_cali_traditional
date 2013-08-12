clear all
clc

sensorIDs = [400468; 400739; 400363; 400698];
months = 5;
dates = [10; 11; 13; 14; 15];
sensorDataFolder = 'sensorData_flow_mat';
newSensorDataFolder = 'sensorData_flow_version2';

for i = 1 : length(months)
    month = months(i);
    for j = 1 : length(dates)
        date = dates(j);
        for k = 1 : length(sensorIDs)
            sensorID = sensorIDs(k);
            load(['.\' sensorDataFolder '\' num2str(sensorID) '_'...
                num2str(month) '_' num2str(date) '.mat']);
            if size(flowDataSum,1) == 5760
                keyboard
                flowDataSum_30s = [];
                flowDataLanes_30s = [];
                for row = 1 : 4 : (size(flowDataSum,1))
                    % add up data for each miniute
                    dataSum_30s = sum(flowDataSum(row:row+3));
                    dataLanes_30s = sum(flowDataLanes(row:row+3));
                    % duplicate the data and take half of 1 min
                    flowDataSum_30s = [flowDataSum_30s; dataSum_30s/2; dataSum_30s/2];
                    flowDataLanes_30s = [flowDataLanes_30s; dataLanes_30s/2; dataLanes_30s/2];
                end
            elseif size(flowDataSum,1) == 2880
                keyboard
                flowDataSum_30s = [];
                flowDataLanes_30s = [];
                for row = 1 : 2 : (size(flowDataSum,1))
                    % add up data for each miniute
                    dataSum_30s = sum(flowDataSum(row:row+1));
                    dataLanes_30s = sum(flowDataLanes(row:row+1));
                    % duplicate the data and take half of 1 min
                    flowDataSum_30s = [flowDataSum_30s; dataSum_30s/2; dataSum_30s/2];
                    flowDataLanes_30s = [flowDataLanes_30s; dataLanes_30s/2; dataLanes_30s/2];
                end
            end
            
            flowDataSum = flowDataSum_30s;
            flowDataLanes = flowDataLanes_30s;
            save([num2str(newSensorDataFolder) '\' num2str(sensorID)...
                '_' num2str(month) '_' num2str(date)], 'flowDataSum', 'flowDataLanes', 'speedDataLanes');
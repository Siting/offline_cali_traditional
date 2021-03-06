% transfer excel sensor data into mat file
% add flows across lanes ==> flowDataSum
clear all
clc

sensorIDs = [402955; 402953; 402954; 402950];
months = 5;
dates = [11; 13; 14; 15; 16];
sensorDataFolder = 'sensorData';

% load sensor data
for j = 1 : length(months)
    month = months(j);
    for k = 1 : length(dates)
        date = dates(k);
        for i = 1 : length(sensorIDs)
            sensorID = sensorIDs(i);
            [flowDataLanes, flowDataSum, speedDataLanes] = loadSensorData(sensorID, sensorDataFolder, month, date);

            save(['sensorData_flow_mat\' num2str(sensorID) '_' num2str(month) '_' num2str(date)],...
                'flowDataLanes', 'flowDataSum', 'speedDataLanes');

        end
    end
end


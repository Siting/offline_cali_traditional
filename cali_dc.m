clear all
clc

sensorIDs = [400468; 400739; 400363; 400698];
months = 5;
dates = [11; 13; 14; 15; 16];
sensorDataFolder1 = 'sensorData_flow_version2';
sensorDataFolder2 = 'vmax_results';
newFolder = 'dc_results';

for i = 1 : length(sensorIDs)
    sensorID = sensorIDs(i);
    flowDataCollection = [];
    for m = 1 : length(dates)
        date = dates(m);
        for k = 1 : length(months)
            month = months(k);
            load(['.\' sensorDataFolder1 '\' num2str(sensorID) '_' num2str(month) '_' num2str(date) '.mat']);
            load(['.\' sensorDataFolder2 '\' num2str(sensorID) '.mat']);
            flowInHour = flowDataLanes .* 2 .* 60;
            flowDataCollection = [flowDataCollection; flowInHour];
        end
    end
    dc = max(max(flowDataCollection)) / vmax;
    keyboard
    save([num2str(newFolder) '\' num2str(sensorID)], 'dc');
end


clear all
clc

sensorIDs = [400468; 400739; 400363; 400698];
months = 5;
dates = [11; 13; 14; 15; 16];
sensorDataFolder1 = 'sensorData_flow_version2';
newSensorDataFolder = 'sensorData_density';

for i = 1 : length(sensorIDs)
    sensorID = sensorIDs(i);
    for m = 1 : length(dates)
        date = dates(m);
        for k = 1 : length(months)
            month = months(k);
            load(['.\' sensorDataFolder1 '\' num2str(sensorID) '_' num2str(month) '_' num2str(date) '.mat']);
            
            % compute # lanes of the link
            numLanes = size(flowDataLanes,2);
            % compute density
            densityLanes = flowDataLanes .* 60 .* 2 ./ speedDataLanes;  % 60 * 2 ==> 30s to hr
            % compute density across all lanes (get sum)
            densityDataSum = sum(densityLanes,2);
            for j = 1 : size(densityDataSum,1)
                if isnan(densityDataSum(j)) && j >= 4 && j <= size(densityDataSum,1)-3
                    dataWindow = densityDataSum(j-3 : j+3);
                    densityDataSum(j) = mean(dataWindow(isnan(dataWindow)==0));
                elseif isnan(densityDataSum(j)) && j < 4
                    dataWindow = densityDataSum(j+1: j+4);
                    densityDataSum(j) = mean(dataWindow(isnan(dataWindow)==0));
                elseif isnan(densityDataSum(j)) && j > size(densityDataSum,1)-3
                    dataWindow = densityDataSum(j-8: j-5);
                    densityDataSum(j) = mean(dataWindow(isnan(dataWindow)==0));
                end
            end
            densityDataSum = smooth(densityDataSum);
            
            if any(densityDataSum<0)
                densityDataSum(densityDataSum<0) = 0 ;
            end
            save([num2str(newSensorDataFolder) '\' num2str(sensorID) '_' num2str(month) '_' num2str(date)], 'densityDataSum', 'densityLanes');
        end
        
    end
    
end
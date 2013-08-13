clear all
clc

sensorIDs = [402955; 402953; 402954; 402950];
months = 5;
dates = [11; 13; 14; 15; 16];
sensorDataFolder1 = 'sensorData_flow_version2';
sensorDataFolder2 = 'sensorData_density';
newFolder = 'vmax_results';

for i = 1 : length(sensorIDs)
    flowCollection = [];
    densityCollection = [];
    sensorID = sensorIDs(i);
    for m = 1 : length(dates)
        date = dates(m);
        for k = 1 : length(months)
            month = months(k);
            load(['.\' sensorDataFolder1 '\' num2str(sensorID) '_' num2str(month) '_' num2str(date) '.mat']);
            load(['.\' sensorDataFolder2 '\' num2str(sensorID) '_' num2str(month) '_' num2str(date) '.mat']);

            if size(flowDataLanes,1) == 2880
                for n = 1 : size(flowDataLanes,2)
                    col = speedDataLanes(:,n);
                    flowDataLane = flowDataLanes(col>55,n).*2.*60;
                    densityDataLane = densityLanes(col>55,n);
                    flowCollection = [flowCollection; flowDataLane];
                    densityCollection = [densityCollection; densityDataLane];
                end
            elseif size(flowDataLanes,1) == 5760
                for n = 1 : size(flowDataLanes,2)
                    col = speedDataLanes(:,n);
                    flowDataLane = flowDataLanes(col>55,n).*2.*60;
                    densityDataLane = densityLanes(col>55,n);
                    flowCollection = [flowCollection; flowDataLane];
                    densityCollection = [densityCollection; densityDataLane];
                end
            end
        end
    end
    vmax = lsqlin(densityCollection,flowCollection,[],[],0,0,0,[]);

    save([num2str(newFolder) '\' num2str(sensorID) '_vmax'], 'vmax');

%     figure
%     plot(densityCollection, flowCollection, '.');
%     result = polyfit(densityCollection,flowCollection,1);
%     hold on
%     plot((0:40), vmax(1).*(0:40),'r');
end
                    
                    

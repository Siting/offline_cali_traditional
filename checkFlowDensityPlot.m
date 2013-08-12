clear all
clc

sensorIDs = [400698];
months = 5;
dates = [11; 13; 14; 15; 16];
sensorDataFolder1 = 'sensorData_flow_version2';
sensorDataFolder2 = 'sensorData_density';

for i = 1 : length(sensorIDs)
    sensorID = sensorIDs(i);
    for m = 1 : length(dates)
        date = dates(m);
        for k = 1 : length(months)
            month = months(k);
            load(['.\' sensorDataFolder1 '\' num2str(sensorID) '_' num2str(month) '_' num2str(date) '.mat']);
            load(['.\' sensorDataFolder2 '\' num2str(sensorID) '_' num2str(month) '_' num2str(date) '.mat']);

            figure(i)
            for j = 1 : size(densityLanes,2)
                if size(densityLanes,1) == 2880
                    col = densityLanes(:,j);
                    densityLane = col(col<600);
                    flowDataLane = flowDataLanes(col<500,j);
                    plot(densityLane,(flowDataLane.*2),'.');
                elseif size(densityLanes,1) == 5760
                    col = densityLanes(:,j);
                    densityLane = col(col<600);
                    flowDataLane = flowDataLanes(col<500,j);
                    plot(densityLane,(flowDataLane.*4),'.');
                end
                hold on
            end
        end
    end
    hold off
    xlabel('density');
    ylabel('flow')
    title(['flow density plot of sensor ' num2str(sensorID)]);

    saveas(gcf, ['.\plots\funda_' num2str(sensorID) '.pdf']);
end
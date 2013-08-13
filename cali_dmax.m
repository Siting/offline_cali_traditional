clear all
clc

sensorIDs = [402955; 402953; 402954; 402950];
months = 5;
dates = [11; 13; 14; 15; 16];
sensorDataFolder1 = 'sensorData_flow_version2';
sensorDataFolder2 = 'sensorData_density';
sensorDataFolder3 = 'dc_results';
sensorDataFolder4 = 'vmax_results';
newFolder = 'dmax_results';

for i = 1 : length(sensorIDs)
    sensorID = sensorIDs(i);
    flowDataCollection = [];
    densityDataCollection = [];
    for m = 1 : length(dates)
        date = dates(m);
        for k = 1 : length(months)
            month = months(k);
            load(['.\' sensorDataFolder1 '\' num2str(sensorID) '_' num2str(month) '_' num2str(date) '.mat']);
            load(['.\' sensorDataFolder2 '\' num2str(sensorID) '_' num2str(month) '_' num2str(date) '.mat']);
            load(['.\' sensorDataFolder3 '\' num2str(sensorID) '_dc.mat']);
            
            for n = 1 : size(flowDataLanes,2)
                col = densityLanes(:,n);
                flowDataLane = flowDataLanes(col > dc, n);
                densityLane = densityLanes(col > dc, n);
                flowDataCollection = [flowDataCollection; flowDataLane .* 2 .*60];
                densityDataCollection = [densityDataCollection; densityLane];
            end
        end
    end
    pairCollection = [densityDataCollection, flowDataCollection];
    
    % sort only the first column, return indices of the sort & reorder
    [~,sorted_inds] = sort( pairCollection(:,1) );
    sortedPairCollection = pairCollection(sorted_inds,:);

    % partition data into bins with 10 points
    dData = sortedPairCollection(1:floor(size(sortedPairCollection,1)/10)*10,1);
    fData = sortedPairCollection(1:floor(size(sortedPairCollection,1)/10)*10,2);
    densityBins = reshape(dData, 10, floor(size(sortedPairCollection,1)/10));
    flowBins = reshape(fData, 10, floor(size(sortedPairCollection,1)/10));

    meanDensity_bins = mean(densityBins,1);
    meanDensity_bins = meanDensity_bins(isinf(meanDensity_bins)==0);
    f_Bins = [];
    for q = 1 : size(meanDensity_bins,2)
        quantiles_flow_bins(:,q) = quantile(flowBins(:,q), [0.25, 0.5, 0.75]);
        fLarge = quantiles_flow_bins(3,q) + 1.5 * (quantiles_flow_bins(3,q) - quantiles_flow_bins(1,q));
        col = flowBins(:,q);
        f_Bins(:,q) = max(col(col<=fLarge));
    end
    % compute capacity
    load(['.\' sensorDataFolder4 '\' num2str(sensorID) '_vmax.mat']);
    qmax = dc * vmax;

    % compute w
    w = lsqlin([meanDensity_bins' ones(size(meanDensity_bins,2),1)],f_Bins,[],[],[dc 1], qmax,[],[]);
    dmax = - w(2) / w(1);

%     plot(meanDensity_bins,f_Bins,'.');
%     hold on
%     plot((20:250), w(1).*(20:250)+ w(2),'r')
    save([num2str(newFolder) '\' num2str(sensorID) '_dmax'], 'dmax');
    
end
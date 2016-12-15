Alocations = csvread('Alocations.csv'); % known temperature points
wi_coords = csvread('wi_longlat.csv');  % map of wisconsin

% use the boundaries of the wisconsin map to derive the grid coords
% for the creation of the contours
xbounds = [min(wi_coords(:,1)), max(wi_coords(:,1))];
ybounds = [min(wi_coords(:,2)), max(wi_coords(:,2))];
xaxis = linspace(xbounds(1), xbounds(2), 50)';
yaxis = linspace(ybounds(1), ybounds(2), 50)';

m = size(xaxis,1);
n = size(yaxis,1);
z = zeros(n,m);
l = size(Alocations,1);

for i=1:m
    for j = 1:n
        denominator = 0;
        for k = 1:l
            alpha = sqrt((xaxis(i)-Alocations(k,1))^2 + (yaxis(j)-Alocations(k,2))^2);
            z(j,i)=z(j,i)+ alpha * Alocations(k,3);
            denominator = denominator + alpha;
        end
        z(j,i)=z(j,i)/denominator;
    end                
end

figure1 = figure;
axes1 = axes('Parent',figure1);
hold(axes1,'on');

[C,h] = contourf(xaxis, yaxis, z);
clabel(C,h);
xlabel('Latitutde');
ylabel('Longitude');
colormap(flipud(colormap('autumn')));
% colorbar('peer',axes1);
title('Regional Warming Trend in \circF / Century');
plot(wi_coords(:,1), wi_coords(:,2), 'b');
scatter(Alocations(:,1), Alocations(:,2), 'go');
pbaspect([1 1 1]);
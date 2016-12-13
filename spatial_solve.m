Alocations = csvread('Alocations.csv'); % known temperature points
wi_coords = csvread('wi_longlat.csv');  % map of wisconsin

% use the boundaries of the wisconsin map to derive the grid coords
% for the creation of the contours
xbounds = [min(wi_coords(:,1)), max(wi_coords(:,1))];
ybounds = [min(wi_coords(:,2)), max(wi_coords(:,2))];
xaxis = linspace(xbounds(1), xbounds(2), 50)';
yaxis = linspace(ybounds(1), ybounds(2), 50)';

% place the average warming at the boundaries. This helps the poly-fit
% but also means that we cannot trust data outside the boundries of our
% measure
% A different way to do this would be to calculate the contours only
% within the bound of the cities we have info for.

avg_temp = mean(Alocations(:,3));
avg_bounds = [[xbounds(1), ybounds(1), avg_temp]; ...
    [xbounds(1), ybounds(2), avg_temp];...
    [xbounds(2), ybounds(1), avg_temp];...
    [xbounds(2), ybounds(2), avg_temp];];
Alocations = [Alocations' avg_bounds']';

% Set up the matrix which we will use to optimize the polynomial
% interpolation
x = Alocations(:,1);
y = Alocations(:,2);
% degree 2 polynomial expansion (is there a matlab function to do this?)
K = poly_expand(x,y);

b = Alocations(:,3);

cvx_begin quiet
    variable x(6)
    minimize( norm(K*x - b) )
cvx_end

spatial_change = x;

% now solve the grid and plot (with known values replacing estimates)
m = size(xaxis,1);
n = size(yaxis,1);
z = zeros(n,m);

for i=1:m
    x = ones(n, 1) .* xaxis(i);
    z(:,i) = poly_expand(x,yaxis) * spatial_change;
end

% append the known locations
% for i = 1:size(Alocations,1)
%     if (xaxis(i)==Alocations(k,1)) && (yaxis(j)==Alocations(k,2))
%         z(j,i)=Alocations(k,3);
%     end
% end

figure;
[C,h] = contourf(xaxis, yaxis, z);
clabel(C,h);
xlabel('Latitutde');
ylabel('Longitude');
title('Regional Warming Trend in \circF / Century');
hold on;
plot(wi_coords(:,1), wi_coords(:,2), 'k');
scatter(Alocations(:,1), Alocations(:,2), 'ro');
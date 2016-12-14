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
% 
% avg_temp = mean(Alocations(:,3));
% avg_bounds = [[xbounds(1), ybounds(1), avg_temp]; ...
%     [xbounds(1), ybounds(2), avg_temp];...
%     [xbounds(2), ybounds(1), avg_temp];...
%     [xbounds(2), ybounds(2), avg_temp];];
% Alocations = [Alocations' avg_bounds']';

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

% This is one way to do interpolation. It simply fits a polynomial curve.
% This method gives poor fits near the boundaries.
for i=1:m
    x = ones(n, 1) .* xaxis(i);
    z(:,i) = poly_expand(x,yaxis) * spatial_change;
end

% another interpolation method combines a polynomial fit with an initial
% estimate given by the nearest neighbor. This more realistically fits
% edges
z = zeros(size(xaxis,1), size(yaxis,1));
for i = 1:size(xaxis,1)
    for j = 1:size(yaxis,1)
        idx_near = get_nearby([xaxis(i), yaxis(j)], Alocations(:,1:2), -1);
        z(j,i) = Alocations(idx_near, 3);
    end
end
% For a given point, find a set of nearby neighbors, calculate a polynomial
% for those neighbors and apply to the existing estimate. This is just a
% guess
radius = 1.0;
total_solve = size(xaxis,1) * size(yaxis,1);
last_select = [];
last_params = [];
for i = 1:size(xaxis,1)
    for j = 1:size(yaxis,1)
        idx_near = get_nearby([xaxis(i), yaxis(j)], Alocations(:,1:2), radius)';
        if size(idx_near,1) > 1
            params = [];
            if isequal(last_select,idx_near)
                params = last_params;
            else
                aselect = Alocations(idx_near,:);
                K = poly_expand(aselect(:,1),aselect(:,2));
                b = aselect(:,3);
                cvx_begin quiet
                    variable x(6)
                    minimize( norm(K*x - b) )
                cvx_end
                params = x;
                last_params = params;
                last_select = idx_near;
            end
            yest = poly_expand(xaxis(i), yaxis(j)) * params;
            %z(j,i) = (z(j,i) + yest) / 2;
            z(j,i) =  yest;
        end
        remaining = total_solve
        total_solve = total_solve - 1;
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
plot(wi_coords(:,1), wi_coords(:,2), 'k');
scatter(Alocations(:,1), Alocations(:,2), 'ko');
pbaspect([1 1 1]);
for i = 1:size(Alocations,1)
    text(Alocations(i,1),Alocations(i,2) + 0.1,num2str(Alocations(i,3)))
end
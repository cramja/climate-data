yaxis=csvread('yaxis.csv');
xaxis=csvread('xaxis.csv');
Alocations=csvread('Alocations.csv');
outlinex=csvread('outlinex.csv');
outliney=csvread('outliney.csv');

mm = size(Alocations,1);
K = zeros(mm,6);
%K = zeros(mm,3);

for i = 1:mm
    x = Alocations(i,1);
    y = Alocations(i,2);
    K(i,:) = [1 x y x*y x^2 y^2];
    %K(i,:) = [1 x y];
end


b = Alocations(:,3);

cvx_begin quiet
    variable x(6)
    %variable x(3)
    minimize( norm(K*x-b) )
cvx_end

spatial_change = x


%now solve the grid and plot (with known values replacing estimates)
m = size(xaxis,1);
n = size(yaxis,1);
z=zeros(n,m);

for i=1:m
    for j=1:n
        grid_input = [1 xaxis(i) yaxis(j) xaxis(i)*yaxis(j) xaxis(i)^2 yaxis(j)^2];
        %grid_input = [1 xaxis(i) yaxis(j)];
        z(j,i) = grid_input * spatial_change;
        for k = 1:size(Alocations,1)
            if (xaxis(i)==Alocations(k,1)) && (yaxis(j)==Alocations(k,2))
                z(j,i)=Alocations(k,3);
            end
        end
    end
end

% figure;
% surf(xaxis,yaxis,z)
% xlabel('Miles E')
% ylabel('Miles N')
% zlabel('Degrees F Warming / Century')
% title('Regional Warming Trend')

figure;
[C,h]=contour(xaxis,yaxis,z);
clabel(C,h)
xlabel('Miles E')
ylabel('Miles N')
title('Regional Warming Trend in deg F / Century')
hold on
plot(outlinex,outliney)
axis equal
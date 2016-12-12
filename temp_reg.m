function [lin_inc_LAD] = temp_reg( city )
%RUN LS and LAD on the data
%   Input is the data for a city in format [day temp]

%least square solver
m = size(city,1);

d = city(:,1);

A = ones(m,6);
A(:,2) = d;
A(:,3) = cos(2*pi.*d/365.25);
A(:,4) = sin(2*pi.*d/365.25);
A(:,5) = cos(2*pi.*d/(10.7*365.25));
A(:,6) = sin(2*pi.*d/(10.7*365.25));

b = city(:,2);

cvx_begin quiet
    variable x(6)
    minimize( norm(A*x-b) )
cvx_end

lin_inc_LS = 365.25*100*x(2)

%LAD solver

cvx_begin quiet
    variable y(6)
    minimize( norm(A*y-b,1) )
cvx_end
y
lin_inc_LAD = 365.25*100*y(2)

end


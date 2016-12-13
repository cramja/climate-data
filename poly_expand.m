function [ ex ] = poly_expand(x,y)
%POLY_EXPAND expands a given x and y to the degree 2 expansion with
%   an offset term
%   TODO: all degrees
s_x = size(x, 1);
ex = [ones(s_x, 1), x, y, x.*y, x.^2, y.^2];
end


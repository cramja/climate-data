function [ idx ] = get_nearby( p, x, radius )
%GET_NEARBY gets points from x = [long,lat, ... ] near p in a given radius
%   radius == -1 indicates that you want the index of the point which is
%   closest to the given p
    idx = [];
    min_d = 10000;
    for i = 1:size(x,1)
        pdist = norm(x(i,1:2) - p);
        if radius == -1 && min_d > pdist
            min_d = pdist;
            idx = i;
        else if pdist < radius
            idx = [idx, i];
        end
    end
end

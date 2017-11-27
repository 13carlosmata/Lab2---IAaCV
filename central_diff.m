function [deltax,deltay] = central_diff(order)

if order == 1
    deltax = [-1/2,0,1/2];
    deltay = [-1/2;0;1/2];

elseif order == 2
    deltax = [1,-2,1];
    deltay = [1;-2;1];
end
end

function [deltax,deltay] = central_diff(order)
deltax = zeros(5);
deltay = zeros(5);

if order == 1
    deltax(3,2:4) = [-1/2,0,1/2];
    deltay(2:4,3) = [-1/2;0;1/2];

elseif order == 2
    deltax(3,2:4) = [1,-2,1];
    deltay(2:4,3) = [1;-2;1];
end
end

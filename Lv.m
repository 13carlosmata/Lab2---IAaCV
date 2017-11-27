function pixels = Lv(inpic, shape)
if (nargin < 2)
shape = 'same';
end
Lx = filter2(deltax("sobel"), inpic, shape);
Ly = filter2(deltay("sobel"), inpic, shape);
pixels = Lx.^2 + Ly.^2;
end
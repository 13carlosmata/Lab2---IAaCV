function res = Lvvvtilde(inpic, shape)

[dx,dy] = central_diff(1);
[dxx,dyy] = central_diff(2);

dxxx = conv2(dx, dxx, shape);
dxxy = conv2(dxx, dy, shape);
dxyy = conv2(dx, dyy, shape);
dyyy = conv2(dy,dyy, shape);

Lx   = filter2(dx, inpic, shape);
Lxxx = filter2(dxxx, inpic, shape);
Ly   = filter2(dy, inpic, shape);
Lxxy = filter2(dxxy, inpic, shape);
Lxyy = filter2(dxyy, inpic, shape);
Lyyy = filter2(dyyy, inpic, shape);

res = Lx.^3 .*Lxxx + 3.*Lx.^2.*Ly.*Lxxy + 3.*Lx.*Ly.^2.*Lxyy + Ly.^3.*Lyyy;
end

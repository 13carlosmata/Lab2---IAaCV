function res = Lvvtilde(inpic, shape)

[dx,dy] = central_diff(1);
[dxx,dyy] = central_diff(2);

dxy = filter2(dx,dy,shape);

Lx  = filter2(dx, inpic, shape);
Ly  = filter2(dy, inpic, shape);
Lxx = filter2(dxx, inpic, shape);
Lyy = filter2(dyy, inpic, shape);
Lxy = filter2(dxy, inpic, shape);

res = Lx^2 .* Lxx + 2.*Lx.*Ly.*Lxy + Ly^2.*Lyy;
end

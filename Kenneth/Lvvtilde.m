function pixels = Lvvtilde(inpic, shape)
    if (nargin < 2)
        shape = 'same';
    end
    
    [dxmask, dymask] = grad_op(1);
    [dxxmask, dyymask] = grad_op(2);
    dxymask = conv2(dxmask, dymask, 'same');
    
    Lx = filter2(dxmask, inpic, shape);
    Ly = filter2(dymask, inpic, shape);
    Lxx = filter2(dxxmask, inpic, shape);
    Lxy = filter2(dxymask, inpic, shape);
    Lyy = filter2(dyymask, inpic, shape);
    
    pixels = Lx.^2 .* Lxx + 2 .* Lx .* Ly .* Lxy + Ly.^2 .* Lyy;
function pixels = Lvvvtilde(inpic, shape)
    if (nargin < 2)
        shape = 'same';
    end
    
    [dxmask, dymask] = grad_op(1);
    [dxxmask, dyymask] = grad_op(2);
    dxxymask = conv2(dxxmask, dymask, 'same');
    dxyymask = conv2(dxmask, dyymask, 'same');
    dxxxmask = conv2(dxmask, dxxmask, 'same');
    dyyymask = conv2(dymask, dyymask, 'same');

    Lx = filter2(dxmask, inpic, shape);
    Ly = filter2(dymask, inpic, shape);
    Lxxx = filter2(dxxxmask, inpic, shape);
    Lxxy = filter2(dxxymask, inpic, shape);
    Lxyy = filter2(dxyymask, inpic, shape);
    Lyyy = filter2(dyyymask, inpic, shape);
    
    
    pixels = Lx.^3 .* Lxxx + 3 .* Lx.^2 .* Ly .* Lxxy + 3 .* Lx .* Ly.^2 .* Lxyy + Ly.^3 .* Lyyy;
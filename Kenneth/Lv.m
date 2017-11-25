function pixels = Lv(inpic, shape)
    if (nargin < 2)
        shape = 'same';
    end
    
    [dxmask, dymask] = grad_op(1);

    Lx = filter2(dxmask, inpic, shape);
    Ly = filter2(dymask, inpic, shape);
    pixels = Lx.^2 + Ly.^2;
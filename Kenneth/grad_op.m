function [dxmask, dymask] = grad_op(order)
    
  dxmask = zeros(5,5);
  dymask = zeros(5,5);
  
  if (order == 1)
      dxmask(3,2:4) = [-1/2,0,1/2];
      dymask(2:4,3) = [-1/2,0,1/2];
  elseif (order == 2)
      dxmask(3,2:4) = [1,-2,1];
      dymask(2:4,3) = [1,-2,1];
  end
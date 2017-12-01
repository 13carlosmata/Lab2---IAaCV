function [linepar, acc] = houghline(curves, magnitude,nrho, ntheta, threshold, nlines, verbose)
picture = magnitude;
% Check if input appear to be valid
if (nrho <= 0 || ntheta <=0 || threshold < 0 || nlines <=0)
    error(' Check the inputs in Houghlune, inputs are not valid !!'); 
end
% Allocate accumulator space
acc = zeros(nrho,ntheta);
% Define a coordinate system in the accumulator space
diag = sqrt((size(magnitude,1)-1)^2+(size(magnitude,2)-1)^2);

rho_space = linspace(-diag,diag,nrho);
theta_space = linspace(-pi/2,pi/2,ntheta);
% Loop over all the input curves (cf. pixelplotcurves) for each point on each curve

insize = size(curves, 2);
trypointer = 1;
while trypointer <= insize
    polylength = curves(2, trypointer);
    trypointer = trypointer + 1;
    % For each point on each curve
    for polyidx = 1:polylength
        x = curves(2, trypointer);
        y = curves(1, trypointer);
        r_x = round(x);
        r_y = round(y);
        % Check if valid point with respect to threshold
        if (r_x < nrho && r_y < ntheta)
            if (magnitude(r_x,r_y) > threshold)
                %Optionally, keep value from magnitude imag
                %magnitude(round(x),round(y)) = 1;
                value_pixel = magnitude(round(x),round(y));
                %Loop over a set of theta values
                for theta=1:ntheta
                    rho = x*cos(theta_space(theta))+ y*sin(theta_space(theta));
                    % Compute index values in the accumulator space
                    rho_idx = 1+floor((diag+rho)/((2*diag)/(nrho-1)));
                    % Update the accumulator
                    if verbose > 0
                        acc(rho_idx,theta) = acc(rho_idx,theta) + magnitude(round(x),round(y));
                    elseif verbose == 0
                        acc(rho_idx,theta) = acc(rho_idx,theta) + 1;
                    end
                end
            end
        end
        trypointer = trypointer + 1;
    end
end

% Delimit the number of responses if necessary

acc = binsepsmoothiter(acc, 0.1, 0);

% Extract local maxima from the accumulator

linepar = zeros(2,nlines);
[pos, value] = locmax8(acc);
[dummy, indexvector] = sort(value);
nmaxima = size(value, 1);

for idx = 1:nlines
    rhoidxacc = pos(indexvector(nmaxima - idx + 1), 1);
    thetaidxacc = pos(indexvector(nmaxima - idx + 1), 2);
    linepar(:,idx) = [rho_space(rhoidxacc), theta_space(thetaidxacc)]'; 
end

% Compute a line for each one of the strongest responses in the accumulator

outcurves = zeros(2,4*nlines);
for idx = 1:nlines
    rho = linepar(1,idx);
    theta = linepar(2,idx);
    if (theta > pi/4 || theta < -pi/4)
        x0 = size(magnitude,1)/2;
        y0 = rho / sin(theta) - cos(theta) * x0 / sin(theta);
        dx = size(magnitude,1)/2;
        dy = -dx / tan(theta);
    elseif (-pi/4 <= theta && theta <= pi/4)
        y0 = size(magnitude,2)/2;
        x0 = rho / cos(theta) - sin(theta) * y0 / cos(theta);
        dy = size(magnitude,2)/2;
        dx = -tan(theta) * dy;
    end
    outcurves(1, 4*(idx-1) + 1) = 0; % level, not significant
    outcurves(2, 4*(idx-1) + 1) = 3; % number of points in the curve
    outcurves(2, 4*(idx-1) + 2) = x0-dx;
    outcurves(1, 4*(idx-1) + 2) = y0-dy;
    outcurves(2, 4*(idx-1) + 3) = x0;
    outcurves(1, 4*(idx-1) + 3) = y0;
    outcurves(2, 4*(idx-1) + 4) = x0+dx;
    outcurves(1, 4*(idx-1) + 4) = y0+dy;

end
% Overlay these curves on the gradient magnitude image
if verbose == 2
    overlaycurves(linepar, outcurves);
elseif verbose ~= 2
    overlaycurves(picture, outcurves); 
end






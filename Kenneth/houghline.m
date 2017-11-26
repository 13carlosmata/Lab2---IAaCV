function [linepar, acc] = houghline(curves, magnitude, nrho, ntheta, threshold, nlines, n_smooth, show_img)
% linepar is a list of (rho, theta) parameters for each line segment,
% acc is the accumulator matrix of the Hough transform,
% curves are the polygons from which the transform is to be computed,
% magnitude is an image with one intensity value per pixel
% nrho is the number of accumulators in the rho direction,
% nthetais the number of accumulators in the theta direction,
% threshold is the lowest value allowed for the given magnitude,
% nlines is the number of lines to be extracted,
% num_smooth is the number of times to smooth the histogram for delta rho and
% delta theta
% img_show is to show the houghlines overlaying the original image

% Allocate accumulator space
acc = zeros(nrho,ntheta);

% Define a coordinate system in the accumulator space
diag = sqrt((size(magnitude,1)-1)^2+(size(magnitude,2)-1)^2);
rho_axis = linspace(-diag,diag,nrho);
theta_axis = linspace(-pi/2,pi/2,ntheta);

% Loop over all the input curves
insize = size(curves,2);
trypointer = 1;
while trypointer<=insize
    polylength = curves(2,trypointer);
    trypointer = trypointer + 1;
    for polyindex = 1:polylength
        % For each point on each curve
        x = curves(2, trypointer);
        y = curves(1, trypointer);
        % Check if valid point with respect to threshold
        if (magnitude(round(x),round(y)) > threshold)
            % Optionally, keep value from magnitude image
            pixel_val = magnitude(round(x), round(y));
%             pixel_val = 1;
            % Loop over a set of theta values
            for theta = 1:ntheta
                % Compute rho for each theta value
                rho = sin(theta_axis(theta))*y + cos(theta_axis(theta))*x;
                % Compute index values in the accumulator space
                rho_idx = 1+floor((diag+rho)/((2*diag)/(nrho-1)));
                % Update the accumulator
                acc(rho_idx,theta) = acc(rho_idx,theta) + pixel_val;
            end
        end
        trypointer = trypointer + 1;
    end
end

% Delimit the number of responses if necessary
DT = 0.1;
% n_smooth = 0;
acc = binsepsmoothiter(acc, DT, n_smooth);

% Extract local maxima from the accumulator
linepar = zeros(2,nlines);
[pos, value] = locmax8(acc);
[dummy, indexvector] = sort(value);
nmaxima = size(value, 1);

for idx = 1:nlines
    rhoidxacc = pos(indexvector(nmaxima - idx + 1), 1);
    thetaidxacc = pos(indexvector(nmaxima - idx + 1), 2);
    linepar(:,idx) = [rho_axis(rhoidxacc), theta_axis(thetaidxacc)]'; 
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
    
    outcurves(2, 4*(idx-1) + 1) = 3; % number of points in the curve
    outcurves(2, 4*(idx-1) + 2) = x0-dx;
    outcurves(1, 4*(idx-1) + 2) = y0-dy;
    outcurves(2, 4*(idx-1) + 3) = x0;
    outcurves(1, 4*(idx-1) + 3) = y0;
    outcurves(2, 4*(idx-1) + 4) = x0+dx;
    outcurves(1, 4*(idx-1) + 4) = y0+dy;
    
    % Overlay these curves on the gradient magnitude image
    if (show_img)
        overlaycurves(magnitude, outcurves);  title('Hough Edge Lines');
    end
end


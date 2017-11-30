function [linepar,acc] = houghline_test(curves, magnitude,nrho, ntheta, threshold, nlines, sm, verbose)
% linepar is a list of (ro;theta) parameters for each line segment,
% acc is the accumulator matrix of the Hough transform,
% curves are the polygons from which the transform is to be computed,
% magnitude is an image with one intensity value per pixel
% in exercise 6.2 you will here give the gradient magnitude as an argument),
% nrho is the number of accumulators in the rho direction,
% ntheta is the number of accumulators in the theta direction,
% threshold is the lowest value allowed for the given magnitude,
% nlines is the number of lines to be extracted,
% verbose denotes the degree of extra information and figures that will be shown

INC=0;

% Check if input appear to be valid
if size(curves,1)~=2
    display('curves has incorrect dimensions, should be 2xN');
    return
end

% Allocate accumulator space
acc=zeros(nrho,ntheta);

% Define a coordinate system in the accumulator space
M=norm([size(magnitude,1),size(magnitude,2)]);
rho=linspace(-M,M,nrho);
N=deg2rad(90);
theta=linspace(-N,N,ntheta);
drho=rho(2)-rho(1);
dtheta=theta(2)-theta(1);

% Loop over all the input curves (cf. pixelplotcurves)
% For each point on each curve
insize = size(curves, 2);
trypointer = 1;
image=zeros(size(magnitude));
while trypointer <= insize
  polylength = curves(2, trypointer);
  trypointer = trypointer + 1;
  for polyidx = 1:polylength
    x = curves(2, trypointer);
    y = curves(1, trypointer);
    xi=round(x);
    yi=round(y);
    magTh= magnitude> threshold;
    % Check if valid point with respect to threshold
    % Optionally, keep value from magnitude image
    if (xi < nrho && yi < ntheta)
        if magTh(xi,yi)
            image(xi,yi) = 1;
            % Loop over a set of theta values
            % Compute rho for each theta value
            rh=round(1/drho*(x*cos(theta)+y*sin(theta)+M))+1;
            th=round(1/dtheta*(theta+N))+1;        
            for t=th
                if INC==0
                    acc(rh(t),t)=acc(rh(t),t)+1;
                elseif INC==1
                    acc(rh(t),t)=acc(rh(t),t)+magnitude(xi,yi);
                end
            end
        end
        trypointer = trypointer + 1;
    end
  end
end
if sm
    acc = binsepsmoothiter(acc,0.5,sm);
end
if ( verbose >= 2)
    figure;
    subplot(1,3,1);
    overlaycurves(magnitude,curves);
    title('$Edges$','Interpreter','latex')
    subplot(1,3,2);
    showgrey(acc);
    title('$Accumulator$','Interpreter','latex')
end

% Extract local maxima from the accumulator
% Delimit the number of responses if necessary
[pos,value] = locmax8(acc);
[~,indexvector] = sort(value);
nmaxima = size(value, 1);

% Compute a line for each one of the strongest responses in the accumulator
linepar=zeros(2,nlines*4);
for idx = 1:nlines
    rhoidxacc = pos(indexvector(nmaxima - idx + 1), 1);
    thetaidxacc = pos(indexvector(nmaxima - idx + 1), 2);

    x0 = size(magnitude,1)/2;
    rho=drho*(rhoidxacc-1)-M;
    the=dtheta*(thetaidxacc-1)-N;
    y0 = (rho-x0*cos(the))/sin(the);
    dx = size(magnitude,1);
    dy =-cos(the)/sin(the)*dx;
    
    linepar(1, 4*(idx-1) + 1) = 0; % level, not significant
    linepar(2, 4*(idx-1) + 1) = 3; % number of points in the curve
    linepar(2, 4*(idx-1) + 2) = x0-dx;
    linepar(1, 4*(idx-1) + 2) = y0-dy;
    linepar(2, 4*(idx-1) + 3) = x0;
    linepar(1, 4*(idx-1) + 3) = y0;
    linepar(2, 4*(idx-1) + 4) = x0+dx;
    linepar(1, 4*(idx-1) + 4) = y0+dy;
    
    if ( verbose >= 2)
        subplot(1,3,2);hold on;
        plot(thetaidxacc,rhoidxacc,'rx');
        hold off;
    end
end

% Overlay these curves on the gradient magnitude image
if ( verbose >= 1)
    if ( verbose >= 2 )
        subplot(1,3,3);
    else
        figure;
    end
    overlaycurves(image,linepar);
    title('$Hough\:lines$','Interpreter','latex')
end


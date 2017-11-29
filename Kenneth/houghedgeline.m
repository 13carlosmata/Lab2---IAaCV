function [linepar, acc] = houghedgeline(pic, scale, gradmagnthreshold, nrho, ntheta, nlines, n_smooth, verbose)

% VERBOSE = 0 : Only the edge curves
%           1 : Show the edge curves and hough space
%           2 : Show the edge curves, hough space and the hough edge lines

edgecurves = extractedge(pic, scale, gradmagnthreshold, 'same');

threshold = gradmagnthreshold;
magnitude = pic;

if (verbose==2)
    subplot(1,3,3);
end
[linepar, acc] = houghline(edgecurves,magnitude,nrho,ntheta,threshold,nlines,n_smooth,(verbose==2));
axis('image');

subplot(1,verbose+1,1); overlaycurves(pic, edgecurves); title('Extraction of edges');
if (verbose > 0)
    subplot(1,verbose+1,2); showgrey(acc); title('Hough space');
end

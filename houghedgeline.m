function [linepar, acc] = houghedgeline(pic, scale, gradmagnthreshold, nrho, ntheta, nlines, verbose)

edgecurves = extractedge(pic, scale, gradmagnthreshold, 'same');

threshold = gradmagnthreshold;
magnitude = pic;
figure
if (verbose==2)
    subplot(1,3,3);
end
[linepar, acc] = houghline(edgecurves,magnitude,nrho,ntheta,threshold,nlines,verbose);
axis('image');

subplot(1,verbose+1,1); overlaycurves(pic, edgecurves); title('Extraction of edges');
if (verbose > 0)
    subplot(1,verbose+1,2); showgrey(acc); title('Hough space');
end

end
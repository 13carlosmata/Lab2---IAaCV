%{
Lab Exercise 2 - Image Analysis and Computer Vision
Editors:
    Carlos Mata
    Kenneth Lau
%}
close all
clear all
clc
addpath('DD2423_Lab_Files/Images-m');
addpath('DD2423_Lab_Files/Functions');

%% Question 1 and 2     

res_few = main_sections(few256,'few256');
res_godthem = main_sections(godthem256,'godthem256');
res_godthem_gauss = Lv(gaussfft(godthem256,1),'valid');

%% Question 3           
figure;
subplot(1,2,1); showgrey(res_godthem);
subplot(1,2,2); showgrey(res_godthem_gauss);
suptitle('Smoothing image with a Gaussian Filter - after') 

%% Question 4           

[x,y]  = meshgrid(-5:5, -5:5);
[dxmask,dymask] = central_diff(1);
[dxxmask,dyymask] = central_diff(2);

dxxxmask = conv2(dxmask, dxxmask, 'same');
dxymask  = conv2(dxmask, dymask, 'same');
dxxymask = conv2(dxxmask,dymask, 'same');

res_1 = filter2(dxxxmask, x .^3, 'valid');
res_2 = filter2(dxxmask, x .^3, 'valid');
res_3 = filter2(dxxymask, x .^2 .* y, 'valid');

house = godthem256;
scale = [0.0001,1.0,4.0,16.0,64.0];

figure;
subplot(2,3,1);
showgrey(house);
title('Original');
for i=1:size(scale,2)
    subplot(2,3,i+1);
    contour(Lvvtilde(gaussfft(house, scale(i)), 'same'), [0 0]);
    axis('image');    axis('ij');  
    title(['Scale = ',int2str(scale(i))])
end

%% Question 5 and 6         
tools = few256;
figure
subplot(2,3,1);
showgrey(tools);
title('Original');
for i=1:size(scale,2)
    subplot(2,3,i+1);
    showgrey(Lvvvtilde(gaussfft(tools, scale(i)), 'same') < 0)
    axis('image');    axis('ij');  
    title(['Scale = ',int2str(scale(i))])
end


%% Question 7       

threshold = [1,10,50,70,100];
subplot(5,6,1);
showgrey(house);
title('Original');
cont=1;
for i=1:size(threshold,2)
    for j =1:size(scale,2)
        cont=cont+1;
        subplot(5,6,cont);
        edgecurves = extractedge(house, scale(j), threshold(i), 'same');
        overlaycurves(house,edgecurves);
        title(['Scale = ',int2str(scale(j)), '  TH =',int2str(threshold(i))]);
    end
    cont=cont+1;
end
fprintf("done thresholds + Scales \n");
                                        
% Best Fits
figure
subplot(1,3,1); 
edgecurves = extractedge(house, 30, 10, 'same');    overlaycurves(house,edgecurves);
title(['Scale = ',int2str(30), '  TH =',int2str(10)]);

subplot(1,3,2); 
edgecurves = extractedge(house, 4, 100, 'same');   overlaycurves(house,edgecurves);
title(['Scale = ',int2str(4), '  TH =',int2str(100)]);

subplot(1,3,3); 
edgecurves = extractedge(house, 10, 100, 'same');    overlaycurves(house,edgecurves);
title(['Scale = ',int2str(10), '  TH =',int2str(100)]);
suptitle('Best Fits')
 
%%  HOUGH Trasnform

testimage1 = triangle128;
smalltest1 = binsubsample(testimage1);
testimage2 = houghtest256;
smalltest2 = binsubsample(binsubsample(testimage2));

testimage = testimage2;

magnitude = testimage;
nrho = size(magnitude,1);
ntheta = size(magnitude,2);
threshold = 6;
scale = 7;
nlines = 10;
verbose = 0;

curves = extractedge(testimage, scale, threshold, 'same');
%overlaycurves(testimage,curves);

[linepar, acc] = houghline(curves, magnitude,nrho, ntheta, threshold, nlines);

%houghedgeline(testimage, scale, threshold, nrho, ntheta, nlines,0);
%% 



function res = main_sections (image, name)
tools = image;
res = 1;
dxtools_sobel = conv2(tools, deltax("sobel"), 'valid');
dytools_sobel = conv2(tools, deltay("sobel"), 'valid');
dxtools_roberts = conv2(tools, deltax("roberts"), 'valid');
dytools_roberts = conv2(tools, deltay("roberts"), 'valid');
dxtools_central = conv2(tools, deltax("central"), 'valid');
dytools_central = conv2(tools, deltay("central"), 'valid');


figure;
subplot(3,3,1);showgrey(tools); title(name)
subplot(3,3,2); showgrey(dxtools_sobel); title("dx with Sobel operator")
subplot(3,3,3); showgrey(dytools_sobel); title("dy with Sobel operator")
subplot(3,3,5); showgrey(dxtools_roberts); title("dx with Robert's operator")
subplot(3,3,6); showgrey(dytools_roberts); title("dy with Robert's operator")
subplot(3,3,8); showgrey(dxtools_central); title("dx with Central differences")
subplot(3,3,9); showgrey(dytools_central); title("dy with Central differences")

%Point-wise thresholding of gradient magnitudes
%Using sobel operator
dxtoolsconv = dxtools_sobel;
dytoolsconv = dytools_sobel;

gradmagntools = sqrt(dxtoolsconv .^2 + dytoolsconv.^2);
fprintf("Using image: ", name);
fprintf('Values for grandmagntools: \n');
fprintf(' %f',gradmagntools); fprintf('\n');
res = gradmagntools;
figure
subplot(1,4,1); 
histogram(gradmagntools);
title('Histogram of the gradient magnitude');
%threshold = graythresh(gradmagntools)*100; 
threshold_high = 110;
threshold_low = 15;
subplot(1,4,2);
showgrey(gradmagntools);
title('Gradient Magnitude of the Image')

subplot(1,4,3);
showgrey((gradmagntools - threshold_high) > 0);
title(['Thresholded image with th = ', int2str(threshold_high)]);

subplot(1,4,4);
showgrey((gradmagntools - threshold_low) > 0);
title(['Thresholded image with th = ', int2str(threshold_low)]);
end





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


%{
%%      Difference Operators
tools = few256;

dxtools_sobel = conv2(tools, deltax("sobel"), 'valid');
dytools_sobel = conv2(tools, deltay("sobel"), 'valid');
dxtools_roberts = conv2(tools, deltax("roberts"), 'valid');
dytools_roberts = conv2(tools, deltay("roberts"), 'valid');

figure;
subplot(2,3,1);showgrey(tools); title("few256")
subplot(2,3,2); showgrey(dxtools_sobel); title("dxtools with Sobel operator")
subplot(2,3,3); showgrey(dytools_sobel); title("dytools with Sobel operator")
subplot(2,3,5); showgrey(dxtools_roberts); title("dxtools with Robert's operator")
subplot(2,3,6); showgrey(dytools_roberts); title("dytools with Robert's operator")

%%      Point-wise thresholding of gradient magnitudes
%Using sobel operator
dxtoolsconv = dxtools_sobel;
dytoolsconv = dytools_sobel;

gradmagntools = sqrt(dxtoolsconv .^2 + dytoolsconv.^2);

fprintf('Values for grandmagntools: \n');
fprintf(' %f',gradmagntools); fprintf('\n');

figure
subplot(1,3,1); 
histogram(gradmagntools);
title('Histogram of the gradient magnitude');
threshold = graythresh(gradmagntools)*100; 

subplot(1,3,2);
showgrey(gradmagntools);
title('Gradient Magnitude of the Image')

subplot(1,3,3);
showgrey((gradmagntools - threshold) > 0);
title(['Thresholded image with th = ', int2str(threshold)]);
suptitle('Study done with image few256');
%}

%%
res_few = main_sections(few256,'few256');
res_godthem = main_sections(godthem256,'godthem256');
res_godthem_gauss = gaussfft(Lv(godthem256,'valid'),0.2);

figure;
showgrey(res_godthem_gauss)
title("Smoothing image with a Gaussian Filter")



%%

function res = main_sections (image, name)
tools = image;
res = 1;
dxtools_sobel = conv2(tools, deltax("sobel"), 'valid');
dytools_sobel = conv2(tools, deltay("sobel"), 'valid');
dxtools_roberts = conv2(tools, deltax("roberts"), 'valid');
dytools_roberts = conv2(tools, deltay("roberts"), 'valid');

figure;
subplot(2,3,1);showgrey(tools); title(name)
subplot(2,3,2); showgrey(dxtools_sobel); title("dxtools with Sobel operator")
subplot(2,3,3); showgrey(dytools_sobel); title("dytools with Sobel operator")
subplot(2,3,5); showgrey(dxtools_roberts); title("dxtools with Robert's operator")
subplot(2,3,6); showgrey(dytools_roberts); title("dytools with Robert's operator")

%%      Point-wise thresholding of gradient magnitudes

%Using sobel operator
dxtoolsconv = dxtools_sobel;
dytoolsconv = dytools_sobel;

gradmagntools = sqrt(dxtoolsconv .^2 + dytoolsconv.^2);
fprintf("Using image: ", name);
fprintf('Values for grandmagntools: \n');
fprintf(' %f',gradmagntools); fprintf('\n');

figure
subplot(1,3,1); 
histogram(gradmagntools);
title('Histogram of the gradient magnitude');
threshold = graythresh(gradmagntools)*100; 

subplot(1,3,2);
showgrey(gradmagntools);
title('Gradient Magnitude of the Image')

subplot(1,3,3);
showgrey((gradmagntools - threshold) > 0);
title(['Thresholded image with th = ', int2str(threshold)]);
suptitle(['Study done with image: ', name]);

end





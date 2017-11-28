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
res_godthem_gauss = gaussfft(Lv(godthem256,'valid'),1);
res_godthem_gauss_b = Lv(gaussfft(godthem256,1),'valid');


figure;
subplot(1,2,1); showgrey(res_godthem_gauss);
subplot(1,2,2); showgrey(res_godthem_gauss_b);
suptitle('Smoothing image with a Gaussian Filter - after')

%%     Computing differential geometry descriptors

%               -> Question 4


[x,y]  = meshgrid(-5:5, -5:5);
[dxmask,dymask] = central_diff(1);
[dxxmask,dyymask] = central_diff(2);

dxxxmask = conv2(dxmask, dxxmask, 'same');
dxymask  = conv2(dxmask, dymask, 'same');
dxxymask = conv2(dxxmask,dymask, 'same');

res_1 = filter2(dxxxmask, x .^3, 'valid');
res_2 = filter2(dxxmask, x .^3, 'valid');
res_3 = filter2(dxxymask, x .^2 .* y, 'valid');

disp("Subcomponents - done - CHECK")

house = godthem256;
scales = [0.0001,1.0,4.0,16.0,64.0];
figure;
subplot(1,6,1);
showgrey(house);
title('Original');
for i=1:size(scales,2)
    subplot(1,6,i+1);
    contour(Lvvtilde(gaussfft(house, scales(i)), 'same'), [0 0]);
    axis('image');    axis('ij');  
    title(['Scale = ',int2str(scales(i))])
end


%%              -> Question  5
tools = few256;
figure
subplot(1,6,1);
showgrey(tools);
title('Original');
for i=1:size(scales,2)
    subplot(1,6,i+1);
    showgrey(Lvvvtilde(gaussfft(tools, scales(i)), 'same') < 0)
    axis('image');    axis('ij');  
    title(['Scale = ',int2str(scales(i))])
end


%% Extraction of edge segments

thresholds = [1,10,50,70,100];
figure
subplot(5,6,1);
showgrey(house);
title('Original');
cont=1;
for i=1:size(thresholds,2)
    for j =1:size(scales,2)
        cont=cont+1;
        subplot(5,6,cont);
        edgecurves = extractedge(house, scales(i), thresholds(j), 'same');
        overlaycurves(house,edgecurves);
        title(['Scale = ',int2str(scales(j)), '  TH =',int2str(thresholds(i))]);
    end
    cont=cont+1;
end
print("done")



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





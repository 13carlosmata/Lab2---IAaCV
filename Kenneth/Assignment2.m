%{
Kenneth Lau K.W.- Lab1 
Image Analysis and Computer Vision - DD2423
Edge Detection & Hough Transform
%}

addpath('../../DD2423_Lab_Files/Functions');
addpath('../../DD2423_Lab_Files/Images-m');

close all;


%%  1 Difference operators
%   Question 1 Difference operators
tools = few256;

[deltax, deltay] = grad_op(1);

dxtools = conv2(tools, deltax, 'valid');
dytools = conv2(tools, deltay, 'valid');

figure;
subplot(1,3,2); showgrey(dxtools); title('Gradient in x direction');
subplot(1,3,3); showgrey(dytools); title('Gradient in y direction');
subplot(1,3,1); showgrey(tools); title('Original');
suptitle('Difference operator - Central Differences Operator')
pause

%% 2 Point?wise thresholding of gradient magnitudes
%  Question 2 & 3 Point-wise thresholding
close all;
gradmagntools = sqrt(dxtools .^2 + dytools .^2);

% Set the threshold
threshold = [10,20,30,40];
figure
showgrey(gradmagntools); title('Magnitude of the gradients');
pause
histogram(gradmagntools); title('Histogram');
pause
for i = 1:1:length(threshold)
    subplot(2,2,i); showgrey((gradmagntools - threshold(i)) > 0);
    title(['Threshold =',num2str(threshold(i))]);
end
pause

img = godthem256;
dximg = conv2(img, deltax, 'valid');
dyimg = conv2(img, deltay, 'valid');
gradmagnimg = sqrt(dximg .^2 + dyimg .^2);
smoothed_gradmagnimg = Lv(gaussfft(img,1), 'valid');

threshold = 10;
subplot(2,3,1); showgrey(gradmagnimg); title('Magnitude of the gradients (Without smoothing)');
subplot(2,3,2); histogram(gradmagnimg); title('Histogram');
subplot(2,3,3); showgrey((gradmagnimg - threshold) > 0); title(['Threshold =',num2str(threshold)]);
subplot(2,3,4); showgrey(smoothed_gradmagnimg); title('Magnitude of the gradients (Smoothed)');
subplot(2,3,5); histogram(smoothed_gradmagnimg); title('Histogram');
subplot(2,3,6); showgrey((smoothed_gradmagnimg - threshold) > 0); title(['Threshold =',num2str(threshold)]);
pause

%% 4 Computing differential geometry descriptors
%  Question 4

%{
% Testing for the approximation of higher order derivatives
[x, y] = meshgrid(-5:5, -5:5);
[dxmask, dymask] = grad_op(1);
[dxxmask, dyymask] = grad_op(2);
dxymask = conv2(dxmask, dymask, 'same');
dxxxmask = conv2(dxmask, dxxmask, 'same');
dxxymask = conv2(dxxmask, dymask, 'same');

a = x.^3;
a1 = filter2(dxxxmask, x .^3, 'valid');
a2 = filter2(dxxmask, x .^3, 'valid');
a3 = filter2(dxxymask, x .^2 .* y, 'valid');
%}
house = godthem256;
scale = [0.1,1.0,4.0,16.0,64.0];
subplot(2,3,1); showgrey(house); title('Original Image');

for i = 1:1:length(scale)
    subplot(2,3,i+1); 
    contour(Lvvtilde(gaussfft(house, scale(i)), 'same'), [0, 0]);
    axis('image'); axis('ij'); title(['Scale = ',num2str(scale(i))]);
end
pause

% Question 5
tools = few256;
scale = [0.1,1.0,4.0,16.0,64.0];
subplot(2,3,1); showgrey(tools); title('Original Image');
for i = 1:1:length(scale)
    subplot(2,3,i+1);
    showgrey(Lvvvtilde(gaussfft(tools, scale(i)), 'same') < 0)
    axis('image'); axis('ij'); title(['Scale = ',num2str(scale(i))]);
end
pause

%% 5 Extraction of edge segments
% Question 7 Find the best results for extractedge
tools = few256;
house = godthem256;
scale = [0.0001,1.0,4.0,16.0,64.0];
threshold = [200,70,20,5,1];
shape = 'same';

figure
subplot(2,3,1); showgrey(tools); title('Original Image');
for i = 1:1:length(scale)
    subplot(2,3,i+1);
    edgecurves = extractedge(tools, scale(i), threshold(i), shape);
    overlaycurves(tools, edgecurves);
    title(['Scale = ',num2str(scale(i)),'; threshold = ',num2str(threshold(i))]);
end
pause

figure
subplot(2,3,1); showgrey(house); title('Original Image');
for i = 1:1:length(scale)
    subplot(2,3,i+1);
    edgecurves = extractedge(house, scale(i), threshold(i), shape);
    overlaycurves(house, edgecurves);
    title(['Scale = ',num2str(scale(i)),'; threshold = ',num2str(threshold(i))]);
end

%% 6 Hough transform




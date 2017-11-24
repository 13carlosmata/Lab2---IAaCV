close all
clc
addpath('DD2423_Lab_Files/Images-m')
addpath('DD2423_Lab_Files/Functions')

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


disp("done");
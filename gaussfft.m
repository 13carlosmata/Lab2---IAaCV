function F = gaussfft(pic,t)
conv_pic = fft2(pic);
[x,y] = size(conv_pic);
[new_x, new_y] = meshgrid(-x/2:(x/2)-1, -y/2:(y/2)-1);


gauss = (1/(2*pi*t)) * exp(-(new_x.^2+new_y.^2)/(2*t)); 
%size(gauss), size(conv_pic)
G = fft2(gauss).*conv_pic;

H = ifft2(G);
F = fftshift(H);
end

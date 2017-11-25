function F = gaussfft(pic,t)

[dim_x, dim_y] = size(pic);
[x, y] =  meshgrid(-dim_x/2:(dim_x/2)-1, -dim_y/2:(dim_y/2)-1);
gauss = (1/(2*pi*t)) * exp(-(x.^2+y.^2)/(2*t)); 

G = fft2(gauss).*fft2(pic);

H = ifft2(G);
F = fftshift(H);
end
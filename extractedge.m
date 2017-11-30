function edgecurves = extractedge(inpic, scale, threshold, shape)

if nargin ~= 4
    threshold = 0;
    shape =  'same';
end

Lvi   = Lv(gaussfft(inpic,scale),shape);
Lvv  = Lvvtilde(gaussfft(inpic, scale), shape);
Lvvv = Lvvvtilde(gaussfft(inpic, scale), shape); 
curves_zeros = zerocrosscurves(Lvv, (Lvvv<0)-1);
edgecurves = thresholdcurves(curves_zeros, (Lvi>threshold));

end

function edgecurves = extractedge(inpic, scale, threshold, shape)

if (nargin < 3)
    threshold = 0;
end
if (nargin < 4)
    shape = 'same';
end

lv      = Lv(discgaussfft(inpic,scale), shape);
lvv     = Lvvtilde(gaussfft(inpic, scale), shape);
lvvv    = Lvvvtilde(gaussfft(inpic, scale), shape);

curves  = zerocrosscurves(lvv,(lvvv < 0)-1);
edgecurves = thresholdcurves(curves, (lv>threshold)-1);

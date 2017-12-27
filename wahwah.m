% BP filter with narrow pass band, Fc oscillates up and down the spectrum

function wah = wahwah(y, wahfreq, sampfreq,rate)

%limits of cutoff frequency for variable BP filt
minfreq=100;
maxfreq=6000;

% change in center frequency per sample (Hz)
% delta=0.1 => at 44100 samples per second should mean  4.41kHz Fc shift per sec
delta = rate*wahfreq/sampfreq;

% create triangle wave of center frequency values
centerfreq = minfreq:delta:maxfreq;

while(length(centerfreq) < length(y) )
    centerfreq = [ centerfreq (maxfreq:-delta:minfreq) ];
    centerfreq = [ centerfreq (minfreq:delta:maxfreq) ];
end

% trim to size of input
centerfreq = centerfreq(1:length(y));

centerfreqcoeffs = 2*sin((pi*centerfreq(1))/sampfreq);  % must be recalculated each time center frequency changes

Qfactor = 2*.25;              

yhighpass=zeros(size(y));       
ybandpass=zeros(size(y));
ylowpass=zeros(size(y));

yhighpass(1) = y(1); % first sample, to avoid referencing of negative signals
ybandpass(1) = centerfreqcoeffs*yhighpass(1);
ylowpass(1) = centerfreqcoeffs*ybandpass(1);

% apply difference equation to the samples
for n=2:length(y)
    yhighpass(n) = y(n) - ylowpass(n-1) - Qfactor*ybandpass(n-1);
    ybandpass(n) = centerfreqcoeffs*yhighpass(n) + ybandpass(n-1);
    ylowpass(n) = centerfreqcoeffs*ybandpass(n) + ylowpass(n-1);

    centerfreqcoeffs = 2*sin((pi*centerfreq(n))/sampfreq);
end
wah = ybandpass;

%sound(wah,sampfreq);
end

% function [g,fr,Q] = wahcontrols(wah)
% g  = 0.1*4^wah;       % overall gain
% fr = 450*2^(2.3*wah); % resonance frequency
% Q  = 2^(2*(1-wah)+1); % resonance quality factor 
% end
function [ int, lag ] = xcorrraw( sig1, sig2 )
%XCORRRAW normalizes 2 vectors of data and compute the cross-correlation
%between them
%   [ int, lag ] = xcorrraw( sig1, sig2 )
sig1 = xcorrprep(sig1);
sig2 = xcorrprep(sig2);

[int , lag] = xcorr(sig1, sig2);

plot(lag, int);

end


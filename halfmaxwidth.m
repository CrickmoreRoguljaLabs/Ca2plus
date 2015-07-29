function [ hmw ] = halfmaxwidth( sig )
%halfmaxwidth finds the half mas width of the signal. It assumes that the
%baseline is zero.
%   [ hmw ] = halfmaxwidth( sig )

% Find he value and index of the max value of the signal
[maxval , maxind] = max(sig);

halfmax = maxval / 2;

% Find the left arm point
leftarm = find(sig(1:maxind)<halfmax);
leftarm = leftarm(end);

% Find the right arm point
rightarm = find(sig(maxind:end)<halfmax);
rightarm = rightarm(1);

% Generate width
hmw = rightarm - leftarm + maxind -1;

end


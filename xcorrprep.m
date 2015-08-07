function [ sig_preped ] = xcorrprep( sig )
%XCORRPREP prepares a vector by normalizing it and subtracting the mean so
%the resulting vector can be fed to xcorr.
%   [ sig_preped ] = xcorrprep( sig )

sig = mat2gray(sig);
sig_preped = sig - mean(sig);


end


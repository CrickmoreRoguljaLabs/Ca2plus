function [ xcorrmat ] = sigxcorr( ind )
%SIGXCORR computest the crosscorrelation between an input signal and the
%rest and display the results as scaled image.
%   sigxcorr( input_vector_number )

% Input the following variables directly from base
final_cell_sig = evalin('base','final_cell_sig');

% Obrain and scale the signal to be compared
s1 = final_cell_sig(ind , :);
s1 = mat2gray(s1);
s1 = s1 - mean(s1);

% Temporary - Remove the first 100 frames
s1 = s1(101:end);

% Obtain the numbers of signals and frames
[n_sig , nframes] = size(final_cell_sig);

% Reult matrix
xcorrmat = zeros(n_sig, (nframes-100) * 2 -1);


for i = 1 : n_sig    
    % Obtain and scale signal 2
    s2 = final_cell_sig(i,:);
    s2 = mat2gray(s2);
    s2 = s2 - mean(s2);
    
    % Temporary - remove the first 100 frames of s2
    s2 = s2(101:end);
    
    % Find the cross correlation  
    crosscorr = xcorr(s1, s2);
    xcorrmat(i,:) = crosscorr / std(crosscorr);


end

figure;

imagesc(xcorrmat);

% Find and change x labels

xlabels = get(gca, 'XTickLabel');

xlabels = str2num(xlabels); %#ok<ST2NM>

xlabels = xlabels - nframes + 100;

set(gca,'XTickLabel', num2str(xlabels));

end


% Input which filters to combine
filters2choose = input('Which filters to be combined? ');

% Apply filter to other image stacks

% Label batch processing and read the batch processing parameter file 
settings_file = importdata('cal2plus_settings.csv');

% General path of videos
genvidpath = settings_file{1};
genvidpath = genvidpath(strfind(genvidpath, ',')+1:end);

% Obtain the video file
[fn2, vidpath]  =  uigetfile(genvidpath); % This address should be changed according to the user

% The full name of the video
fn_full2 = fullfile(vidpath,fn2);

% Determine how many frames the video has
n_frames = length(imfinfo(fn_full2));

% Prime the signal matrix (first column represent the size of the filters)
sig2 = zeros(1, n_frames + 1);

% Combine the filters
synsfilter = max(final_cell_segments(:,:,filters2choose),[],3);

% Get new signal

% Get filter size
sig2(1) = sum(synsfilter(:));

% Get filter signal
sig2(2:end) = CellsortApplyFilter2(fn_full2, synsfilter,...
    0 ,fn2)'/sig2(1);

% Plot
figure('Name',fn2)
plot((sig2(:,2:end)./ repmat(sig2(:,2), [1 n_frames]))')
legend('toggle')

ylim([0.9 1.2])
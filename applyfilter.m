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
sig2 = zeros(size(final_cell_segments, 3), n_frames + 1);

% Get new signal
for i = 1 : size(final_cell_segments, 3)
    % Get filter size
    sig2(i, 1) = sum(sum(final_cell_segments(:,:,i)));
    
    % Get filter signal
    sig2(i,2:end) = CellsortApplyFilter2(fn_full2, final_cell_segments(:,:,i),...
        0 ,fn2)/sig2(i, 1);
    
    % Smooth signal (just for now)
    sig2(i,2:end) = smooth(sig2(i,2:end), 3);
end
%%
% Plot
figure('Name',fn2)
plot((sig2(:,2:end)./ repmat(sig2(:,24), [1 n_frames]))')
legend('toggle')
ylim([0 4])
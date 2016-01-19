%% 0. Pre-cropping
% Used to crop videos that have large used space

% Label batch processing and read the batch processing parameter file 
settings_file = importdata('cal2plus_settings.csv');

% General path of videos
genvidpath = settings_file{1};
genvidpath = genvidpath(strfind(genvidpath, ',')+1:end);

% Obtain the video file
[fn, vidpath]  =  uigetfile(genvidpath); % This address should be changed according to the user

% The full name of the video
fn_full = fullfile(vidpath,fn);

% Readout the first frame
sampleframe = imread(fn_full,1);

% Determine if acquiring or applying cropping parameters
recrop = 0;

if exist('cropindices3','var')
    recrop = input('Re-calculating cropping parameters? (1 = yes, 0 = no) = ');
end

% Re-crop if necessary
if ~exist('cropindices3','var') || recrop == 1
    % Manually select ROI
    disp('Cropping...')
    [sampleframe_cr, cropindices] = imcrop(mat2gray(sampleframe));
    cropindices = floor(cropindices);
    close(gcf)

    % Turn the crop indices into a usable form
    cropindices2 = cropindices(2):cropindices(2)+cropindices(4);
    cropindices3 = cropindices(1):cropindices(1)+cropindices(3);
end

% Determine how many frames the video has
n_frames = length(imfinfo(fn_full));

% Loop through the stack
for i = 1 : n_frames
    % Read
    im = imread(fn_full,i);
    
    % Apply cropping
    im2 = im(cropindices2, cropindices3);
    
    % Write image
    imwrite(im2,fullfile(vidpath,fullfile([fn(1:end-4),'_cropped.tif'])),...
        'tif','WriteMode','append');
end


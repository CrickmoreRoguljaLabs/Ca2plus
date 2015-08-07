function map = xcorrfinder(intensityvec, shrinkfraction)
% xcorrfinder finds the pixels in a movie that have the best cross 
% correlation.The goodness of the cross correlation is evaluated by the
% sharpness of the the cross-correlation curve, which is calculated by the
% miminal value of the 2nd derivative. This version uses parallele
% processing toolbox.
% map = xcorrfinder(intensityvec, shrinkfraction)

% Default shrink to 30%, which corresponds to ~45 processing time for a 300
% frame stack (640 x 384).
if nargin < 2
    shrinkfraction = 0.3;
end

% Get this variable directly from the base workspace
fn = evalin('base','fn');

frames = length(intensityvec);

% Normalize the intensityvec and subtract its mean

intensityvec = mat2gray(intensityvec);

intensityvec = intensityvec - mean(intensityvec);

% Load the sample image
sampleim = imread(fn, 1);

% Prime the stack from the sample image
stack = repmat(sampleim, [1 1 frames]);

% Everyone likes waitbar
hwait = waitbar(0, 'Reading stack');
 
% Load the stack in to RAM
 for i = 2: frames
     
     waitbar(i/frames);
         
     stack(:,:,i) = imread(fn, i);
 end
 
 close(hwait)
 
%% Resize the image if necessary
% Resize the stack to shorten processing time
stack2 = imresize(stack, shrinkfraction);

%% Find correlation map

% Prime the map matrices
map_2dr = double(stack2(:,:,1));
map_hmw = map_2dr;
map_max = map_2dr;


% Prime the waitbar
% hwait = waitbar(0, 'Processing');

% Find out how many rows and columns to be processed
nrow = size(stack2, 1);
ncol = size(stack2, 2);

% Calculate the number of pixels
n_pixels = nrow*ncol;

% For each row, process the pixels of each column
parfor ind = 1 : n_pixels

        % Find the row number of the pixel
        i = mod(ind, nrow);
        
        if i == 0
            i = nrow;
        end
        
        j = ceil(ind/nrow);

        % Find the signal of the pixel and normalize it
        sig = mat2gray(squeeze(stack2(i,j,:))); %#ok<PFBNS>
       
        % subtract the min from the normalized signal
        sig = sig - mean(sig);
        
        % Find the correlation coefficient
        [corrvec, ~] = xcorr(intensityvec , sig);
        
        % Find the 2nd derivative of the cross correlation vector to
        % evaluate the sharpness of the peak
        corrder = diff(diff(corrvec));
        
        % Find the minimal 2nd derivative of the cross correlation vector,
        % normalized to std, as an indicator of the peak sharpness
        map_2dr(ind) = min(corrder(frames-50:frames+50))/std(corrder([1:...
            frames-50 , frames+50:end]));
        
        % Find the absolute max value
        map_max(ind) = max(corrvec(frames-50:frames+50));
        
        % Find the half-max width of the cross correlation vector.
        map_hmw(ind) = halfmaxwidth(corrvec);
               
        
    % imshow(map,[])
    
end

% Combine the maps
map = repmat(map_2dr, [1 1 3]);
map(:,:,2) = map_hmw;
map(:,:,3) = map_max;
% close(hwait)

end
function map = corrfinder(intensityvec, shrinkfraction)
% corrfinder finds the pixels in a movie that have the best correlation.
% with a input vector. A shrink fraction is added to resize the stack to
% accelerate processing.
% map = corrfinder(intensityvec, fn, shrinkfraction)

% Default shrink to 30%, which corresponds to ~45 processing time for a 300
% frame stack (640 x 384).
if nargin < 2
    shrinkfraction = 0.3;
end

% Get this variable directly from the base workspace
fn = evalin('fn','fn');

frames = length(intensityvec);

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

% Prime the map matrix
map = double(stack2(:,:,1));

% Prime the waitbar
hwait = waitbar(0, 'Processing');

% Find out how many rows and columns to be processed
nrow = size(stack2, 1);

ncol = size(stack2, 2);

% For each row, process the pixels of each column
for i = 1 : nrow

    for j = 1 : ncol
        
        % Update waitbar
        waitbar((i*ncol + j)/nrow/ncol);
        
        % Find the signal of the pixel
        sig = squeeze(stack2(i,j,:));
        
        % Find the correlation coefficient
        coefmat = corrcoef(mat2gray(intensityvec) , mat2gray(sig));
        
        % Enter the coefficient to the map
        map(i,j) = coefmat(2,1);
    end
    
    % imshow(map,[])
    
end

close(hwait)

%% Output the RGB for view

% Prime the RGB matrix
rgb = repmat(mat2gray(imresize(sampleim,shrinkfraction)), [ 1 1 3]);

% Use the red channel to display the map
rgb(:,:,1) = map;

% Set blue channel to 0
rgb(:,:,3) = 0;

% Show RGB
imshow(rgb,[])

end
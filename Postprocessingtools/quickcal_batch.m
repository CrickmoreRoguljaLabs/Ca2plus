% Get the folder directory
[~, pathname] = uigetfile('C:\Users\Stephen Zhang\Desktop\New folder\.tif');
addpath(pathname)

% Get the list of the tif files in the folder
contents = dir(fullfile(pathname,'*.tif'));

% Get the file names
filenames = {contents.name}';

% Count the number of files
nfiles = length(filenames);

% Prime the vectors
SMPa = zeros(nfiles,100);
% MB = zeros(nfiles,100);
%% Obtain ROI and ROI drifting

% Determine the name of the source file
fn_full = fullfile(pathname,filenames{1});

% Obtain image and draw ROI
initialim = imread(fn_full,25) * 10;
userpoly_SMPa = getpoly(mat2gray(initialim)*10,[filenames{1},'-SMPa']);

% Obtain the last image in the experiment
finalim = imread(fullfile(pathname,filenames{nfiles}),34) * 4;

% Calculate the stack to show
stack2show = 4 * repmat(mat2gray(finalim), [1 1 3]);
stack2show(:,:,3) = 0;
stack2show(:,:,1) = mat2gray(userpoly_SMPa)/2;
stack2show = min(stack2show, 1);

% initialize drifting
figure(101);
h1 = imshow(stack2show);
set(101, 'Position', [0 50 1200 600])

% set satisfy to 0 and drifting vector to 0
satis = 0;
driftvec = [0 0];

while satis < 1
    satis = input('Satisfied? yes = 1, no = 0: ');
    
    if satis < 1
        % Input drifting vector
        driftvec = input('Drifting vector = ? (e.g. [20 -10]): ');
        
        % shift the ROI according to the drifting vector
        stack2show(:,:,1) = mat2gray(imshift(driftvec, userpoly_SMPa))/2;
        
        % Update the image
        set(h1, 'CData', stack2show);
    end
    
    
end
close(101)


%% Batch calculation

for i = 1 : nfiles
    % Determine the name of the source file
    fn_full = fullfile(pathname,filenames{i});
    
    % initialim = imread(fn_full,35) * 2;
    % userpoly_SMPa = getpoly(mat2gray(initialim),[filenames{i},'-SMPa']);
    % userpoly_MB = getpoly(mat2gray(initialim),[filenames{i},'-MB']);
    
    % area_SMPa = sum(userpoly_SMPa(:));
    % area_MB = sum(userpoly_MB(:));
    
    % Calculate drifting
    userpoly_SMPa_new = imshift(driftvec / (nfiles - 1) * (i - 1), userpoly_SMPa);
    
    % Get the number of frames
    n_frames = length(imfinfo(fn_full));
    
    for j=1:n_frames
        tempim = imread(fn_full,j);
        SMPa(i,j) = mean(tempim(userpoly_SMPa_new));
        % MB(i,j) = mean(tempim(userpoly_MB));
    end
end

%% Normalize
B=(SMPa./repmat(SMPa(:,24),[1, 100]))';
C=reshape(B,[100,2,6]);
C = squeeze(mean(C,2));

plot(C)
set(gca,'yLim',[0.5 2])

save([fn_full(1:end-20),'_analyzed.mat'])

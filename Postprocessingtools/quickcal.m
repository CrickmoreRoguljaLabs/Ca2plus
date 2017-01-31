[filename, pathname] = uigetfile('C:\Users\steph\Desktop\2016-12-28-100DA\*.tif','MultiSelect','on');
addpath(pathname)

n_files = size(filename,2);

if ischar(filename)
    currentfilename = filename;
    
else
    currentfilename = filename{1};
end

fn_full = fullfile(pathname,currentfilename);

initialim = imread(fn_full,28);
%imshow(mat2gray(initialim))

userpoly = getpoly(mat2gray(initialim)*4);

% area = sum(userpoly(:));

n_frames = length(imfinfo(fn_full));

intensityvec = zeros(n_frames,n_files);

for j = 1:n_files
    if ischar(filename)
        currentfilename = filename;
    else
        currentfilename = filename{j};
    end
    
    fn_full = fullfile(pathname,currentfilename);
    
    for i=1:n_frames
        tempim = imread(fn_full,i);
        intensityvec(i,j) = mean(tempim(userpoly));
    end
end

stimstart = 24;

% [~, stimstart] = min(diff(intensityvec));

% intensityvec_n = intensityvec./repmat(intensityvec(stimstart,:),[n_frames,1]);

intensityvec_n = intensityvec/intensityvec(24,1);

plot(1:n_frames,intensityvec_n)

% plotyy(1:n_frames,intensityvec,1:n_frames,intensityvec_n)

ylim([0.5 3])
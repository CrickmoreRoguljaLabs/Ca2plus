[filename, pathname] = uigetfile('C:\Users\Stephen Zhang\Desktop\New folder\*.tif');
addpath(pathname)
fn_full = fullfile(pathname,filename);

initialim = imread(fn_full,30);
%imshow(mat2gray(initialim))

userpoly = getpoly(mat2gray(initialim)*2);

area = sum(userpoly(:));

n_frames = length(imfinfo(fn_full));

intensityvec = zeros(n_frames,1);

for i=1:n_frames
    tempim = imread(fn_full,i);
    intensityvec(i) = mean(tempim(userpoly));
end

[~, stimstart] = max(diff(intensityvec));

intensityvec_n = intensityvec/intensityvec(stimstart);

plotyy(1:n_frames,intensityvec,1:n_frames,intensityvec_n)
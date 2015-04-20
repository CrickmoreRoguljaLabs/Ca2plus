[filename, pathname] = uigetfile('*.tif');
addpath(pathname)
fullfilename = fullfile(pathname,filename);

initialim = imread(fullfilename,1);
%imshow(mat2gray(initialim))

userpoly = getpoly(mat2gray(initialim));

area = sum(userpoly(:));

nframes = 300;

intensityvec = zeros(nframes,1);

for i=1:nframes
    tempim = imread(fullfilename,i);
    intensityvec(i) = mean(tempim(userpoly));
end

plot(intensityvec)
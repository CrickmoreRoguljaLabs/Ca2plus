function [int, lag ] = corrview1( num1, num2)
% corrvew1 shows a single pair of cross correlation between two signals.
%   corrview1( num1, num2)

% Input the following variables directly from base
final_cell_sig = evalin('base','final_cell_sig');
final_cell_segments = evalin('base','final_cell_segments');
fn = evalin('base','fn');


% Read out the signals of the two ROIs
s1 = final_cell_sig(num1,51:end);

s1 = mat2gray(s1);

s2 = final_cell_sig(num2,51:end);%t1:t2);

s2 = mat2gray(s2);

% Calculate cross correlation
[int , lag] = xcorr(s1-mean(s1) , s2-mean(s2));

% Use a sample image to determine how bright the pixels should be
sampleim = mat2gray(imread(fn));

%maxpixel = max(sampleim(:));

multiplier = 1;

sampleim = multiplier * sampleim;

maxpixel2 = max(sampleim(:));

% Construct the RGB images of the two ROIs
roi1 = repmat(sampleim,[1 1 3]);

roi1(:,:,1)=0;

roi1(:,:,3)=0;

roi2 = roi1;

roi1(:,:,1) = uint16(final_cell_segments(:,:,num1))*uint16(maxpixel2);

roi2(:,:,1) = uint16(final_cell_segments(:,:,num2))*uint16(maxpixel2);

% Make the figure
h1 = figure('Position',[50,50,1200,620]);

% First panel for ROI1 image
subplot(3,4,1)

imshow(roi1)

% Second (vertical) panel for ROI2 image
subplot(3,4,5)

imshow(roi2)

% First trace panel for signal 1
subplot(3,4,2:4)

plot(s1);

% Second trace panel for signal 2
subplot(3,4,6:8)

plot(s2);

% Third trace panel for the correlation plot
subplot(3,4,10:12)

plot(lag, int);

% Tight up and resize
tightfig;

set(h1, 'Position', [50 50 1300 620]);

 



end


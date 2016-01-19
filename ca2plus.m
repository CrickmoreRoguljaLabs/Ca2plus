%% ca2plus
% Stephen Zhang
% February 11, 2014 - April 8, 2014
% Re-wrote Dec 15, 2014
% Modified again Jan 18, 2016
% xzhang03@fas.harvard.edu

% Modified from Cellsort
% Eran Mukamel
% December 1, 2009
% eran@post.harvard.edu

%% 0. Initiation

% Label batch processing and read the batch processing parameter file 
settings_file = importdata('cal2plus_settings.csv');

% General path of videos
genvidpath = settings_file{1};
genvidpath = genvidpath(strfind(genvidpath, ',')+1:end);

% Export path of analysis
export_path = settings_file{2};
export_path = export_path(strfind(export_path, ',')+1:end);

% Determine whether a computer is a PC or not
PC_or_not = settings_file{3};
PC_or_not = PC_or_not(strfind(PC_or_not, ',')+1:end)=='Y';

% Obtain the video file
[fn, vidpath]  =  uigetfile(genvidpath); % This address should be changed according to the user

% The full name of the video
fn_full = fullfile(vidpath,fn);

% Temporarily add the path
addpath(vidpath);


%% 1. PCA

nPCs = 200;
flims = [];

[mixedsig, mixedfilters, CovEvals, covtrace, movm, movtm] = ...
    CellsortPCA(fn_full, flims, nPCs, [], [], []);%,polyfocus);

%% 2a. Choose PCs

[PCuse] = CellsortChoosePCs(fn_full, mixedfilters);
close gcf

%% 2b. PCA postprocessing
% Separate out the positive from the negative components and make both
% positive

% Prepare to split the PCs by duplication
mixedsig2=repmat(mixedsig(PCuse,:),[2,1]);
mixedfilters2=repmat(mixedfilters(:,:,PCuse),[1,1,2]);
CovEvals2=repmat(CovEvals(PCuse),[2,1]);

nPCs2=length(PCuse)*2;
PCuse2=1:nPCs2;

% For first half of the PCs, keep positive
for i=1:length(PCuse)
    tempread1=squeeze(mixedfilters2(:,:,i));
    tempread2=squeeze(mixedsig2(i,:));
    tempread1(tempread1<0)=0;
    tempread2(tempread2<0)=0;

    mixedfilters2(:,:,i)=tempread1;
    mixedsig2(i,:)=tempread2;
end

% For second half of the PCs, keep negative and convert them to positive
for i=length(PCuse)+1:length(PCuse)*2
    tempread1=-squeeze(mixedfilters2(:,:,i));
    tempread2=-squeeze(mixedsig2(i,:));
    tempread1(tempread1<0)=0;
    tempread2(tempread2<0)=0;
    mixedfilters2(:,:,i)=tempread1;
    mixedsig2(i,:)=tempread2;
end

%% 3a. ICA
% ICA analysis
nIC = length(PCuse2);
mu = 0.5;
[ica_sig, ica_filters, ica_A, numiter] = CellsortICA(mixedsig2, mixedfilters2, CovEvals2, PCuse2, mu, nIC,[],[],1000);

%% 4a. Segment contiguous regions within ICs
% Obtain the ICA segmentations and apply area threshold
smwidth = 2;
thresh = 2;
arealims = 20; %Area threshold
plotting = 0;

[ica_segments, segmentlabel, segcentroid] = CellsortSegmentation(ica_filters, smwidth, thresh, arealims, plotting);

% Filter out redundent areas and centroids
ica_segments = arearank(ica_segments,1,1);
[ica_segments, ica_centroids]=filter_redundant(ica_segments, 10,[]);
%% 4b. Manual pick segmented regions

manualpickgui = ManualPick;
uiwait(manualpickgui);

% Apply selection to centroids
% ica_centroids = ica_centroids(pass_or_fail(:,2) > 1 , :);

%% 4c. CellsortApplyFilter 
% Apply segments to calculate traces
subtractmean = 0;
real_ica_segments=uint8(real_ica_segments>0);
ica_areas=squeeze(sum(sum(real_ica_segments,1),2));
cell_sig = CellsortApplyFilter2(fn, real_ica_segments, subtractmean,'Applying segments');
cell_sig=cell_sig./repmat(ica_areas,[1,size(cell_sig,2)]);

%% 5a. Final selection
% Select the traces
traceselectgui = TraceSelect;
uiwait(traceselectgui);

% Apply selection to centroids
% final_ica_centroids = ica_centroids(traces_select_or_not>0,:);

%% 6a. Save the workspace and traces
% Save workspace
if exist([fn_full(1:end-4),'.mat'],'file')
    saveagain=inputdlg('Save again?','Resaving');
    saveagain=str2double(saveagain{1});
else
    saveagain=1;
end

if saveagain==1
    save(fullfile(export_path,[fn(1:end-4),'.mat']));
end

% Save calcium transients
% subplot_plan=[6,6,1];
% fileoutput = pdfplot2( final_cell_sig, subplot_plan, [fn(1:end-4),'.pdf'],...
%     PC_or_not, export_path);

% Eliminate extra variables

keep export_path final_cell_segments final_cell_sig fn_full fn

% Save the concise format
save(fullfile(export_path,[fn(1:end-4),'_reduced.mat']));

%% 7a. Export the segments

% Read the first frame as background
centroid_im = mat2gray(imread(fn_full,1));

% Prepare other channels to label segments
centroid_im = repmat(centroid_im,[1,1,3]);

% Use channel 3 to label segments
centroid_im(:,:,3) = sum(final_cell_segments,3);

% Empty Channel 1 to write texts
centroid_im(:,:,1) = centroid_im(:,:,1) * 0;

% Prepare the figure
figure(101)

imshow(centroid_im,[])

% Write the segment numbers on the centroids
final_cell_centroids = zeros(size(final_cell_segments,3),2);

for i = 1 : size(final_cell_segments,3)
    % Obtain centroids
    tempstruct = regionprops(final_cell_segments(:,:,i),'Centroid');
    
    final_cell_centroids(i,:) = tempstruct.Centroid;
    
    % Write the segment numbers
    text(final_cell_centroids(i,1),final_cell_centroids(i,2),...
        num2str(i), 'FontSize',12,'Color',[1,0,0])
end

% Clean junks
clear tempstruct i

tightfig;

% Resize the figures
set(101,'Position',[40,60,1300,600])

% Save the figures and close
export_fig(fullfile(export_path,[fn(1:end-4),'.png']))

close(101)






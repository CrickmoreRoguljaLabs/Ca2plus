function cell_sig = CellsortApplyFilter2(fn, ica_segments, subtractmean,title)
% cell_sig = CellsortApplyFilter(fn, ica_segments, flims, movm, subtractmean)
%
%CellsortApplyFilter
% Read in movie data and output signals corresponding to specified spatial
% filters
%
% Inputs:
%     fn - file name of TIFF movie file
%     ica_segments - nIC x X matrix of ICA spatial filters
%     flims - optional two-element vector of frame limits to be read
%     movm - mean fluorescence image
%     subtractmean - boolean specifying whether or not to subtract the mean
%     fluorescence of each time frame
%
% Outputs:
%     cell_sig - cellular signals
%
% Eran Mukamel, Axel Nimmerjahn and Mark Schnitzer, 2009
% Email: eran@post.harvard.edu, mschnitz@stanford.edu
%
% Modified by Stephen Zhang

if nargin<4
    title='';
end

if nargin<3
    subtractmean = 1;
end
[pixw,pixh] = size(imread(fn,1));
if subtractmean==1
    movm = ones(pixw,pixh);
end

nt = tiff_frames(fn);
nf=size(ica_segments,3);
cell_sig = zeros(nf, nt);
%areas=sum(sum(real_ica_segments,1),2);

h=waitbar(0,'Calculating','Name',title);
for i=1:nt
    waitbar(i/nt)
    mov=imread(fn,i);
    mov3=repmat(mov,[1,1,nf]);
    framesig=squeeze(sum(sum(mov3.*uint16(ica_segments),1),2));
    cell_sig(:,i)=framesig;
    
end

close(h)


    function j = tiff_frames(fn)
        %
        % n = tiff_frames(filename)
        %
        % Returns the number of slices in a TIFF stack.
        %
        % Modified April 9, 2013 for compatibility with MATLAB 2012b

        j = length(imfinfo(fn));
    end
end

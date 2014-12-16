function [ output_segments, output_centroids ] = filter_redundant( input_segments ,area_diff_thresh, input_centroids)
%filter_redundant removes areas that have been completely covered by
%previous areas in a stack
%   Detailed explanation goes here

if nargin < 3
    input_centroids = [];
end

if nargin < 2
    area_diff_thresh=1;
end

n_areas=size(input_segments,1);
areas2keep=zeros(n_areas,1);
areas2keep(1)=1;
running_collection=squeeze(input_segments(1,:,:)>0);

for i=2:n_areas
    temp_area_boolean=squeeze(input_segments(i,:,:)>0);
    temp_area_diff=(temp_area_boolean-running_collection)>0;
    if sum(temp_area_diff(:))>=area_diff_thresh;
        running_collection=(running_collection+squeeze(input_segments(i,:,:)))>0;
        areas2keep(i)=1;
    end
end

output_segments = input_segments(areas2keep>0,:,:);

if ~isempty(input_centroids)
    output_centroids = input_centroids(areas2keep>0,:);
else
    output_centroids = [];
end
end


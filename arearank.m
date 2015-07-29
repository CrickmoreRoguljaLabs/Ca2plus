function [ output_mat ] = arearank( input_mat, dim, Descend_is_1 )
%arearank Rank a 3-D matrix based on the areas.
%   Detailed explanation goes here
if nargin<3
    Descend_is_1=1;
    
    if nargin<2
        dim=3;
    end
end

dims=1:3;
dims(dim)='';
input_mat2=uint8(input_mat>0);

areas=squeeze(sum(sum(input_mat2,dims(1)),dims(2)));

if Descend_is_1==1
    [~,order]=sort(areas,'Descend');
else
    [~,order]=sort(areas,'Ascend');
end

if dim==1
    output_mat=input_mat(order,:,:);
elseif dim==2
    output_mat=input_mat(:,order,:);
else
    output_mat=input_mat(:,:,order);
end

end


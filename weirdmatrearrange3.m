function [ output_mat ] = weirdmatrearrange3( mat )
%weirdmatrearrange3 Rearrange an n*x*y matrix to an x*y*n matrix while
%keeping the x*y layers the same.
%   Input:
%   mat         The input matrix
%
%   Output:
%   output_mat  The output matrix
%
% Coded by Stephen Zhang
matsize=size(mat);
output_mat=zeros(matsize(2),matsize(3),matsize(1));

for i=1:matsize(1)
    output_mat(:,:,i)=squeeze(mat(i,:,:));
end

end


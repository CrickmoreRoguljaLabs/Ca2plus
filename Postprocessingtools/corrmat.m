function [ coefmat ] = corrmat( sigs )
%CORRMAT finds correlation coefficients between pairs of signals within a
% pool of all signals. It then arragnes all the coeeficients into a matrix
% for display. The diagonal entries are replaced with 0.
%   [ coefmat ] = corrmat( sigs )

% Find the number of cells
ncells = size(sigs, 2);

% Prime the output matrix
coefmat = zeros(ncells);

% Find the coefficients
for i = 1 : ncells
    for j = 1 : ncells
        tempcoef = corrcoef(sigs(:,i), sigs(:,j));
        
        coefmat(i, j) = tempcoef(1,2);
    end
end

% Replace diagonal values with 0
coefmat(eye(ncells) > 0) = 0;


end


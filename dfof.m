function [ dfof_sig ] = dfof( sig )
%DFOF transforms the raw data to delta F / F data. The denominator is the
%minimal signal value for each trace within the first 50 entries.
%   [ dfof_sig ] = dfof( sig )

dfof_sig = sig;

% Determine whether the matrix is vertical or horizontal
[nrow , ncol] = size( sig );

if nrow > ncol
    for i = 1 : ncol
        dfof_sig( : , i ) = sig( : , i) / min( sig( 1:50 , i));
    end
else
    for i = 1 : nrow
        dfof_sig( i , : ) = sig ( i , : ) / min( sig ( i , 1:50 ));
    end
end



end


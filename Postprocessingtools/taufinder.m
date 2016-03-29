function [ coeffs, goodness ] = taufinder( input_mat , t_int, manual)
%TAUFINDER finds the time constants of decay data, given the time
%intervals. It also gives the r^2 values of the fits;
%   [ taus ] = taufinder( input_mat , t_int)
if nargin < 3
    % Default automated
    manual = 0;
    
    if nargin < 2
        % Default time interval is 
        t_int = 1;
    end
end

% Find the number of points and traces
[ n_pts , n_traces] = size(input_mat);

% Initiate taus and goodness matrices
coeffs = zeros(n_traces, 3);
goodness = zeros(n_traces, 1);

for i = 1 : n_traces
    % Isolate the data
    data = input_mat(:,i);
    
    if manual == 0
        % Find the start of the decay
        [~,i_ini] = min(diff(data) - 1);
        
        % Default end
        i_end = n_pts;
    else
        % Manually pick points
        figure(101)
        plot(data)
        i_ini = input('Initial decay point = ');
        i_end = input('End decay point = ');
        close(101)
    end
    
    % Determine the X values
    X = (1:i_end-i_ini+1)' * t_int;
    
    % Write general fit
    g = fittype('a*exp(x/b)+c');
    
    % Find fit
    [fx, fx_eval]=fit(X,...
        data(i_ini:i_end), g, 'startpoint', [0.4 -2 1]);
    
    
    % Extract results
    coeffs(i, 1) = fx.a;
    coeffs(i, 2) = -fx.b;
    coeffs(i, 3) = fx.c;
    goodness(i) = fx_eval.rsquare;
    
    figure(i)
    plot(fx, X, data(i_ini:i_end));
end


end


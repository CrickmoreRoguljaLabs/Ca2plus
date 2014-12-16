function [ fileoutput ] = pdfplot2( alltraces,  subplot_plan, filename, PC_or_not, dir)
%pdfplot Plot a n trial * x data points plot with a specified subplot plan
%and predetermined episodes
%   Inputs:
%   alltraces       An n by x matrix, where n is the number of trials and x
%                   is the number of data points
%   subplot_plan    A 3 by 1 vector with the entries [total number of
%                   subplots, number of rows, number of columns]
%   timelines       A vector that specifies where timelines should be drawn
%                   This should include the last frame in addition to the
%                   frame numbers in the middle
%   filename        A string specifying the file name
%   dir             A string specifying the directory
%
%   Output:
%   fileoutput      A string specifying the output file (including dir)

if nargin<5
    dir='';
end

% Calculate the number of pages needed
npages=ceil(size(alltraces,1)/subplot_plan(1));

% Calculate how many plots are left (this number changes as the program rums)
plots_left=size(alltraces,1);

% The number of vids
nvids2=1;

for pagenum=1:npages
    % Make figure
    figure(101)
    set(gcf,'Position',[0 0 1000 691])
    
    % Create individual subplots
    for subplot_num=1:min(subplot_plan(1),plots_left)
        % Subplot setup
        subplot(subplot_plan(2),subplot_plan(3),subplot_num)
        
        % Calculate which trace to plot
        index = (pagenum-1)*subplot_plan(1)+subplot_num;
        
        % Plot
        plot(alltraces(index,:),'-')
        
        % Optimize Y-range
        yrange=get(gca,'ylim');
        
        % Write the cell number
        hold on
        
        text(20,yrange(2)*0.8,['Cell ',num2str(index)])
        
        % Write timelines if multiple videos
        for i=1:nvids2-1
            plot([timelines(i),timelines(i)],yrange,'g')
        end
        
        hold off
        
        % Y-axis label
        ylabel('Fluorescence')
        
        % X-axis label
        if subplot_num==min(subplot_plan(1),plots_left)
            xlabel('frames')
        end
    end
    
    % Tighten up the figure
    tightfig;
    
    % Determine the output file name
    fileoutput = [dir,filename];
    
    % Resize figure
    set(gcf,'Position',[0 0 1000 1000],'Color',[1 1 1])
    
    % Subtract the panels made
    plots_left=plots_left-subplot_plan(1);
    
    % Output the figure
    if PC_or_not ==1
        export_fig(fileoutput,'-append');
    else
        saveas(gcf,[fileoutput,'_',num2str(pagenum)]);
    end
    
    % Close
    close(101)
end

end


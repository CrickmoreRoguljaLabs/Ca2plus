% Make the figure
figure('Position',[50 50 1200 620])

% Obtain sample image
sampleim = mat2gray(imread(fn,1));

sample2show = repmat(sampleim, [1 1 3]);

sample2show(:,:,3) = 0;

page = 1;

n_rois =size(final_cell_sig,1);

% 0 to jump out of the page or it goes to the page.
while page > 0
    
    sample2show(:,:,1) = uint16(final_cell_segments(:,:,...
        page));
    
    subplot(2,4,1)
    
    imshow(sample2show)
    
    if exist('map','var')
        if ~isempty(map{page, 2})
            tempmap = map{page,2};

            subplot(2,4,2)

            imshow(map{page,1},'DisplayRange',[0 0.5])

            subplot(2,4,3)

            imshow(-tempmap(:,:,1),[])

            subplot(2,4,4)

            imshow(tempmap(:,:,2).*tempmap(:,:,3),[])
        end
    end
    
    subplot(2,4,5:8)
    
    plot(mat2gray(final_cell_sig( min(page,n_rois),:)));
    
    text(5,0.9,['Page ', num2str(page)])
    
    page = min(input('What page to jump to? = '),n_rois);
    
end

close(gcf)
% Make the figure
figure('Position',[50 50 1200 620])

% Obtain sample image
sampleim = imread(fn,1);

sample2show = 6 * repmat(sampleim, [1 1 3]);

sample2show(:,:,3) = 0;

page = 1;

while page > 0
    
    sample2show(:,:,1) = uint16(final_cell_segments(:,:,page)) * 40000;
    
    subplot(2,2,1)
    
    imshow(sample2show)
    
    subplot(2,2,2)
    
    imshow(map{page},[])
    
    subplot(2,2,3:4)
    
    plot(mat2gray(final_cell_sig(page,:)));
    
    page = input('What page to jump to? = ');
    
    
    
end
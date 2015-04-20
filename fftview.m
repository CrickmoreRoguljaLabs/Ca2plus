function [note] = fftview(final_cell_sig, final_cell_segments, fn)
% fftview applies fourier transform to the calcium imaging data and let the
% user decide any kind of notation.

sample_im = 6 * imread(fn, 1);

rgb = repmat(sample_im, [1 1 3]);

rgb(:,:,3) = 0;

n_sigs = size(final_cell_sig, 1);

note = zeros(n_sigs, 1);

for i = 1 : n_sigs
    
    rgb(:,:,1) = 24000 * uint16(final_cell_segments(:,:,i));
        
    figure(102)
    
    imshow(rgb)
    
    simplefft(final_cell_sig(i, :));
   
    disp(num2str(i));
   
    note(i) = input('Notation? = ');
end

end
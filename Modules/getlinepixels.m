function [ output_im ] = getlinepixels( input_im , showresult)
%getlinepixels Calculate all the pixels along a hand-drawn line.
%   Inputs:
%   input_im        The image matrix that you want to draw a line on
%   showresult      1 - show the result; 0 - don't show the result
%
%   Outputs
%   output_im       A image matrix with the line-pixels as 1.
%
% Coded by Stephen Zhang

if nargin<2
    showresult=1;
end



figure(99)

imshow(input_im)
set(99,'Position',[100 50 1000 600])
h = imline;
position = wait(h);
position=single(round(position));
imwidth=diff(single(position(:,1)));
imheight=diff(single(position(:,2)));
close(99)

if abs(imwidth)>=abs(imheight)
    %display('Find dots along the width.')
    if position(1,1)>position(2,1)
        position=position([2 1],:);
    end
    lineslope=imheight/imwidth;
    pixels=zeros(abs(imwidth)+1,2);
    pixels(:,1)=position(1,1):position(2,1);
    pixels(2:end,2)=round((1:abs(imwidth))*lineslope+position(1,2));
    pixels(1,2)=position(1,2);
    pixels=pixels(:,[2,1]);
else
    %display('Find dots along the height.')
    if position(1,2)>position(2,2)
        position=position([2 1],:);
    end
    lineslope=imwidth/imheight;
    pixels=zeros(abs(imheight)+1,2);
    pixels(:,1)=position(1,2):position(2,2);
    pixels(2:end,2)=round((1:abs(imheight))*lineslope+position(1,1));
    pixels(1,2)=position(1,1);
end


output_im=zeros(size(input_im));
    
for i=1:size(pixels,1)
    output_im(pixels(i,1),pixels(i,2))=1;
end
    
if showresult==1
    figure
    imshow(output_im)
end

end


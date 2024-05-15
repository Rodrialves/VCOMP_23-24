clc;
close all;
clear;

% Directory path
directory = 'Datasets\Task1\Images';
folderpath='Train';

% Get a list of all files in the directory
fileList = dir(fullfile(directory, '*.jpg'));

% Loop through the list and read each image
images = cell(1, numel(fileList)); % Initialize cell array to store images
hist = cell(1, numel(fileList));
images_squared = cell(1, numel(fileList));
list=[1 ,2  ,29 ,38 ];

for i = 1:numel(fileList)
    % Get the file name
    fileName = fullfile(directory, fileList(i).name);
    
    % Read the image
    image = imread(fileName);
    
    % Store the image in the cell array
    
    images{i} = image;
end
% 
% figure(1)
% subplot(2,1,1), imshow(images{1});subplot(2,1,2), imshow(images{38});

%%


    i=38;
    I=images{i};

    height = size(I,1);
    width = size(I,2);
    
    %We create a new image called O (original) so we can manipulate it later
    O = I;
    %New binary image filled with zeros
    BW = zeros(height,width);
    
    %For the skin detection we convert the image from RGB to YCbCr
    %https://en.wikipedia.org/wiki/YCbCr
    I_ycbcr = rgb2ycbcr(I);
    Cb = I_ycbcr(:,:,2);
    Cr = I_ycbcr(:,:,3);
    
    figure(i);
    subplot(2,3,1);imshow(I_ycbcr);
    
    %This is where we detect the skin pixels
    [r,c,v] = find(Cb>=77 & Cb<=127 & Cr>=133 & Cr<=173);
    numind = size(r,1);
    
    for j=1:numind
        %On the original image we mark the skin pixels with red color
        O(r(j),c(j),:) = [255 0 0];
        %Fill the binary image with ones where we detect skin pixels
        BW(r(j),c(j)) = 1;
    end
    
    subplot(2,3,2);imshow(O);
    subplot(2,3,3);imshow(BW);title("Starting");


    %Fill the little black holes
    BW = imfill(BW, 'holes');
    %Delete small areas on the image
    BW = bwareaopen(BW,900);
    
    subplot(2,3,4);imshow(BW);title("delete small areas");
    
    se = strel('square',5);
    %The fingers are smaller than the palm so we can "delete" them
    %With simple morphology
    BW2 = imerode(BW, se);
    subplot(2,3,5);imshow(BW2);title("delete small noise")
    %Reconstruct the palm (or a little bigger than the original)
    BW2 = imdilate(BW2,se);
    subplot(2,3,6);imshow(BW2);

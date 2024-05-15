%% Get the Images and Crop the Bounding Box

% Directory path
directory = 'Datasets\Task2\Images_with_BBs';

% Get a list of all files in the directory
fileList = dir(fullfile(directory, '*.tif'));

% Loop through the list and read each image
images = cell(1, numel(fileList)); % Initialize cell array to store images

for i =1:numel(fileList)
    % Get the file name
    fileName = fullfile(directory, fileList(i).name);
    
    % Read the image
    image = imread(fileName);
    
    % Convert the image to grayscale
    grayImage = rgb2gray(image);
    
    % Create a bounding box around the coloured region eliminating the black background
    % Find the bounding box of the coloured region
    [rows, columns, ~] = find(grayImage ~= 0);
    % Get the bounding box
    boundingBox = [min(columns), min(rows), max(columns) - min(columns), max(rows) - min(rows)];

    % Crop the image using the bounding box
    croppedImage = imcrop(image, boundingBox);

    % Store the cropped image in the cell array
    images{i} = croppedImage;
end

imshow(croppedImage)
% Display the images like a filmstrip
figure;
montage(images, 'Size', [1, numel(fileList)]); title('Filmstrip of Cropped Images'); % blackbars appear to get the images to the same size to the montage but they are really not there

%%

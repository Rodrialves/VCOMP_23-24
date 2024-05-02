abc=imread("Datasets\Task1\Images\img01.jpg");

% Specify the directory path
directory = 'Datasets\Task1\Images';

% Get a list of all files in the directory
fileList = dir(fullfile(directory, '*.jpg'));

% Loop through the list and read each image
images = cell(1, numel(fileList)); % Initialize cell array to store images

for i = 1:numel(fileList)
    % Get the file name
    fileName = fullfile(directory, fileList(i).name);
    
    % Read the image
    image = imread(fileName);
    
    % Store the image in the cell array

    images{i} = image;
end

% Display the images like a filmstrip
figure;
montage(images, 'Size', [1, numel(fileList)]);
title('Filmstrip of Images');

% Grayscale all the images
for i = 1:numel(images)
    gray{i} = rgb2gray(images{i});
end

figure;
montage(gray, 'Size', [1, numel(fileList)]);
title('Filmstrip of GrayScale images');
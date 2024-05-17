close all;
clear;

% Read Excel information
Cell = readcell('Datasets\Task2\LetterClassification_GT.xlsx');

% Extract 
letters = Cell(4:41, 3);  
img_name = Cell(4:41, 2);

letters_array = cellfun(@char, letters, 'UniformOutput', false);
img_array = cellfun(@char, img_name, 'UniformOutput', false);

% Initialize empty vectors for each group of letters
vectorA = {};
vectorB = {};
vectorC = {};
vectorI = {};
vectorL = {};
vectorV = {};
vectorW = {};

% Iterate through each element of letters
for i = 1:length(letters_array)
    
    % Check the letter and group accordingly
    if isequal(letters_array(i), "A");
        vectorA{end+1} = img_array{i};
    elseif isequal(letters_array(i), "B");
       vectorB{end+1} = img_array{i};
    elseif isequal(letters_array{i}, "C")
        vectorC{end+1} = img_array{i};
    elseif isequal(letters_array{i}, "I")
        vectorI{end+1} = img_array{i};
    elseif isequal(letters_array{i}, 'L')
        vectorL{end+1} = img_array{i};
    elseif isequal(letters_array{i}, 'V')
        vectorV{end+1} = img_array{i};
    elseif isequal(letters_array{i}, 'W')
        vectorW{end+1} = img_array{i};
    end
end


expression = '(\d+)';
% Loop to extract numbers from each strings
for i = 1:length(vectorA)
    % Find numbers
    found_numbers = regexp(vectorA{i}, expression, 'tokens');
    %Convert numbers to numeric format and store it
    vecA{i} = str2double(found_numbers{1}{1});
end
for i = 1:length(vectorB)
    found_numbers = regexp(vectorB{i}, expression, 'tokens');
    vecB{i} = str2double(found_numbers{1}{1});
end
for i = 1:length(vectorC)
    found_numbers = regexp(vectorC{i}, expression, 'tokens');
    vecC{i} = str2double(found_numbers{1}{1});
end
for i = 1:length(vectorI)
    found_numbers = regexp(vectorI{i}, expression, 'tokens');
    vecI{i} = str2double(found_numbers{1}{1});
end
for i = 1:length(vectorL)
    found_numbers = regexp(vectorL{i}, expression, 'tokens');
    vecL{i} = str2double(found_numbers{1}{1});
end
for i = 1:length(vectorV)

    found_numbers = regexp(vectorV{i}, expression, 'tokens');
    vecV{i} = str2double(found_numbers{1}{1});
end
for i = 1:length(vectorW)
    found_numbers = regexp(vectorW{i}, expression, 'tokens');
    vecW{i} = str2double(found_numbers{1}{1});
end


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

    % Resize image to 64 x 64
    resizedImage = imresize(croppedImage, [64, 64]);
    
    % function preprocessing (equal to task1)
    graycroppedImage=preProcessing(resizedImage,64,64);
    
     % Define a threshold for black
    threshold = 0;

    % Create a binary image where black pixels are 1 and others are 0
    black_pixels = graycroppedImage == threshold;

    % Calculate the total number of pixels
    total_pixels = numel(graycroppedImage);

    % Calculate the number of black pixels
    num_black_pixels = sum(black_pixels(:));

    % if image is all black , igore preprocessing and aply simple mask
    if (num_black_pixels/total_pixels > 0.8) 
        graycroppedImage = rgb2gray(resizedImage);
    end
        mask = false(size(graycroppedImage));
        mask(1:end,1:end) = true;
        img = activecontour(graycroppedImage, mask, 350);
        images{i} = img;
end

for i = 1:length(images)
%i=9;
%imshow(images{i});
total = [0, 0, 0, 0, 0, 0, 0];
correlation = [0, 0, 0, 0, 0, 0, 0];
disp(i);
for j = 1:length(vecA)
    indice = vecA(j);
    if ~(i == indice{1})
            correlationA = normxcorr2(images{i}, images{indice{1}});
              [maxCorrA, maxIndexA] = max(abs(correlationA(:)));
            correlation(1) =  correlation(1) + maxCorrA;  %% cumulative
            total(1) = total(1) + 1; 

    end
end
% Calculate medium correlation
correlation(1) = correlation(1) / total(1);
disp(correlation(1)); %A

for j = 1:length(vecB)
    indice = vecB(j);
    if ~(i == indice{1})
            correlationB = normxcorr2(images{i}, images{indice{1}});
              [maxCorrB, maxIndexB] = max(abs(correlationB(:)));
            correlation(2) =  correlation(2) + maxCorrB;
            total(2) = total(2) + 1; 

    end
end
correlation(2) = correlation(2) / total(2);
disp(correlation(2)); %B

for j = 1:length(vecC)
    indice = vecC(j);
    if ~(i == indice{1})
            correlationC = normxcorr2(images{i}, images{indice{1}});
              [maxCorrC, maxIndexC] = max(abs(correlationC(:)));
            correlation(3) =  correlation(3) + maxCorrC;
            total(3) = total(3) + 1;

    end
end
correlation(3) = correlation(3) / total(3);
disp(correlation(3)); %C

for j = 1:length(vecI)
    indice = vecI(j);
    if ~(i == indice{1})
            correlationI = normxcorr2(images{i}, images{indice{1}});
              [maxCorrI, maxIndexI] = max(abs(correlationI(:)));
            correlation(4) =  correlation(4) + maxCorrI;
            total(4) = total(4) + 1;  

    end
end
correlation(4) = correlation(4) / total(4);
disp(correlation(4)); %I

for j = 1:length(vecL)
    indice = vecL(j);
    if ~(i == indice{1})
            correlationL = normxcorr2(images{i}, images{indice{1}});
              [maxCorrL, maxIndexL] = max(abs(correlationL(:)));
            correlation(5) =  correlation(5) + maxCorrL;
            total(5) = total(5) + 1; 
    end
end
correlation(5) = correlation(5) / total(5);
disp(correlation(5)); %L

for j = 1:length(vecV)
    indice = vecV(j);
    if ~(i == indice{1})
            correlationV = normxcorr2(images{i}, images{indice{1}});
              [maxCorrV, maxIndexV] = max(abs(correlationV(:)));
            correlation(6) =  correlation(6) + maxCorrV;
            total(6) = total(6) + 1;  

    end
end
correlation(6) = correlation(6) / total(6);
disp(correlation(6)); %V

for j = 1:length(vecW)
    indice = vecW(j);
    if ~(i == indice{1})
            correlationW = normxcorr2(images{i}, images{indice{1}});
              [maxCorrW, maxIndexW] = max(abs(correlationW(:)));
            correlation(7) =  correlation(7) + maxCorrW;
            total(7) = total(7) + 1;  

    end
end
correlation(7) = correlation(7) / total(7);
disp(correlation(7)); %W

[maxValue, maxPosition] = max(correlation); %% See which correlation is greater
if maxPosition == 1
    result{i} = 'A';
elseif maxPosition == 2
    result{i} = 'B';
elseif maxPosition == 3
    result{i} = 'C';
elseif maxPosition == 4
    result{i} = 'I';
elseif maxPosition == 5
    result{i} = 'L';
elseif maxPosition == 6
    result{i} = 'V';
elseif maxPosition == 7
    result{i} = 'W';
end
disp(result{i});
end

    is_right = 0;
for i= 1:length(result)
    if isequal(result{i}, letters_array{i})
        is_right = is_right + 1;
    else
        fprintf("Wrong Classification!! img %d. obtained = %s and should be = %s\n", i, result{i}, letters_array{i});
    end
end
disp(is_right);

% Show filmstrip of all images
figure;
montage(images, 'Size', [1, numel(fileList)]); title('Filmstrip of Images');


% Compute the confusion matrix
confMat = confusionmat(letters_array, result);

% Display the confusion matrix
disp('Confusion Matrix:');
figure;
disp(confMat);

% Create a confusion chart
confChart = confusionchart(letters_array, result);

% Customize the confusion chart 
confChart.Title = 'Confusion Matrix';
confChart.RowSummary = 'row-normalized';
confChart.ColumnSummary = 'column-normalized';



function output=preProcessing(img,h,w) %% preprocessing function from task1

    %YCbCr
    YCbCr=rgb2ycbcr(img);
    Cb=YCbCr(:,:,2);
    Cr=YCbCr(:,:,3); 
    %HSV
    HSV=rgb2hsv(img);

    [r,c,~]=find(Cr >= 140 & Cr <= 160 & Cb >= 95 & Cb <= 170 & HSV(:,:,1)<0.9);

    img_S_e = zeros(h, w);
    numind = size(r);

    for i=1:numind
        img_S_e(r(i),c(i)) = 1;
    end

    [L,~]=bwlabel(img_S_e);

    s=regionprops(L,'PixelIdxList','Area','BoundingBox','Centroid');

    idx=[s.Area]>=5000;
    if(find(idx==1))
        idx_to_keep = [s.Area] >= 5000;
    else
        idx_to_keep = [s.Area] >= 2000;
    end


    skin_px = zeros(h, w);
    for i = 1:size(idx_to_keep,2)
        if(idx_to_keep(i)==1)
            [r,c,~] = find(L==i);
            numind = size(r,1);
            for k=1:numind
                skin_px(r(k),c(k)) = 1;
            end
        end
    end

    output=skin_px;
end


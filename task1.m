%% Read All the Images

%Clear all the variables in the workspace; Clear all the commands in the
%command window; Close all the open figures
clear;clc; close all;

%Change enable to 1 if you want to check the progression of image
%segmentation
enable=0;
if(enable==0)
    fprintf("Intermediate images will not be printed\n");
else
    fprintf("Intermediate images will be printed\n");
end

% maximum height and width of the image to analyse
h=256;w=256;

% Directories path 
directory = 'Datasets\Task1\Images'; % Folder where the images are stored
directory_gt= 'Datasets\Task1\Hand_masks'; % Folder where the hand_masks images are stored
folderpath_masks='Results\Task1\BB_Mask\'; % Folder where the masks will be saved
folderpath_Img_bb='Results\Task1\Images_BB\'; % Folder where the images with BB will be stored

% Get a list of all files in the directory
fileList = dir(fullfile(directory, '*.jpg'));

% Loop through the list and read each image
%If you want to test all the images just change the 5 for numel(fileList)
images = cell(1, numel(fileList)); % Initialize cell array to store images
Bounding = cell(1, numel(fileList));

for i = 1:numel(fileList)

    % Get the file name
    fileName = fullfile(directory, fileList(i).name);
    
    % Read and resize the image
    image = imresize(imread(fileName),[h w]);
    
    % Store the image in the cell array
    images{i} = image;

end

for j=1:numel(fileList)

    Img=preProcessing(images{j},h,w);
    
    Img_no_arm=removeArm(Img,enable);

    Img_bb=createBB(Img_no_arm,h,w);

    Img_applied_BB=applyBB(images{j},Img_bb);
    
    if(enable==1)
        figure();
        subplot(2,2,1);imshow(images{j});title('Original Image');
        subplot(2,2,2);imshow(Img_no_arm);title('Image without Arm');
        subplot(2,2,3);imshow(Img_bb);title('Bounding Box');
        subplot(2,2,4);imshow(Img_applied_BB);title('Bounding Box Applied');
    end

    %store the images
    if(j<10)
        imwrite(Img_bb, strcat(folderpath_masks,'0', int2str(j), '_bb.png'));
        imwrite(Img_applied_BB, strcat(folderpath_Img_bb,'0', int2str(j), '_bb.tif'));

    else
        imwrite(Img_bb, strcat(folderpath_masks, int2str(j), '_bb.png'));
        imwrite(Img_applied_BB, strcat(folderpath_Img_bb, int2str(j), '_bb.tif'));
    end
end

 applyJaccard(directory_gt,folderpath_masks,h,w);

%% Functions that will be used

function output=preProcessing(img,h,w)
   
    %YCbCr
    YCbCr=rgb2ycbcr(img);
    Cb=YCbCr(:,:,2);
    Cr=YCbCr(:,:,3); 
    %HSV
    HSV=rgb2hsv(img);
    H=HSV(:,:,1);

    [r,c,~]=find(Cr >= 140 & Cr <= 160 & Cb >= 95 & Cb <= 170 & H<0.9);

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

function output=removeArm(inputImage,enable)
    
    %Display the input image if enable is true
    if(enable==1)
        figure;
        subplot(1,2,1);imshow(inputImage); title('Input Image');
    end
    
    lastRow = size(inputImage, 1);

    while true
        %From the last row of the image find where the 1 stop converging
        %This is the point where the arm starts
        %Find the last row of the image
        %Find the first column where the pixel value is 1
        firstColumn = find(inputImage(lastRow, :) == 1, 1, 'first');
        %Find the last column where the pixel value is 1
        lastColumn = find(inputImage(lastRow, :) == 1, 1, 'last');

        if(firstColumn ~= size(inputImage, 2))
            break;
        elseif(lastRow ~= size(inputImage, 1)/2)
            lastRow = lastRow - 1;
        end
    end  
    
    % Find the row where the arm stops from converging
    firstRow = lastRow;
    for row = lastRow-1:-1:1
        % Check if the pixel value is not 1
        if(lastColumn>=255)
            continue
        end
        if (inputImage(row, lastColumn+1) ~= 1)
            lastRow = row + 1;
            break;
        else
            % Update the lastColumn
            lastColumn = find(inputImage(lastRow, :) == 1, 1, 'last');
        end
    end

    for row = firstRow:-1:size(inputImage, 1)/4
        %if these 3 pixels are not 1 then the arm stops converging
        if(firstColumn<=2)
            continue
        end
        if(inputImage(row, firstColumn-1) ~= 1)
            firstRow = row + 1;
            %update the first column
            firstColumn = find(inputImage(row, :) == 1, 1, 'first');
            continue;
        else
            firstRow = row;
            break;
        end
    end

    %Remove the arm from the image
    %Set the pixel values of the arm to 0
    ristRow = round(max((min(firstRow,lastRow)+(max(firstRow,lastRow)-min(lastRow,firstRow) )/4), size(inputImage, 1)/2));
    inputImage(ristRow:size(inputImage,1), :) = 0;
    
    if(enable==1)
         %Display the image with the arm removed
        subplot(1,2,2);imshow(inputImage); title('Image with Arm Removed');
        disp(['Rist Row: ', num2str(ristRow)]);
    end
   
    output=inputImage;
end

function output=createBB(inputImage,h,w)
    [L,~]=bwlabel(inputImage);

    s=regionprops(L,'PixelIdxList','Area','BoundingBox','Centroid');
    a_max=0;
    i_max=0;
    
    %find the maximum area value
    for i=1:size(s,1)
        if(s(i).Area>a_max)
            i_max=i;
            a_max=s(i).Area;
        end
    end
    
    bb=s(i_max).BoundingBox;

    % Create BB image
    %find the first and last column
    beg_col = ceil(bb(1)); end_col = beg_col + bb(3) - 1;
    %find the first and last row
    beg_row = ceil(bb(2)); end_row = beg_row + bb(4) - 1;

    bb_img = zeros(h, w);
    for i = beg_row:end_row
        for n = beg_col:end_col
            bb_img(i, n) = 1;
        end
    end

    output=bb_img;
end

function applyJaccard(directory_gt,directory_Hand_masks,h,w)
    fileList1 = dir(fullfile(directory_gt, '*.png'));
    
    gt = cell(1, numel(fileList1));

    for i = 1:numel(fileList1)
    
        % Get the file name
        fileName = fullfile(directory_gt, fileList1(i).name);
        % Read and resize the image
        image = imresize(imread(fileName),[h w]);
        
        % Store the image in the cell array
        
        gt{i} = image;
    end
    
    fileList2 = dir(fullfile(directory_Hand_masks, '*.png'));
    result = cell(1, numel(fileList2));
    
    TP=0;FP=0;FN=0;
    
    for i = 1:numel(fileList2)
    
        % Get the file name
        fileName = fullfile(directory_Hand_masks, fileList2(i).name);
        
        % Read and resize the image
        image = imresize(imread(fileName),[h w]);
        
        % Store the image in the cell array
        
        result{i} = image;
    end
    
    
    for i=1:numel(fileList1)
        similarity = jaccard(imbinarize(result{i}),gt{i});
        if similarity >= 0.5
            TP = TP+1;
        elseif similarity > 0
            FP = FP+1;
        else
            FN = FN+1;
            disp(['false negative: ', num2str(i)]);
        end
    end
    
    R= TP/(TP+FN);
    P= TP/(TP+FP);
    F1 = 2*P*R/(P+R);

    fprintf("\nResults:\n");
    T = table(TP, FP, FN, R, P, F1, 'VariableNames', {'True Positives(TP)', 'False Positives(FP)', 'False Negatives(FN)', 'Recall', 'Precision', 'F1'});  
    disp(T);
end

function output=applyBB(inputOriginal, inputBB)
    % Apply the bounding box to the original image
    % Find the first and last row and column of the bounding box
    [r, c] = find(inputBB == 1);
    firstRow = min(r); lastRow = max(r);
    firstColumn = min(c); lastColumn = max(c);
    
    %apply the Bounding box
    inputOriginal(1:firstRow, :) = 0;
    inputOriginal(lastRow:end, :) = 0;
    inputOriginal(:, 1:firstColumn, :) = 0;
    inputOriginal(:, lastColumn:end,:) = 0;

    output=inputOriginal;
end

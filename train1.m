%% Read all the images %%

% Directory path
directory = 'Datasets\Task1\Images';
folderpath='Train';

% Get a list of all files in the directory
fileList = dir(fullfile(directory, '*.jpg'));

% Loop through the list and read each image
images = cell(1, 5); % Initialize cell array to store images
hist = cell(1, 5);
images_squared = cell(1, 5);
list=[1 ,2 ,9 ,29 ,38 ];

for i = 1:5
    % Get the file name
    fileName = fullfile(directory, fileList(list(i)).name);
    
    % Read the image
    image = imread(fileName);
    
    % Store the image in the cell array

    images{i} = image;
end

% Display the images like a filmstrip
figure;
subplot(2,5,1);imshow(images{1});title('Image 1');
subplot(2,5,2);imshow(images{2});title('Image 2');
subplot(2,5,3);imshow(images{3});title('Image 3');
subplot(2,5,4);imshow(images{4});title('Image 4');
subplot(2,5,5);imshow(images{5});title('Image 5');
subplot(2,5,6);imhist(images{1});title('Histogram 1');
subplot(2,5,7);imhist(images{2});title('Histogram 2');
subplot(2,5,8);imhist(images{3});title('Histogram 3');
subplot(2,5,9);imhist(images{4});title('Histogram 4');
subplot(2,5,10);imhist(images{5});title('Histogram 5');

%% Equalizing Images %%

for n=1:5
    
    img=images{n};
    
    img_eq=histeq(img);
    
    %images{n}=img_eq;
    
    figure();
    subplot(3,2,1);imshow(img);title('Original Image');
    subplot(3,2,2);imhist(img);title('Original Histogram');
    subplot(3,2,3);imshow(img_eq);title('Equalized Image');
    subplot(3,2,4);imhist(img_eq);title('Equalized Histogram');

    images{n}=imadjust(img_eq,[120/255 160/255], [0 1],1);
    subplot(3,2,5);imshow(images{n});title('Stretched Image');
    subplot(3,2,6);imhist(images{n});title('Stretched Histogram');

    img_eq=histeq(img);
    figure;subplot(2,1,1);imshow(img_eq);subplot(2,1,2);imhist(img_eq);

    
end

%% Parse the skin colour %%

% for n=1:5
    
    img=images{n};
    
    R=img(:,:,1);G=img(:,:,2);B=img(:,:,3);
    
    figure();
    subplot(3,1,1);imshow(R);title('Red Plane');
    subplot(3,1,2);imshow(G);title('Green Plane');
    subplot(3,1,3);imshow(B);title('Blue Plane');
end

%% Chatgpt


for i = 1:5
    
end
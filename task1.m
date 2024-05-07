%% Read all the images %%

% Directory path
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
montage(images, 'Size', [1, numel(fileList)]); title('Filmstrip of Images');
%% Improve Images %%

% test=images{1};
% 
% figure;
% subplot(2,2,1);imshow(test);
% subplot(2,2,2);imhist(test);
% 
% treated=imadjust(test,[100/255 155/255], [0 1],1);
% subplot(2,2,3);imshow(treated);
% subplot(2,2,4);imhist(treated);

folderPath='120_130';
for i= 1:1

    pre_processing=images{38};
    processing=histeq(pre_processing);


    h=figure('Name',"Pre processing" );
    subplot(2,3,1);imshow(pre_processing);
    subplot(2,3,2);imshow(processing);
    subplot(2,3,4);imhist(pre_processing)
    subplot(2,3,5);imhist(processing)

    if(double(max(processing(:)))>150/255)
        gamma=2;
    else
        gamma=0.5;
    end

    stretched=imadjust(processing,stretchlim(pre_processing));
    subplot(2,3,3);imshow(stretched);
    subplot(2,3,6);imhist(stretched);


    treated_1=imadjust(stretched,[120/255 150/255], [0 1],0.2);
    treated_2=imadjust(stretched,[120/255 150/255], [0 1],1);
    treated_3=imadjust(stretched,[120/255 150/255], [0 1],2);
    treated_4=imadjust(pre_processing,[120/255 150/255], [0 1],0.2);
    treated_5=imadjust(pre_processing,[120/255 150/255], [0 1],1);
    treated_6=imadjust(pre_processing,[120/255 150/255], [0 1],2);
    treated_7=imadjust(processing,[120/255 150/255], [0 1],0.2);
    treated_8=imadjust(processing,[120/255 150/255], [0 1],1);
    treated_9=imadjust(processing,[120/255 150/255], [0 1],2);




    figure;
    subplot(3,3,3);imshow(treated_1);title('Gamma=0.2');
    subplot(3,3,6);imshow(treated_2);title('Gamma=1');
    subplot(3,3,9);imshow(treated_3);title('Gamma=2');
    subplot(3,3,2);imshow(treated_7);title('Gamma=0.2');
    subplot(3,3,5);imshow(treated_8);title('Gamma=1');
    subplot(3,3,8);imshow(treated_9);title('Gamma=2');
    subplot(3,3,1);imshow(treated_4);title('Gamma=0.2');
    subplot(3,3,4);imshow(treated_5);title('Gamma=1');
    subplot(3,3,7);imshow(treated_6);title('Gamma=2');
end


%% 

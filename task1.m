abc=imread("Datasets\Task1\Images\img01.jpg");

% Specify the directory path
directory = 'Datasets\Task1\Images';

% Get a list of all files in the directory
fileList = dir(fullfile(directory, '*.jpg'));

% Loop through the list and read each image
for i = 1:numel(fileList)
    % Get the file name
    fileName = fullfile(directory, fileList(i).name);
    
    % Read the image
    image = imread(fileName);
    
    % Process the image as needed
    % ...
    % Your code here
    
    % Display the image
    imshow(image);
    title(fileList(i).name);
    pause(1); % Pause for 1 second before displaying the next image
end

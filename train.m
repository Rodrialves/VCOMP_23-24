%% Training %%

I=imread('Datasets\Task1\Images\img38.jpg');

figure('Name','Original');
subplot(1,2,1);imshow(I);title("Original");subplot(1,2,2);imhist(I);title("Original histo");

%% Convert to grayscale %%
Ieq=histeq(I);
I=imadjust(Ieq,[120/255 160/255], [0 1],1);

Igray=rgb2gray(I);
level=0.8;
Itresh=imbinarize(Igray,'adaptive','Sensitivity',level);
figure();imshowpair(I, Itresh, 'montage');title("Binarized image"); 
%with lighter parts don't threshold in an optimal form

%% RGB Color Spaces %%
I=imread('Datasets\Task1\Images\img38.jpg');


%Print out each one of the colour planes
rmat=I(:,:,1);
gmat=I(:,:,2);
bmat=I(:,:,3);

figure('Name','RGB');
subplot(2,2,1);imshow(rmat);title('Red Plane');
subplot(2,2,2);imshow(gmat);title('Green Plane');
subplot(2,2,3);imshow(bmat);title('Blue Plane');
subplot(2,2,4);imshow(I);title('Original Image');

%% Threshold each one of the layer %%

levelr=0.67;
levelg=0.66;
levelb=0.64;
i1=imbinarize(rmat,'adaptive','Sensitivity',levelr,'ForegroundPolarity','dark');
i2=imbinarize(gmat,'adaptive','Sensitivity',levelg);
i3=imbinarize(bmat,'adaptive','Sensitivity',levelb);
Isum=(i1&i2&i3);

%Plot the results
figure('Name','Thresholded RGB');
subplot(2,2,1);imshow(i1);title('Red Plane');
subplot(2,2,2);imshow(i2);title('Green Plane');
subplot(2,2,3);imshow(i3);title('Blue Plane');
subplot(2,2,4);imshow(Isum);title('Sum of all planes');


%%
I=imread('Datasets\Task1\Images\img38.jpg');

figure("Name","Histogram Of color planes");
subplot(3,1,1);imhist(I(:,:,1));
subplot(3,1,2);imhist(I(:,:,2));
subplot(3,1,3);imhist(I(:,:,3));

rmat=I(:,:,1);
gmat=I(:,:,2);
bmat=I(:,:,3);

radjust=imadjust(rmat,[240/255 250/255], [0 1],4);
gadjust=imadjust(gmat,[120/255 160/255], [0 1],1);
badjust=imadjust(bmat,[100/255 180/255], [0 1],0.2);


figure;
subplot(3,1,1);imshowpair(rmat, radjust, 'montage');
subplot(3,1,2);imshowpair(gmat, gadjust, 'montage');
subplot(3,1,3);imshowpair(bmat, badjust, 'montage');

figure("Name","Histogram Of color planes after adjust");
Itotal=(radjust&gadjust&badjust);
imshow(Itotal);




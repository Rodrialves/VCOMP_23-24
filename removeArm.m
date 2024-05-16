function outputImage=removeArm(inputImage,enable)
    
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
        elseif(lastRow ~= size(inputImage, 1)/4)
            lastRow = lastRow - 1;
        end
    end
   
    disp(['Row: ', num2str(lastRow)]);

    
    
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
            %dipslay the row
            disp(['Row: ', num2str(row)]);
            firstRow = row;
            break;
        end
    end

    %Display the first row and the last row
    disp(['First Row: ', num2str(firstRow), ' Last Row: ', num2str(lastRow)]);
    %Remove the arm from the image
    %Set the pixel values of the arm to 0
    ristRow = round(min(firstRow,lastRow)+(max(firstRow,lastRow)-min(lastRow,firstRow) )/4);
    inputImage(ristRow:size(inputImage,1), :) = 0;
    disp(['Rist Row: ', num2str(ristRow)]);


    if(enable==1)
         %Display the image with the arm removed
        subplot(1,2,2);imshow(inputImage); title('Image with Arm Removed');
    end
   
    outputImage=inputImage;
end

function boas(input)

end
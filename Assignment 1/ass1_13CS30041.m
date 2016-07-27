%***********************************
%*Name: Aishik Chakraborty         *
%*Roll No:13CS30041                *
%*Assignment 1                     *
%***********************************

%*****************************************************************************
%Matrices Used:
%1. I <-- Image Read (F1)
%2. gray (F1) <-- grayscale image formed from I (F1)
%3. padded <-- image formed by padding gray(F1).
%4. padded_laplacian <-- padded image formed after applying a laplacian
%5. laplacian(F2) <-- image formed after removing padding from padded
%           laplacian (F2)
%
%6. sharpened(F3) <-- sharpened image (F3)
%7. padded_sharpened <-- sharpened image with padding.
%8. padded_sobel <-- image with padding formed after applying sobel.
%9. sobel(F4) <-- image formed after removing padding from padded_sobel (F4).
%10. padded_smooth <-- padded image formed after smoothing.
%11. smooth(F5) <-- image formed afetr removing padding from padded_smooth(F5).
%12. mask(F6) <-- product of sharpened(F3) and amooth(F5)
%13. highboost(F7) <-- highboost filtering to sharpen F1.
%******************************************************************************

%start of program
clear;  
I = imread('test1_13CS30041.jpg');      %read image F1
gray = rgb2gray(I);                     %convert to grayscale image
gray = im2double(gray);                 %covert matrix type to double
rows_gray = size(gray,1);
cols_gray = size(gray,2);
rows_padded = rows_gray + 2;
cols_padded = cols_gray +2;
padded(1:rows_padded,1:cols_padded)=0.00;   %padded matrix
for i=1:rows_padded                         %loop to pprovide padding
    for j=1:cols_padded
        if i==1 || j==1
            padded(i,j) = 0.00;
        
        elseif i==rows_padded || j==cols_padded
            padded(i,j) = 0.00;
        else
            padded(i,j) = gray(i-1,j-1);
        end
    end
end
padded_laplace(1:rows_padded,1:cols_padded)=0.00;       %padded image formed after applying lapcian
for i=2:rows_padded-1
    for j=2:cols_padded-1
        padded_laplace(i,j) = padded(i+1,j) + padded(i-1,j) + padded(i,j+1) + padded(i,j-1) + padded(i-1,j-1) + padded(i+1,j+1) + padded(i+1,j-1) + padded(i-1,j+1) - 8*padded(i,j);
        padded_laplace(i,j) = padded_laplace(i,j)/16;
    end
end

laplace(1:rows_gray,1:cols_gray)=0.00;

for i=2:rows_padded-1
    for j=2:cols_padded-1
        laplace(i-1,j-1) = padded_laplace(i,j);     %laplacian formed after removing padding (F2)
    end
end
max = laplace(1,1);
min = laplace(1,1);
for i=1:rows_gray
    for j=1:cols_gray
        if(laplace(i,j) > max)
            max = laplace(i,j);
        end
        if(laplace(i,j)<min)
            min = laplace(i,j);
        end
    end
end

sharpened = gray - laplace;         %sharpened image (F3)
padded_sharpened = padded - padded_laplace;     

for i=1:rows_gray
    for j=1:cols_gray
        laplace(i,j) = (laplace(i,j) - min)/(max - min);    %scaling done to convert negative intensities to positive on laplacian
    end
end

padded_sobel(1:rows_padded,1:cols_padded)=0.00;     %padded matrix after applying sobel on F3.

for i=2:rows_padded-1       %loop to find padded_sharpened
    for j=2:cols_padded-1
        x = -padded_sharpened(i-1,j-1) - 2*padded_sharpened(i-1,j) - padded_sharpened(i-1,j+1) + padded_sharpened(i+1,j-1) + 2*padded_sharpened(i+1,j) + padded_sharpened(i+1,j+1) ;
        y = -padded_sharpened(i-1,j-1) - 2*padded_sharpened(i,j-1) - padded_sharpened(i+1,j-1) + padded_sharpened(i,j+1) + 2*padded_sharpened(i,j+1) + padded_sharpened(i+1,j+1) ;
        padded_sobel(i,j) = sqrt(x*x + y*y);
    end
end

sobel(1:rows_gray,1:cols_gray)=0.00;

for i=2:rows_padded-1
    for j=2:cols_padded-1
        sobel(i-1,j-1) = padded_sobel(i,j); %remove padding on F4.
    end
end

padded_smooth(1:rows_padded,1:cols_padded)=0.00;
for i=2:rows_padded-1       %loop to find padded_sobel
    for j=2:cols_padded-1
        padded_smooth(i,j) = padded_sobel(i+1,j) + padded_sobel(i-1,j) + padded_sobel(i,j+1) + padded_sobel(i,j-1) + padded_sobel(i-1,j-1) + padded_sobel(i+1,j+1) + padded_sobel(i+1,j-1) + padded_sobel(i-1,j+1) + padded_sobel(i,j);
        padded_smooth(i,j) = padded_smooth(i,j)/9.0;
    end
end

smooth(1:rows_gray,1:cols_gray)=0.00;

for i=2:rows_padded-1
    for j=2:cols_padded-1
        smooth(i-1,j-1) = padded_smooth(i,j);
    end
end

mask = sharpened.*smooth;   %obtain mask<-- product of F3, F5
%mask = mask.*1.2;

highboost = gray + mask.*1.3;   %highboost filtering, used k=1.3

imshow(gray);                   %show the different images one by one
figure,imshow(laplace);
figure,imshow(sharpened);
figure,imshow(sobel);
figure,imshow(smooth);
figure,imshow(mask);
figure,imshow(highboost);
%end of program
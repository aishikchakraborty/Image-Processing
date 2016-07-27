%---------------------------------
%Name: Aishik Chakraborty         |
%Roll No.: 13CS30041              |
%Assignment 2                     |
%---------------------------------


%start of program

clear all;
clc;
close all;

%Read RGB image. 
%It is assumed that the candies are either fully red or green or blue
I = imread('test1_13CS30041.jpg');

figure('name', 'Input Image');
imshow(I);

gray = rgb2gray(I);

[x,y,z] = size(I);
%array to store information of only the red portion
R = zeros(x, y);

%array to store information of only the green portion
G = zeros(x, y);

%array to store information of only the blue portion
B = zeros(x, y);

fprintf('--------------------------Assignment 2-----------------------------\n');
fprintf('\nThe image dimensions are:\n');
fprintf('x = %d\ny = %d\nz = %d\n',x,y,z);

count_arr = zeros(1,256);
%maintain count of intensity in grayscale
for i= 1:x
    for j = 1:y
        count_arr(gray(i,j) + 1) = count_arr(gray(i,j) + 1) + 1;
    end
end

%find largest intensity in grayscale
max_count = 0;
largest_intensity = 0;
for i = 1:256
    if max_count<count_arr(i)
        max_count = count_arr(i);
        largest_intensity = i-1;
    end
end

%perform thresholding
for i= 1:x
    for j = 1:y
        if gray(i,j) > 0.9*largest_intensity
            gray(i,j) = 255;
        else
            gray(i,j) = 0;
        end;
    end
end

gray = im2double(gray);
gray = im2bw(gray, 0.5);
%figure, imshow(gray);


%find complement of image for component finding
gray = ~gray;

figure('name', 'Thresholded Final Image');
imshow(gray);
se_bin = strel('disk', 12);


eroded_im = imerode(gray, se_bin);
eroded_im = imerode(eroded_im, se_bin);

%eroded_im = imdilate(eroded_im, se);
figure('name', 'Separated Image');
imshow(eroded_im);

[Candy_bin, n] = bwlabel(eroded_im, 8);

fprintf('\nTotal number of candies in the image is %d\n', n);

rad=zeros(1,n);
c1 = zeros(1,n);
c2 = zeros(1,n);
for k = 1:n
    [r, c]= find(Candy_bin == k);
    rad(k) = (max(r) - min(r))/2;
    c1(k) = min(r) + rad(k);
    c2(k) = min(c) + rad(k);
end        

%As nothing is mentioned, we can assume that the radius of candies which
%occur most frequently are the ones that were intended to be made

%Thus in the following loops we find the maximum number of occurences of a
%radius and take that radius to be the intended radius.
max_count=0;
for i = 1:n
    c=0;
    temp = rad(i);
    for j = 1:n
        if rad(j) == temp
            c = c + 1;
        end
    end
    if c > max_count
        max_count = c;
        max_rad = temp;
    end
end 

%max_rad = max(rad);
fprintf('\nThe Approximate Radius of original candy is %d \n',max_rad);

fprintf('\nThe number of candies according to specification is: %d \n',max_count);


%find pixel info at coordinates of centres of circles
P = impixel(I,c2,c1);
r_count = 0;
g_count = 0;
b_count = 0;
%disp(P);

for i = 1:n
    if P(i,1)>250 && P(i,1)<=255
        r_count = r_count + 1;
    end
    if P(i,2)>250 && P(i,2)<=255
        g_count = g_count + 1;
    end
    if P(i,3)>250 && P(i,3)<=255
        b_count = b_count + 1;
    end
end

%se = strel('disk', 40);

fprintf('\n\n-------------------Color Count-----------------------------\n');

fprintf('The number of Red colored candies are %d\n',r_count);
fprintf('The number of Green colored candies are %d\n',g_count);
fprintf('The number of Blue colored candies are %d\n',b_count);


fprintf('\n\n---------------------Final result---------------------------\n');
if n == max_count
    fprintf('\nAll candies are upto specification\n');
else
    fprintf('\nWARNING!! All candies are not upto specification\n');
end
fprintf('\n-------------------------------------------------------------\n');

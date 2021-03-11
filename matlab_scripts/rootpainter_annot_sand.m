%
%% Script to create RootPainter sparsely annotated slices from densely hand-annotated slices of methane-bearing sand XCT 
% This script can ONLY work with a stack of tiffs. It should be use with a
% stack containing tiff of 572x572 pixels in size. Labels must be 0 =
% sand, 1 = brine, 2 = methane gas.
%% Start of code
%
waitfor (helpdlg({'Please select one label image'},'Info'));
[Filename, pathname] = uigetfile({'*.tif;*.tiff'},'Select label image');
[numslice, justname, slicelist] = slicecount(pathname, Filename);
waitfor (helpdlg({'Please select saving directory'},'Info'));
savepath = uigetdir(pwd, 'Select saving folder');

for n=1:numslice
   disp(['Saving annotated slice number ', num2str(n)]); %print log
   slice = imread(strcat(slicelist(n).folder,'\',slicelist(n).name)); 
   slice = slice + 1;
   fg_painter = uint8(slice == 1);
   bg_painter = uint8(zeros(size(slice)));
   
   % Dilating:
   se = strel('square',100);
   fg_dil = imdilate(fg_painter, se);
   fg_dil = (fg_dil-fg_painter);
   bg_painter = bg_painter + fg_dil;
   bg_painter(bg_painter == 5) = 1;
   
   % retaining just one quadrant
   fg_painter_quadrant = uint8(zeros(size(slice)));
   fg_painter_quadrant(1:floor(length(fg_painter)/2), 1:floor(length(fg_painter)/2)) = fg_painter(1:floor(length(fg_painter)/2), 1:floor(length(fg_painter)/2));
   fg_painter = fg_painter_quadrant;
   bg_painter_quadrant = uint8(zeros(size(slice)));
   bg_painter_quadrant(1:floor(length(fg_painter)/2), 1:floor(length(fg_painter)/2)) = bg_painter(1:floor(length(fg_painter)/2), 1:floor(length(fg_painter)/2));
   bg_painter = bg_painter_quadrant;
   
   % creating 32-bit RGB png
   fg_painter(fg_painter == 1) = 255;
   bg_painter(bg_painter == 1) = 255;
   emp_painter = uint8(zeros(size(slice))); %empty space without annotations
   alpha = uint8(zeros(size(slice)));
   alpha = alpha + bg_painter;
   alpha = alpha + fg_painter;
   alpha = double(alpha).*(180/255);
   alpha = alpha./255;
   rgb_annot = cat(3,fg_painter,bg_painter,emp_painter);
   
   % RootPainter annotation slices should be named exactly the same as the
   % tiff files to be segmented. User NEEDS to check that the string
   % concatenation below produces the desired file name.
   resname = slicelist(n).name;
   resname = resname(1:end-10);
   resnum = sprintf('%04d', n-1);
   resname = strcat(resname,'_',resnum,'.png');
   
   % Saving output
   imwrite(rgb_annot,strcat(savepath,'\',resname),'BitDepth', 8, 'Alpha', alpha);
%   
end
%
%% Functions
function [numslice, justname, slicelist] = slicecount(pathname, Filename)
filetype = ismember(Filename,'.'); % checking where file type starts
for n = 1:length(filetype)
    if filetype(n) == 1
        break
    end
end
justname = Filename(1:n-1); % getting the name, which may contain numbers
justname = justname(1:end-4); % getting the part of the name which is just letters, i.e. the 'handle'
slicelist = dir([pathname justname '*']); % counting the number of images in folder with such handle
numslice = size(slicelist,1);
end
%